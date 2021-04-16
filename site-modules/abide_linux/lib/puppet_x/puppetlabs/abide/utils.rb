# frozen_string_literal: true

require 'puppet_x'

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.3.0')
  require 'backport_dig'
end

# Extension module for puppetlabs-abide
module PuppetX::Abide
  # Subclass of StandardError used as abstract for other custom errors
  class GenericAbideError < StandardError
    @default = 'Generic error:'
    class << self
      attr_reader :default
    end

    attr_reader :subject
    def initialize(subject = nil, msg: self.class.default)
      @msg = msg
      @subject = subject
      message = subject.nil? ? @msg : "#{@msg} #{@subject}"
      super(message)
    end
  end

  # Raised when a an object is initialized with a nil param
  class NewObjectParamNilError < GenericAbideError
    @default = 'Object init parameter is nil and should not be:'
  end

  # Raised when a file path does not exist
  class FileNotFoundError < GenericAbideError
    @default = 'File not found:'
  end

  # Raised when a file path is not a regular file
  class FileNotRegularError < GenericAbideError
    @default = 'Path is not a regular file:'
  end

  # Raised when a searched for service is not found in the parser
  class ServiceNotFoundError < GenericAbideError
    @default = 'Service not found:'
  end

  # Raised when getting an InetdConfConfig object that does not exist
  class ConfigObjectNotFoundError < GenericAbideError
    @default = 'Config object not found:'
  end

  # Raised when adding an InetdConfConfig object that already exists
  class ConfigObjectExistsError < GenericAbideError
    @default = 'Config object already exists:'
  end
end
