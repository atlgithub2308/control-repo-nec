# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'
require_relative '../../../puppet_x/puppetlabs/abide/inetd_provider_helper'

# Implementation for the inetd_service type using the Resource API.
class Puppet::Provider::InetdService::InetdService < Puppet::ResourceApi::SimpleProvider
  attr_accessor :default_conf_paths
  @default_conf_paths = ['/etc/inetd.conf', '/etc/xinetd.conf']

  def get(context)
    helper = PuppetX::Abide::InetdProviderHelper.new(context)
    ary = helper.get(@default_conf_paths)
    ary
  end

  def create(context, name, should)
    if should[:disable] && should[:absent_satisfies_disable]
      return if PuppetX::Abide::InetdConfParser.new(should[:source]).get(name, :services).nil?
    end
    if should[:disable] && !should[:attributes].include?('disable = yes')
      should[:attributes] << 'disable = yes'
    end
    helper = PuppetX::Abide::InetdProviderHelper.new(context)
    helper.create(name, should)
  end

  def update(context, name, should)
    if should[:disable] && should[:absent_satisfies_disable]
      return if InetdConfParser.new(should[:source]).get(name, :services).nil?
    end
    if should[:disable] && !should[:attributes].include?('disable = yes')
      should[:attributes] << 'disable = yes'
    end
    helper = PuppetX::Abide::InetdProviderHelper.new(context)
    helper.update(name, should)
  end

  def delete(context, name)
    helper = PuppetX::Abide::InetdProviderHelper.new(context)
    helper.delete(name, @default_conf_paths)
  end
end
