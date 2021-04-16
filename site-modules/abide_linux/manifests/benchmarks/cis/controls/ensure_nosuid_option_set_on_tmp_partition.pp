# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see abide::benchmarks::cis::controls::ensure_tmp_is_configured
class abide_linux::benchmarks::cis::controls::ensure_nosuid_option_set_on_tmp_partition (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    debug('This control is covered by ensure_tmp_is_configured.')
  }
}
