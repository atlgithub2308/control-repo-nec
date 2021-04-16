# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_noexec_option_set_on_vartmp_partition
class abide_linux::benchmarks::cis::controls::ensure_nosuid_option_set_on_vartmp_partition (
  Boolean $enforced = true,
  Hash $config = {}
) {
  if $enforced {
    debug('This control is covered by ensure_noexec_option_set_on_vartmp_partition.')
  }
}
