# @summary Installs and configures logrotate
#
# This class is essentially a wrapper around puppet/logrotate
#
# @param [Optional[Boolean]] manage_etc_logrotate
#   Whether or not you want to manage /etc/logrotate.conf.
#   If you would like this class to also install logrotate,
#   this must be set to `true`. Default: true
# @param [Optional[Boolean]] merge_defaults
#   This class provides a basic config for /etc/logrotate.conf.
#   If you provide your own configuration and would like to
#   merge those settings with the default settings, set this
#   to true. If you choose to merge settings, settings you
#   define will replace the default setting, if it exists.
# @param [Optional[Hash]] etc_logrotate_settings
#   A hash of settings to configure in /etc/logrotate.conf.
#   This hash is passed directly to the logrotate::conf
#   defined type.
# @param [Optional[Hash[String, Hash]]] rules
#   Key-value pairs used to create extra logrotate rules.
#   The keys must be file paths, and the values are hashes
#   that get passed directly into the logrotate::rule
#   defined type.
#
# @see https://forge.puppet.com/modules/puppet/logrotate
#
# @example
#   include abide_linux::utils::packages::linux::logrotate
class abide_linux::utils::packages::linux::logrotate (
  Optional[Boolean] $manage_etc_logrotate = undef,
  Optional[Boolean] $merge_defaults = undef,
  Optional[Hash] $etc_logrotate_settings = undef,
  Optional[Hash[String, Hash]] $rules = undef,
) {
  $_manage_etc_logrotate = undef_default($manage_etc_logrotate, true)
  $_merge_defaults = undef_default($merge_defaults, true)
  $_u_etc_logrotate_settings = undef_default($etc_logrotate_settings, {})
  $_d_etc_logrotate_settings = {
    'compress'     => true,
    'create'       => true,
    'create_mode'  => '0640',
    'create_owner' => 'root',
    'create_group' => 'root',
    'dateext'      => true,
    'dateformat'   => '%Y%m%d',
    'ifempty'      => false,
    'maxage'       => 365,
    'maxsize'      => '15M',
    'missingok'    => true,
    'rotate'       => 26,
    'rotate_every' => 'week',
    'size'         => '10M',
  }
  if $_merge_defaults {
    $_etc_logrotate_settings = merge($_u_etc_logrotate_settings, $_d_etc_logrotate_settings)
  } else {
    $_etc_logrotate_settings = $_u_etc_logrotate_settings
  }
  if $_manage_etc_logrotate {
    logrotate::conf { '/etc/logrotate.conf':
      ensure => 'present',
      *      => $_etc_logrotate_settings,
    }
  }
  if $rules !~ Undef {
    $rules.each | String $key, Hash $val| {
      logrotate::rule { $key:
        * => $val,
      }
    }
  }
}
