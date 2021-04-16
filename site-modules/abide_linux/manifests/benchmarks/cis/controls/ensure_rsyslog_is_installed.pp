# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Integer] :tcp_port
# @option config [Hash] :logging_conf
# @option config [Variant[Stdlib::IP::Address, String[1]]] :remote_log_host
#
# @see abide_linux::utils::packages::linux::rsyslog
class abide_linux::benchmarks::cis::controls::ensure_rsyslog_is_installed (
  Boolean $enforced = true,
  Hash $config = {},
) {
  class { 'abide_linux::utils::packages::linux::rsyslog':
    tcp_port        => dig($config, 'tcp_port'),
    logging_conf    => dig($config, 'logging_conf'),
    remote_log_host => dig($config, 'remote_log_host'),
  }
}
