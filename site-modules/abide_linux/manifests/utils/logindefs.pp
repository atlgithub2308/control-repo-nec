# @summary Manages password max age, min age, and warn age
#
# This class is responsible for setting / managing password
# maximum, minimum, and warning ages. All ages are specified
# in days. This class can also enforce these rules on current
# user accounts with passwords using the `chage` command. Only
# user accounts with valid, encrypted passwords in /etc/shadow
# will be subject to enforcement via `chage`.
#
# @param [Optional[Integer]] pass_max_days
#   The maximum time in days that a password is valid.
#   Default: 365
# @param [Optional[Integer]] pass_min_days
#   The minimum time in days that a password in valid.
#   Configuring this will disable password changes on
#   passwords younger in days than this setting.
#   Default: 1
# @param [Optional[Integer]] pass_warn_age
#   Issues warnings to change password when the password
#   has this many days left before reaching maximum age.
#   Default: 7
# @param [Optional[Boolean]] enforce_on_current
#   Whether to enforce these password rules on accounts
#   with encrypted passwords in /etc/shadow.
#   Default: true
#
# @example
#   include abide_linux::utils::logindefs
class abide_linux::utils::logindefs (
  Optional[Integer] $pass_max_days = undef,
  Optional[Integer] $pass_min_days = undef,
  Optional[Integer] $pass_warn_age = undef,
  Optional[Integer] $pass_inactive = undef,
  Optional[Boolean] $enforce_on_current = undef,
) {
  $_pass_max_days = undef_default($pass_max_days, 365)
  $_pass_min_days = undef_default($pass_min_days, 1)
  $_pass_warn_age = undef_default($pass_warn_age, 7)
  $_pass_inactive = undef_default($pass_inactive, 30)
  $_enforce_on_current = undef_default($enforce_on_current, true)

  $_shadow_hash_prefixes = '\\$1\\$|\\$2a\\$|\\$2y\\$|\\$5\\$|\\$6\\$'
  $_shadow_grep_pattern = "^\\w+:(${_shadow_hash_prefixes}).*"
  $_linux_username_pattern = '[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30})'
  $_ufs_cmd = "grep -E '${_shadow_grep_pattern}' /etc/shadow | cut -d: -f1"
  $_max_chk = "for i in \$(${_ufs_cmd},5); do [[ \$i =~ ^${_linux_username_pattern}:${_pass_max_days}\$ ]] || exit 1; done"
  $_min_chk = "for i in \$(${_ufs_cmd},4); do [[ \$i =~ ^${_linux_username_pattern}:${_pass_min_days}\$ ]] || exit 1; done"
  $_wrn_chk = "for i in \$(${_ufs_cmd},6); do [[ \$i =~ ^${_linux_username_pattern}:${_pass_warn_age}\$ ]] || exit 1; done"
  $_ina_chk = "for i in \$(${_ufs_cmd},7); do [[ \$i =~ ^${_linux_username_pattern}:${_pass_inactive}\$ ]] || exit 1; done"
  $_max_cmd = "for i in \$(${_ufs_cmd}); do chage --maxdays ${_pass_max_days} \$i; done"
  $_min_cmd = "for i in \$(${_ufs_cmd}); do chage --mindays ${_pass_min_days} \$i; done"
  $_wrn_cmd = "for i in \$(${_ufs_cmd}); do chage --warndays ${_pass_warn_age} \$i; done"
  $_ina_cmd = "for i in \$(${_ufs_cmd}); do chage --inactive ${_pass_inactive} \$i; done"

  Augeas {
    context => '/files/etc/login.defs',
  }
  Exec {
    path     => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    provider => 'shell',
  }
  augeas { 'abide_logindefs_pass_max_age':
    changes => "set PASS_MAX_DAYS ${_pass_max_days}",
    onlyif  => "get PASS_MAX_DAYS != ${_pass_max_days}",
  }
  augeas { 'abide_logindefs_pass_min_age':
    changes => "set PASS_MIN_DAYS ${_pass_min_days}",
    onlyif  => "get PASS_MIN_DAYS != ${_pass_min_days}",
  }
  augeas { 'abide_logindefs_pass_warn_age':
    changes => "set PASS_WARN_AGE ${_pass_warn_age}",
    onlyif  => "get PASS_WARN_AGE != ${_pass_warn_age}",
  }
  exec { 'abide_default_inactive_time':
    command => "useradd -D -f ${_pass_inactive}",
    unless  => "[[ \$(useradd -D | grep INACTIVE) =~ ${_pass_inactive} ]]",
  }
  if $_enforce_on_current {
    exec { 'abide_chage_maxdays':
      command => $_max_cmd,
      unless  => $_max_chk,
    }
    exec { 'abide_chage_mindays':
      command => $_min_cmd,
      unless  => $_min_chk,
    }
    exec { 'abide_chage_warndays':
      command => $_wrn_cmd,
      unless  => $_wrn_chk,
    }
    exec { 'abide_chage_inactive':
      command => $_ina_cmd,
      unless  => $_ina_chk,
    }
  }
}
