# frozen_string_literal: true

require 'puppet_x'
require_relative './utils'
require_relative './inetd_conf_parser'

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.3.0')
  require 'backport_dig'
end

# Extension module for puppetlabs-abide
module PuppetX::Abide
  # Provides helper methods for the inetd service provider
  class InetdProviderHelper
    def initialize(context)
      @context = context
    end

    def split_config_attr(attr)
      parts = attr.split(' ')
      cfg_name = parts[0]
      cfg_op = parts[1]
      cfg_value = parts[2..-1].join(' ')
      [cfg_name, cfg_op, cfg_value]
    end

    def services_from_parsed_files(svc_container, parsed_files)
      parsed_files.each do |f|
        next if f.services.empty?
        source = f.file_path
        f.services.each do |s|
          svc = InetdProviderService.new(s.to_h, source)
          svc_container.push(svc.to_h)
        end
      end
    end

    def parser_objects_from_paths(parser_container, paths)
      paths.each do |p|
        begin
          pfile = InetdConfParser.new(p)
          parser_container.push(pfile)
        rescue FileNotFoundError, FileNotRegularError => error
          @context.err(error)
        end
      end
    end

    def parse_include_dir_files(parsed_files)
      recursed_container = []
      parsed_files.each do |pf|
        next if pf.include_dirs.empty?
        pf.include_dirs.each do |idir|
          inc_files = idir.included_files
          next if inc_files.nil? || inc_files.empty?
          parser_objects_from_paths(recursed_container, inc_files)
        end
      end
      recursed_container
    end

    def get(conf_files, recurse = true)
      parsed_files = []
      all_services = []
      parser_objects_from_paths(parsed_files, conf_files)
      recursed_files = parse_include_dir_files(parsed_files) if recurse
      services_from_parsed_files(all_services, parsed_files)
      services_from_parsed_files(all_services, recursed_files) unless recursed_files.nil? || recursed_files.empty?
      all_services
    end

    def create(name, should)
      pfile = InetdConfParser.new(should[:source])
      new_svc = InetdConfService.new(name)
      should[:attributes].each do |attr|
        cfg_name, cfg_op, cfg_value = split_config_attr(attr)
        new_svc.add(cfg_name, cfg_op, cfg_value, force: true)
      end
      pfile.services << new_svc
      writer = InetdConfWriter.new(pfile)
      writer.write
    end

    def update(name, should)
      pfile = InetdConfParser.new(should[:source])
      svc_idx = nil
      pfile.services.each_with_index do |s, idx|
        next unless s.name == name
        svc_idx = idx
      end
      raise ServiceNotFoundError if svc_idx.nil?
      should[:attributes].each do |attr|
        cfg_name, cfg_op, cfg_value = split_config_attr(attr)
        pfile.services[svc_idx].update(cfg_name, op: cfg_op, value: cfg_value)
      end
      writer = InetdConfWriter.new(pfile)
      writer.write
    end

    def delete_service_from_parsed(pfile, name)
      svc_idx = nil
      pfile.services.each_with_index do |s, idx|
        next unless s.name == name
        svc_idx = idx
      end
      pfile.services.delete_at(svc_idx)
      pfile
    end

    def delete(name, default_conf_paths, recurse = true)
      parsed_files = []
      recursed_files = []
      parser_objects_from_paths(parsed_files, default_conf_paths)
      recursed_files = parse_include_dir_files(parsed_files) if recurse
      parsed_files.each do |f|
        pfile = delete_service_from_parsed(f, name)
        writer = InetdConfWriter.new(pfile)
        writer.write
      end
      return if recursed_files.empty?
      recursed_files.each do |f|
        pfile = delete_service_from_parsed(f, name)
        writer = InetdConfWriter.new(pfile)
        writer.write
      end
    end
  end

  # Represents a single service hash for provider output
  class InetdProviderService
    attr_accessor :service, :source

    def initialize(parsed_svc_hash, source)
      @service = normalize_svc_hash(parsed_svc_hash)
      @source = source
    end

    def normalize_svc_hash(svc_hash)
      normal_svc_hash = {}
      attrs = []
      svc_hash[:configs].each do |c|
        attrs.push("#{c[:name]} #{c[:operator]} #{c[:value]}")
      end
      normal_svc_hash[:attributes] = attrs
      normal_svc_hash[:name] = svc_hash[:name]
      normal_svc_hash[:disable] = svc_hash[:disabled]
      normal_svc_hash
    end

    def to_h
      out_hash = @service
      out_hash[:source] = @source
      out_hash
    end
  end
end
