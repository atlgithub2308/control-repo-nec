# @summary Creates a Defaults entry in a given sudoers file
#
# Creates a new Defaults entry (or modifies and existing one) in
# a given sudoers file. Currently only capable of simple values
# i.e. a single key value pair or a single flag.
#
# @example
#   abide_linux::utils::packages::linux::sudo::sudoers_default { 'use_pty': }
#
# @example
#   abide_linux::utils::packages::linux::sudo::sudoers_default { 'logfile':
#     value => '/var/log/sudo.log',
#   }
define abide_linux::utils::packages::linux::sudo::sudoers_default (
  String[1] $key = $title,
  Optional[String[1]] $sudoers_path = undef,
  Optional[String] $value = undef,
) {
  $_sudoers_path = $sudoers_path ? {
    undef => '/etc/sudoers',
    default => $sudoers_path,
  }
  $_change = $value ? {
    undef => "touch Defaults[-1]/${key}",
    default => "set Defaults[child::${key}]/${key} ${value}",
  }
  augeas { "abide_sudoers_default_${key}":
    context => "/files${sudoers_path}",
    changes => $_change,
  }
}
