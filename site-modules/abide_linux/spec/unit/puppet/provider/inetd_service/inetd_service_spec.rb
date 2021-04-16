# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

ensure_module_defined('Puppet::Provider::InetdService')
require 'puppet/provider/inetd_service/inetd_service'

RSpec.describe Puppet::Provider::InetdService::InetdService do
  subject(:provider) { described_class.new }

  let(:old_pwd) { Dir.pwd }
  let(:old_default_conf_paths) { provider.default_conf_paths }
  let(:sandbox_dir) { "#{old_pwd}/spec/support/sandbox" }
  let(:sandbox_nested_dir) { "#{sandbox_dir}/inetd.d" }
  let(:sandbox_inetd_path) { "#{sandbox_dir}/inetd.conf" }
  let(:sandbox_xinetd_path) { "#{sandbox_dir}/xinetd.conf" }
  let(:sandbox_nested_path) { "#{sandbox_nested_dir}/nested.conf" }
  let(:sandbox_default_conf_paths) { [sandbox_inetd_path, sandbox_xinetd_path] }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:typedef) { instance_double('Puppet::ResourceApi::TypeDefinition', 'typedef') }
  let(:file_content_inetd) do
    [
      '# FLO',
      '',
      'defaults',
      '{',
      "\tlog_type = SYSLOG daemon info",
      '}',
      'service chargen',
      '{',
      "\tdisable = yes",
      "\tflags = IPV6",
      '}',
      '',
      'service telnet',
      '{',
      "\tflags = IPV6",
      '}',
      "includedir #{sandbox_nested_dir}",
    ].join("\n")
  end
  let(:file_content_xinetd) do
    [
      '# FLO',
      '',
      'defaults',
      '{',
      "\tlog_type = SYSLOG daemon info",
      '}',
      'service chargen',
      '{',
      "\tdisable = yes",
      "\tflags = IPV6",
      '}',
      '',
      'service telnet',
      '{',
      "\tflags = IPV6",
      '}',
    ].join("\n")
  end
  let(:file_content_inetd_nested) do
    [
      '# FLO',
      '',
      'service chargen',
      '{',
      "\tflags = IPV6",
      '}',
    ].join("\n")
  end

  let(:inetd_chargen) do
    {
      name: 'chargen',
      source: sandbox_inetd_path,
      attributes: ['disable = yes', 'flags = IPV6'],
      disable: true,
    }
  end
  let(:xinetd_chargen) do
    {
      name: 'chargen',
      source: sandbox_xinetd_path,
      attributes: ['disable = yes', 'flags = IPV6'],
      disable: true,
    }
  end
  let(:nested_chargen) do
    {
      name: 'chargen',
      source: sandbox_nested_path,
      attributes: ['flags = IPV6'],
      disable: false,
    }
  end
  let(:inetd_telnet) do
    {
      name: 'telnet',
      source: sandbox_inetd_path,
      attributes: ['flags = IPV6'],
      disable: false,
    }
  end
  let(:xinetd_telnet) do
    {
      name: 'telnet',
      source: sandbox_xinetd_path,
      attributes: ['flags = IPV6'],
      disable: false,
    }
  end
  let(:inetd_telnet_updated) do
    {
      name: 'telnet',
      source: sandbox_inetd_path,
      attributes: ['flags = IPV6', 'newkey += newval'],
      disable: true,
    }
  end
  let(:attrs) do
    {
      name: {
        type: 'String',
      },
      source: {
        type: 'Variant[String[1], Array[String[1]]]',
      },
      attributes: {
        type: 'Array[String]',
      },
      absent_satisfies_disabled: {
        type: 'Boolean',
      },
    }
  end
  let(:create_test_svc_should) do
    {
      ensure: 'present',
      attributes: ['flags = IPV6'],
      source: sandbox_inetd_path,
      disable: true,
    }
  end
  let(:absent_satisfies_disable_should) do
    {
      ensure: 'present',
      attributes: [],
      source: sandbox_inetd_path,
      disable: true,
      absent_satisfies_disable: true,
    }
  end

  before(:each) do
    FileUtils.mkdir_p(sandbox_nested_dir)
    File.open(sandbox_inetd_path, 'w') { |f| f.write file_content_inetd }
    File.open(sandbox_xinetd_path, 'w') { |f| f.write file_content_xinetd }
    File.open(sandbox_nested_path, 'w') { |f| f.write file_content_inetd_nested }
    Dir.chdir(sandbox_dir)
    provider.default_conf_paths = sandbox_default_conf_paths
    allow(context).to receive(:type).with(no_args).and_return(typedef)
    allow(context).to receive(:creating)
    allow(context).to receive(:updating)
    allow(context).to receive(:deleting)
    allow(context).to receive(:notice)
    allow(context).to receive(:warning)
    allow(context).to receive(:err)
  end

  after(:each) do
    provider.default_conf_paths = old_default_conf_paths
    Dir.chdir(old_pwd)
    FileUtils.rm_rf(sandbox_dir)
  end

  describe 'get' do
    it 'processes resources' do
      allow(typedef).to receive(:attributes).with(no_args).and_return(attrs)
      all_services = provider.get(context)

      expect(all_services).to include(inetd_chargen)
      expect(all_services).to include(xinetd_chargen)
      expect(all_services).to include(inetd_telnet)
      expect(all_services).to include(xinetd_telnet)
      expect(all_services).to include(nested_chargen)
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the test_svc service in inetd.conf file' do
      provider.create(context, 'test_svc', create_test_svc_should)
      test_svc = PuppetX::Abide::InetdConfParser.new(sandbox_inetd_path).get('test_svc', :services)
      expect(test_svc).not_to eq nil
      expect(test_svc.disabled?).to eq true
      expect(test_svc.has?('flags')).to eq true
    end

    it 'does not create test_svc_disable because absent_satisfies_disabled is true' do
      provider.create(context, 'test_svc_disable', absent_satisfies_disable_should)
      test_svc_disable = PuppetX::Abide::InetdConfParser.new(sandbox_inetd_path).get('test_svc_disable', :services)
      expect(test_svc_disable).to eq nil
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the inetd telnet resource' do
      provider.update(context, 'telnet', inetd_telnet_updated)
      telnet = PuppetX::Abide::InetdConfParser.new(sandbox_inetd_path).get('telnet', :services)
      expect(telnet.disabled?).to eq true
      newkey_conf = telnet.get('newkey')
      expect(newkey_conf).not_to eq nil
      expect(newkey_conf.op).to eq '+='
      expect(newkey_conf.value).to eq 'newval'
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      provider.delete(context, 'chargen')
      i_chargen = PuppetX::Abide::InetdConfParser.new(sandbox_inetd_path).get('chargen', :services)
      x_chargen = PuppetX::Abide::InetdConfParser.new(sandbox_xinetd_path).get('chargen', :services)
      n_chargen = PuppetX::Abide::InetdConfParser.new(sandbox_nested_path).get('chargen', :services)
      expect(i_chargen).to eq nil
      expect(x_chargen).to eq nil
      expect(n_chargen).to eq nil
    end
  end
end
