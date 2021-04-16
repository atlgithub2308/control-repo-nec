# @api private
# @summary Controls the AIDE systemd timer service
#
# Controls the AIDE systemd timer service
#
# @param [String] systemd_timer_schedule
#      Used as the systemd timer unit file's OnSchedule directive.
#
# @example
#   include abide_linux::utils::packages::linux::aide::service
class abide_linux::utils::packages::linux::aide::service (
  String $timer_schedule,
  String $systemd_service_content,
) {
  include systemd

  systemd::timer { 'aidecheck.timer':
    timer_content   => epp("${module_name}/systemd/aidecheck.timer.epp", {'timer_schedule' => $timer_schedule}),
    service_content => $systemd_service_content,
    enable          => true,
    active          => true,
  }
}
