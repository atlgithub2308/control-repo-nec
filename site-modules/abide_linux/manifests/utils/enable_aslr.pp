# @summary Enable address space layout randomization (ASLR)
#
# This class enables ASLR via a sysctl conf file and command.
#
# @param [Optional[String]] sysctl_file
#   The filename of the file created at /etc/sysctl.d/.
#   Default:'10-enable_aslr.conf'
#
# @example
#   include abide_linux::utils::enable_aslr
class abide_linux::utils::enable_aslr (
  Optional[String] $sysctl_file = undef,
) {
#  include augeasproviders_sysctl

  $defaults = lookup('abide_linux::utils::enable_aslr::defaults')

  $_sysctl_file = $sysctl_file ? {
    undef => $defaults['sysctl_file'],
    default => $sysctl_file,
  }

  sysctl { 'kernel.randomize_va_space':
    ensure  => present,
    value   => '2',
    comment => 'MANAGED BY PUPPET',
    target  => "/etc/sysctl.d/${_sysctl_file}",
  }
}
