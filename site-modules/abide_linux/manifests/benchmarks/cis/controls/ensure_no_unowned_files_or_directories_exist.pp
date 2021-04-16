# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
#
# @see tasks/audit_unowned_files_and_directories
class abide_linux::benchmarks::cis::controls::ensure_no_unowned_files_or_directories_exist (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    notice('Please run the included task audit_unowned_files_and_directories and confirm results.')
  }
}
