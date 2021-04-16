# @summary Secures ExecStart in rescue.service
#
# Ensures that authentication is required for single user mode
# by ensuring the correct ExecStart line exists in the
# rescue.service unit file.
#
# @example
#   include abide_linux::utils::services::systemd::rescue_service
class abide_linux::utils::services::systemd::secure_rescue_service {
  file_line { 'sulogin_rescue_service':
    ensure => present,
    path   => '/usr/lib/systemd/system/rescue.service',
    line   => 'ExecStart=-/bin/sh -c "/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"',
    match  => '^ExecStart=',
  }
}
