# @summary Secures ExecStart in emergency.service
#
# Ensures that authentication is required for single user mode
# by ensuring the correct ExecStart line exists in the
# emergency.service unit file.
#
# @example
#   include abide_linux::utils::services::systemd::emergency_service
class abide_linux::utils::services::systemd::secure_emergency_service {
  file_line { 'sulogin_emergency_service':
    ensure => present,
    path   => '/usr/lib/systemd/system/emergency.service',
    line   => 'ExecStart=-/bin/sh -c "/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"',
    match  => '^ExecStart=',
  }
}
