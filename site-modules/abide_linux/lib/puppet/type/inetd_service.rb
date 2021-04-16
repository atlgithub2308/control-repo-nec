# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'inetd_service',
  docs: <<-EOS,
@summary a inetd_service type
@example
inetd_service { 'foo':
  ensure => 'present',
}

This type provides Puppet with the capabilities to manage ...

If your type uses autorequires, please document as shown below, else delete
these lines.
**Autorequires**:
* `Package[foo]`
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Sets the state of the service. Setting this to disabled means that, if the service exists, it should be explicitly disabled.',
    },
    name: {
      type: 'String',
      desc: 'The name of the (x)inetd service you want to manage.',
      behaviour: :namevar,
    },
    source: {
      type: 'String[1]',
      desc: 'The file or files where the service definition should be created.',
      behaviour: :parameter,
      default: '/etc/xinetd.conf',
    },
    disable: {
      type: 'Boolean',
      desc: 'Marks a service as disabled by adding "disabled = yes" to the service configs',
      default: false,
    },
    attributes: {
      type: 'Array[String]',
      desc: 'The attributes of the service definition.',
      default: [],
    },
    absent_satisfies_disable: {
      type: 'Boolean',
      desc: 'If true, the resouce will report disabled even if it is actually absent.',
      behaviour: :parameter,
      default: false,
    },
  },
  autorequire: {
    file: '$source',
  },
)
