# frozen_string_literal: true

require 'puppet_x'
require 'erb'
require_relative './utils'

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.3.0')
  require 'backport_dig'
end

# Extension module for puppetlabs-abide
module PuppetX::Abide
  # Writes new or updates (x)inetd conf files
  class InetdConfWriter
    @full_template = <<-EOF
# This file is managed by Puppet
<% unless @parser.defaults.nil? || @parser.defaults.configs.empty? -%>
defaults
{
<% @parser.defaults.configs.each do |c| -%>
    <%= c.to_s %>
<% end -%>
}
<% end -%>

<% unless @parser.services.empty? -%>
<% @parser.services.each do |s| -%>
service <%= s.name %>
{
  <% s.configs.each do |c| -%>
  <%= c.to_s %>
  <% end -%>
}
<% end -%>
<% end -%>

<% unless @parser.include_dirs.empty? -%>
<% @parser.include_dirs.each do |i| -%>
<%= i.to_s %>
<% end -%>
<% end -%>
    EOF
    class << self
      attr_reader :full_template
    end

    attr_accessor :parser

    # Creates a new InetdConfWriter object
    # @param [Array<Object>] one or more InetdConfParser objects
    def initialize(parser)
      @parser = parser
    end

    # Populates an ERB template with values from the given InetdConfParser object
    # and writes the template to the parser's file_path, overwriting the current
    # conf file.
    # @note This will fully overwrite the conf file parsed by the InetdConfParser object
    # @param parser [InetdConfParser] a parser object for the conf file
    # @raise [FileNotFoundError] if parser's file_path does not exist
    # @raise [FileNotRegularError] if parser's file_path is not a regular file
    def write
      raise FileNotFoundError unless File.exist?(@parser.file_path)
      raise FileNotRegularError unless File.file?(@parser.file_path)
      renderer = ERB.new(self.class.full_template, 0, '<>-')
      File.open(@parser.file_path, 'w+') { |f| f.write(renderer.result(binding)) }
    end
  end

  # InetdConfParser is a top-down parser that closely resembles a
  # LL(1) parser, but the parse table (defined in class constants)
  # is not as granular as a typical LL(1) parse table. Due to the
  # simple nature of (x)inetd conf files, we are able to take some
  # shortcuts and deviate from traditional character by character
  # parsing with the help of regular expressions.
  # @author heston.snodgrass@puppet.com
  # @note Aside from file_path, attributes are read / write. However,
  #   adding objects to defaults, services, and include_dirs is only
  #   meaningful if you use the parser object with a write_ method of
  #   the InetdConfWriter class.
  # @!attribute [r] file_path
  #   @return [String] The parsed conf file path. Given at object initialization.
  # @!attribute defaults
  #   @return [InetdConfDefaults] A container object for the defaults block
  #     of a conf file
  # @!attribute services
  #   @return [Array<InetdConfService] A container of conf service block objects
  # @!attribute include_dirs
  #   @return [Array<InetdConfIncludeDir>] A container of conf includedir statement objects
  # @example Parse a file
  #   parser = InetdConfParser.new('/etc/xinetd.conf')
  class InetdConfParser
    attr_reader :file_path
    attr_accessor :defaults, :services, :include_dirs

    # @!group ParseTable Regexp patterns for parsing
    UTF_SPACE = %r{\p{Zs}}.freeze
    TAB = %r{\t}.freeze
    WHITESPACE = %r{#{UTF_SPACE.source}|#{TAB.source}}.freeze
    NEWLINE = %r{\n}.freeze
    COMMENT = %r{\#}.freeze
    BLOCK_OPEN = %r{\{}.freeze
    BLOCK_CLOSE = %r{\}}.freeze
    SPECIAL = %r{#{UTF_SPACE.source}#{TAB.source}#{NEWLINE.source}#{COMMENT.source}#{BLOCK_OPEN.source}#{BLOCK_CLOSE.source}}.freeze
    NOTSPECIAL = %r{\[^#{UTF_SPACE.source}#{TAB.source}#{NEWLINE.source}#{COMMENT.source}#{BLOCK_OPEN.source}#{BLOCK_CLOSE.source}\]}.freeze
    VALID_NAME = %r{[A-Za-z]\w+}.freeze
    OP = %r{[+=]{1,2}}.freeze
    DEFAULTS = %r{^defaults\s*#{BLOCK_OPEN.source}}.freeze
    SERVICE = %r{^service\s+?(#{VALID_NAME.source})\s*#{BLOCK_OPEN.source}}.freeze
    OPTION = %r{^(#{VALID_NAME.source})(?:#{WHITESPACE.source})+(#{OP.source})(?:#{WHITESPACE.source})+([^\n]+)+}.freeze
    INCLUDE_DIR = %r{^includedir(?:#{WHITESPACE.source})([^\n]+)+}.freeze
    OBJ_START = %r{d|i|s}.freeze
    # !@endgroup

    # Initializes a new parser object by parsing the given file
    # @param file_path [String] the conf file path
    # @raise [FileNotFoundError] if file_path does not exist
    # @raise [FileNotRegularError] if file_path is not regular file
    def initialize(file_path)
      raise NewObjectParamNilError, 'file_path' if file_path.nil?
      @file_path = file_path
      @buffer = nil
      @buffer_size = 0
      @defaults = nil
      @services = []
      @include_dirs = []
      @iterations = 0
      parse
    end

    # Creates a new StringScanner from the given file path and
    # assigns it to the instance variable buffer.
    # @param file_path [String] the conf file path
    # @raise [FileNotFoundError] if file_path does not exist
    # @raise [FileNotRegularError] if file_path is not regular file
    def new_buffer(file_path)
      raise FileNotFoundError, file_path unless File.exist?(file_path)
      raise FileNotRegularError, file_path unless File.file?(file_path)
      require 'strscan'
      str = File.read(file_path)
      @buffer_size = str.length
      @buffer = StringScanner.new(str)
    end

    # Parses a (x)inetd conf file. This method is called during class initialization.
    # In order to prevent infinite loops, the parser only parses until the buffer is
    # exhausted or the number of parsing iterations (calls to the parse_any method)
    # exceed the total size of the buffer at buffer creation.
    def parse
      new_buffer(@file_path)
      until @buffer.eos? || @iterations > @buffer_size
        parse_any
        @iterations += 1
      end
    end

    # Basic parser method for any type of character. Performs a
    # 1 character lookahead and skips the buffer position over
    # the character if it is whitespace or a newline, and skips
    # the buffer position to the next newline character if it is
    # a pound symbol (#) to ignore comments. If the character is
    # 'd', 'i', or 's', we call the parse_obj method. If the
    # character still accounted for, we skip the buffer position
    # to the next newline character.
    def parse_any
      next_char = @buffer.peek(1)
      case next_char
      when WHITESPACE
        @buffer.skip(WHITESPACE)
      when NEWLINE
        @buffer.skip(NEWLINE)
      when COMMENT
        @buffer.skip_until(NEWLINE)
      when BLOCK_CLOSE
        @buffer.skip(BLOCK_CLOSE)
      when OBJ_START
        parse_obj
      else
        @buffer.skip_until(NEWLINE)
      end
    end

    # Parser method for potential objects (defaults, service, includedir)
    # This method performs a 2-character lookahead and attempts to parse
    # either a defaults block, a service block, or an includedir statement
    # based on the first two characters of the block / statement designator
    # ('de', 'se', or 'in', respectively). If the method matches a service
    # or defaults pattern, it calls the parse_object method and adds the
    # relevant return values to the respective instance variable. If the method
    # matches an includedir pattern, it creates a InetdConfIncludeDir object and
    # adds the object to the relevant instance variable. If the parse fails,
    # the function returns nil and the parse_any method resumes.
    def parse_obj
      next_two = @buffer.peek(2)
      if next_two == 'de'
        parsed = parse_block(DEFAULTS)
        unless parsed[0].nil? && parsed[1].empty?
          @defaults = InetdConfDefaults.new if @defaults.nil?
          @defaults.configs = parsed[1]
        end
      elsif next_two == 'se'
        parsed = parse_block(SERVICE)
        unless parsed[0].nil? && parsed[1].empty?
          @services.push(InetdConfService.new(parsed[0], parsed[1]))
        end
      elsif next_two == 'in'
        scanned = @buffer.scan(INCLUDE_DIR)
        unless scanned.nil?
          parts = scanned.match(INCLUDE_DIR)
          @include_dirs.push(InetdConfIncludeDir.new(parts[1]))
        end
      end
    end

    # Parses blocks, or the options inbetween {} in defaults and services
    # This method starts by scanning the the given pattern for the
    # start of an object (defaults block or service block)
    # and then, if that scan found the pattern, continues scanning for
    # config assignment statements (name operator value). Before each
    # config assignment statement scan, we perform a 1-character lookahead
    # which stops the scanning if the character is a '}' signifying the
    # end of the block. What gets returned is a service name (if applicable)
    # and an array of InetdConfConfig objects for each config found in the
    # block. This method works like similar recursive strategies implemented
    # by traditional parsers, but since we do not have arbitrary statement
    # nesting depth in (x)inetd conf files recursion is unnecessary.
    # @param obj_pattern [Regexp] Regexp pattern for matching an object
    # @return [Array<String, Array>] if match is found, returns array with
    #   pattern object name, object options
    # @return [Array<nil, Array] if no match is found, object name is nil
    #   and object options is an empty array.
    def parse_block(obj_pattern)
      obj_name = nil
      obj_opts = []
      obj = @buffer.scan(obj_pattern)
      unless obj.nil?
        obj_name = obj.match(SERVICE)[1] if obj.match?(SERVICE)
        until @buffer.peek(1) == '}' || @buffer.eos? || @iterations > @buffer_size
          opt = @buffer.scan(OPTION)
          if opt.nil?
            @buffer.getch
          else
            parts = opt.match(OPTION)
            unless parts.nil?
              new_opt = InetdConfConfig.new(parts[1], parts[2], parts[3])
              obj_opts.append(new_opt)
            end
          end
        end
      end
      [obj_name, obj_opts]
    end

    # Returns a map of instance variables with attr_accessors that
    # are not empty or nil. The map keys are symbols of the attrs.
    # @return [Hash] read-write instance variables with values
    def populated_attrs
      attrs = {}
      instance_variables.each do |var|
        str = var.to_s.gsub(%r{^@}, '')
        next unless respond_to?("#{str}=")
        ivar = instance_variable_get var
        next if ivar.respond_to?(:nil?) && ivar.nil?
        next if ivar.respond_to?(:empty?) && ivar.empty?
        attrs[str.to_sym] = ivar
      end
      attrs
    end

    # Retrieves an object in a given attribute by object name.
    # In the case of checking for an includedir statement, it
    # compares the given name to the dir attribute of the
    # InetdConfIncludeDir object.
    # @param name [String] the name (or directory) of the object
    # @param obj_attr [String, Symbol] the parser attribute to search in
    # @return [InetdConfService, InetdConfIncludeDir, InetdConfDefaults, InetdConfConfig, nil]
    #   returns the object found or nil. If name is specified as 'defaults', returns the
    #   defaults object. If name is a config name, returns the config object from defaults.
    def get(name, obj_attr)
      p_attrs = populated_attrs
      found_attr = obj_attr.respond_to?(:to_sym) ? p_attrs[obj_attr.to_sym] : p_attrs[obj_attr]
      if found_attr.respond_to?(:each)
        found_attr.each do |obj|
          return obj if obj.is_a?(InetdConfService) && obj.name == name
          return obj if obj.is_a?(InetdConfIncludeDir) && obj.dir == name
        end
      end
      return found_attr if found_attr.is_a?(InetdConfDefaults) && name == 'defaults'
      return found_attr.get(name) if found_attr.is_a?(InetdConfDefaults)
      nil
    end

    # Checks for an object in a given attribute by object name.
    # In the case of checking for an includedir statement, it
    # compares the given name to the dir attribute of the
    # InetdConfIncludeDir object.
    # @param name [String] the name (or directory) of the object
    # @param obj_attr [String, Symbol] the parser attribute to search in
    # @return [true, false] if the object is found or not
    def has?(name, obj_attr)
      return true unless get(name, obj_attr).nil?
      false
    end
  end

  # Holds configuration value for parser
  # @!attribute [r] name
  #   @return [String] the left-hand side (name) of an option
  # @!attribute [r] op
  #   @return [String] the option assignment operator (either = or +=)
  # @!attribute [r] value
  #   @return [String] the right-hand side (value) of an option
  class InetdConfConfig
    attr_reader :name, :op, :value

    # Initializes a new InetdConfConfig object
    # @param name [String] the left-hand side (name) of an option
    # @param op [String] the option assignment operator (either = or +=)
    # @param value [String] the right-hand side (value) of an option
    def initialize(name, op, value)
      @name = name
      @op = op
      @value = value
    end

    # Creates a string from the object
    # @return [String] a string representation of the object
    #   that can be used in conf files
    def to_s
      "#{@name} #{@op} #{@value}"
    end

    # Creates a hash from the object
    # @return [Hash] a hash representation of the object
    def to_h
      { name: @name, operator: @op, value: @value }
    end

    # Creates an array from the object
    # @return [Array<String>] an array representation of the object
    def to_a
      [@name, @op, @value]
    end
  end

  # Holds a defaults block for parser
  # @!attribute configs
  #   @return [Array<InetdConfConfig>] an array of InetdConfConfig objects
  #     that represent options in the defaults block
  class InetdConfDefaults
    attr_accessor :configs

    # Creates a new InetdConfDefaults object
    # @param configs [Array<InetdConfConfigs>] an array of InetdConfConfig objects
    def initialize(configs = [])
      @configs = configs
    end

    # Adds a new InetdConfConfig object to configs. Checks if config
    #   exists before adding new config and will not add a new config
    #   that shares a name with an existing config. If force param is
    #   set to true, overrides this check and immediately adds the new
    #   config. Raises ConfigObjectExists if force is not set to true
    #   and a duplicate config is found.
    # @param name [String] name of new config object
    # @param op [String] assignment operator for new config object
    # @param value [String] value for new config object
    # @param force [Boolean] whether or not to execute existance check
    #   before adding new config object
    # @raise [ConfigObjectExists] if config object with same name exists
    #   in configs attribute and force param is false
    def add(name, op, value, force: false)
      if force
        @configs.push(InetdConfConfig.new(name, op, value))
        return
      end
      @configs.each do |i|
        if i.name == name
          raise ConfigObjectExists
        end
      end
      @configs.push(InetdConfConfig.new(name, op, value))
    end

    # Returns an InetdConfConfig object from the configs attribute based on name.
    #   If no object is found, returns nil instead.
    # @param conf_key [String] the name attribute of the InetdConfConfig object
    # @return [InetdConfConfig] if an object with name exists in configs
    # @return [nil] if an object with name does not exist in configs
    def get(conf_key)
      @configs.each do |i|
        if i.name == conf_key
          return i
        end
      end
      nil
    end

    # Deletes an InetdConfConfig object from the configs attribute based on name.
    #   Does nothing if object is not found in configs attribute.
    # @param conf_key [String] the name attribute of the InetdConfConfig object
    def remove(conf_key)
      has_item = false
      item_idx = nil
      @configs.each_with_index do |i, idx|
        next unless i.name == conf_key
        has_item = true
        item_idx = idx
      end
      @configs.delete_at(item_idx) if has_item
    end

    # Updates an InetdConfConfig object in the configs attribute based on name.
    #   If the object exists in configs, and the objects op or value differ from
    #   the given op or value, a new object is created with the new attributes
    #   and the old object is replaced.
    # @param conf_key [String] the name attribute of the InetdConfConfig object
    # @param op [String] the new config assignment operator (=, +=)
    # @param value [String] the new config value
    def update(conf_key, op: nil, value: nil)
      op_update = false
      value_update = false
      item_idx = nil
      @configs.each_with_index do |i, idx|
        next unless i.name == conf_key
        item_idx = idx
        op_update = true unless i.op == op && !op.nil?
        value_update = true unless i.value == value && !value.nil?
      end
      return unless op_update || value_update
      new_op = op_update ? op : @configs[item_idx].op
      new_value = value_update ? value : @configs[item_idx].value
      @configs[item_idx] = InetdConfConfig.new(conf_key, new_op, new_value)
    end

    # Creates a string from the object
    # @return [String] a string representation of the object
    #   that can be used in conf files
    def to_s
      strings = []
      @configs.each { |c| strings.push(c.to_s) }
      "defaults #{strings.join(',')}"
    end

    # Creates a hash from the object
    # @return [Hash] a hash representation of the object
    def to_h
      hashes = []
      @configs.each { |c| hashes.push(c.to_h) }
      { name: 'defaults', configs: hashes }
    end
  end

  # Holds a service block for parser
  # @!attribute [r] name
  #   @return [String] the service name
  # @!attribute configs
  #   @return [Array<InetdConfConfig>] an array of InetdConfConfig objects
  #     that represent options in the service's block
  class InetdConfService
    attr_reader :name
    attr_accessor :configs

    # Creates a new InetdConfService object
    # @param name [String] the service name
    # @param configs [Array<InetdConfConfig>] an array of InetdConfConfig objects
    def initialize(name, configs = [])
      @name = name
      @configs = configs
    end

    # Check if this object has a 'disable = yes' config
    # return [true] if configs contain object representing 'disable = yes'
    # return [false] if configs do not contain object representing 'disable = yes'
    def disabled?
      @configs.each do |i|
        if i.name == 'disable' && i.op == '=' && i.value == 'yes'
          return true
        end
      end
      false
    end

    # Adds a new InetdConfConfig object to configs. Checks if config
    #   exists before adding new config and will not add a new config
    #   that shares a name with an existing config. If force param is
    #   set to true, overrides this check and immediately adds the new
    #   config. Raises ConfigObjectExists if force is not set to true
    #   and a duplicate config is found.
    # @param name [String] name of new config object
    # @param op [String] assignment operator for new config object
    # @param value [String] value for new config object
    # @param force [Boolean] whether or not to execute existance check
    #   before adding new config object
    # @raise [ConfigObjectExists] if config object with same name exists
    #   in configs attribute and force param is false
    def add(name, op, value, force: false)
      if force
        @configs.push(InetdConfConfig.new(name, op, value))
        return
      end
      @configs.each do |i|
        if i.name == name
          raise ConfigObjectExists, name
        end
      end
      @configs.push(InetdConfConfig.new(name, op, value))
    end

    # Returns an InetdConfConfig object from the configs attribute based on name.
    #   If no object is found, returns nil instead.
    # @param conf_key [String] the name attribute of the InetdConfConfig object
    # @return [InetdConfConfig] if an object with name exists in configs
    # @return [nil] if an object with name does not exist in configs
    def get(conf_key)
      @configs.each do |i|
        if i.name == conf_key
          return i
        end
      end
      nil
    end

    def has?(conf_key)
      return true unless get(conf_key).nil?
      false
    end

    # Deletes an InetdConfConfig object from the configs attribute based on name.
    #   Does nothing if object is not found in configs attribute.
    # @param conf_key [String] the name attribute of the InetdConfConfig object
    def remove(conf_key)
      has_item = false
      item_idx = nil
      @configs.each_with_index do |i, idx|
        next unless i.name == conf_key
        has_item = true
        item_idx = idx
      end
      @configs.delete_at(item_idx) if has_item
    end

    # Updates an InetdConfConfig object in the configs attribute based on name.
    #   If the object exists in configs, and the objects op or value differ from
    #   the given op or value, a new object is created with the new attributes
    #   and the old object is replaced.
    # @param conf_key [String] the name attribute of the InetdConfConfig object
    # @param op [String] the new config assignment operator (=, +=)
    # @param value [String] the new config value
    def update(conf_key, op: nil, value: nil)
      op_update = false
      value_update = false
      item_idx = nil
      @configs.each_with_index do |i, idx|
        next unless i.name == conf_key
        item_idx = idx
        op_update = true unless i.op == op && !op.nil?
        value_update = true unless i.value == value && !value.nil?
      end
      return add(conf_key, op, value) if item_idx.nil? && !op.nil? && !value.nil?
      return unless op_update || value_update
      new_op = op_update ? op : @configs[item_idx].op
      new_value = value_update ? value : @configs[item_idx].value
      @configs[item_idx] = InetdConfConfig.new(conf_key, new_op, new_value)
    end

    # Creates a string from the object
    # @return [String] a string representation of the object
    #   that CAN NOT be used in conf files
    def to_s
      conf_strings = []
      @configs.each { |c| conf_strings.push(c.to_s) }
      "#{@name} #{conf_strings.join(',')}"
    end

    # Creates a hash from the object
    # @return [Hash] a hash representation of the object
    def to_h
      conf_hashes = []
      @configs.each { |c| conf_hashes.push(c.to_h) }
      { name: @name, configs: conf_hashes, disabled: disabled? }
    end
  end

  # Holds an includedir line for parser
  # @!attribute [r] dir
  #   @return [String] the directory specified in the includedir statement
  class InetdConfIncludeDir
    attr_reader :dir

    # Creates a new InetdConfIncludeDir object
    # @param dir [String] the directory specified in the includedir statement
    def initialize(dir)
      @dir = dir
    end

    # Gets existing files in dir
    # @return [Array<string>] paths to files that exist in dir
    def included_files
      files = []
      if Dir.exist?(@dir)
        chld = Dir.children(@dir)
        chld.each { |c| files.push("#{@dir}/#{c}") }
      end
      files
    end

    # Creates a string from the object
    # @return [String] a string representation of the object
    #   that can be used in conf files
    def to_s
      "includedir #{@dir}"
    end
  end
end
