# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Boolean] dynamic_motd
# @option config [String] template
# @option config [String] content
# @option config [String] issue_template
# @option config [String] issue_content
# @option config [String] issue_net_template
# @option config [String] issue_net_content
# @option config [String] windows_motd_title
#
# @see abide_linux::utils::motd
class abide_linux::benchmarks::cis::controls::ensure_message_of_the_day_is_configured_properly (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::motd':
      dynamic_motd       => dig($config, 'dynamic_motd'),
      template           => dig($config, 'template'),
      content            => dig($config, 'content'),
      issue_template     => dig($config, 'issue_template'),
      issue_content      => dig($config, 'issue_content'),
      issue_net_template => dig($config, 'issue_net_template'),
      issue_net_content  => dig($config, 'issue_net_content'),
      windows_motd_title => dig($config, 'windows_motd_title'),
    }
  }
}
