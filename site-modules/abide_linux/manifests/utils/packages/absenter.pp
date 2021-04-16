# @summary Removes system packages
#
# Absenter removes system packages.
#
# @example
#   abide_linux::utils::packages::absenter { 'namevar': }
define abide_linux::utils::packages::absenter (
  String[1] $pkg_name = $title,
  Boolean $purge = false,
  Optional[String[1]] $uninstall_options = undef,
) {
  $_ensure = $purge ? {
    true => 'purge',
    default => 'absent',
  }
  package { "abide_absenter_${pkg_name}":
    ensure            => $_ensure,
    name              => $pkg_name,
    uninstall_options => $uninstall_options,
  }
}
