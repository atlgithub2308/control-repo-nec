# @api private
# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   abide_linux::utils::disable_service { 'namevar': }
define abide_linux::utils::disable_service (
  String[1] $service = $title,
  Boolean $mask = true,
) {
  $_enable = $mask ? {
    true => 'mask',
    default => 'disable',
  }
  exec { $service:
    path    => '/usr/bin:/usr/sbin:/bin',
    command => "systemctl stop ${service} && systemctl ${_enable} ${service}",
    onlyif  => "systemctl list-units --all | grep ${service}",
  }
}
