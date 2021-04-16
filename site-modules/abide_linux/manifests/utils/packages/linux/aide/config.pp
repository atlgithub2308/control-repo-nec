# @api private
# @summary Controls the AIDE config file
#
# This class creates the aide config file at /etc/aide.conf.
#
# @example
#   include abide_linux::utils::packages::linux::aide::config
class abide_linux::utils::packages::linux::aide::config (
  Optional[String] $source = undef,
  Optional[Hash] $options = undef,
) {

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  if $source !~ Undef {
    file { '/etc/aide.conf':
      source => $source,
    }
  } elsif $options !~ Undef {
    file { '/etc/aide.conf':
      content => epp("${module_name}/config/aide.conf.epp", { 'options' => $options }),
    }
  } else {
    warning('Must specify either source or options. Not enforcing.')
  }
}
