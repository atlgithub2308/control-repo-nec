# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/audit_world_writable_files
class abide_linux::benchmarks::cis::controls::ensure_no_world_writable_files_exist (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included Bolt task "audit_world_writable_files" and confirm results.')
  }
}
