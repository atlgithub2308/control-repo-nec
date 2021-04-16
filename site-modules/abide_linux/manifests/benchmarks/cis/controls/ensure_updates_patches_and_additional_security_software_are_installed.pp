# @api Private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see https://puppet.com/docs/pe/2019.8/patch_management_setup.html
class abide_linux::benchmarks::cis::controls::ensure_updates_patches_and_additional_security_software_are_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('Please use Puppet Enterprise\'s built-in patching solution.')
  }
}
