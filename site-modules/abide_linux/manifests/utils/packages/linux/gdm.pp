# @summary Manages the Gnome desktop environment
#
# Currently, this class only removes the gdm package
# if the required parameter is not set to true (defaults
# to false).
#
# @param [Optional[Boolean]] required
#   Marks gdm as required. If this is true, will not
#   remove gdm package. Defaults to false and removing
#   gdm package.
#
# @example Removing gdm package
#   include abide_linux::utils::packages::linux::gdm
class abide_linux::utils::packages::linux::gdm (
  Optional[Boolean] $required = undef,
) {
  $_required = $required ? {
    undef => false,
    default => $required,
  }
  unless $required {
    abide_linux::utils::packages::absenter{ 'gdm': }
  } else {
    err('Configuring GDM with Abide is not currently supported')
  }
}
