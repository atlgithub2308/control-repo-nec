# @api private
#
# @param [Boolean] enforced
#   If yes, the control will be enforced
# @param [Hash] config
#   Options for the control
# @option config [Integer] difok
# @option config [Integer] minlen
# @option config [Integer] dcredit
# @option config [Integer] ucredit
# @option config [Integer] lcredit
# @option config [Integer] ocredit
# @option config [Integer] minclass
# @option config [Integer] maxrepeat
# @option config [Integer] maxsequence
# @option config [Integer] maxclassrepeat
# @option config [Enum[0, 1]] gecoscheck
# @option config [Enum[0, 1]] dictcheck
# @option config [Enum[0, 1]] usercheck
# @option config [Enum[0, 1]] enforcing
# @option config [String] badwords
# @option config [Stdlib::AbsolutePath] dictpath
# @option config [Integer] retry
# @option config [Integer] pam_retry
# @option config [Enum[pam_pwhistory.so, pam_unix.so]] pw_history_module
# @option config [Enum[pam_faillock.so, pam_tally2.so]] lockout_module
# @option config [Array[String]] pwquality_args
# @option config [Array[String]] pam_unix_args
# @option config [Array[String]] pwhistory_args
# @option config [Array[String]] faillock_args
# @option config [Array[String]] faillock_die_args
# @option config [Array[String]] tally2_args
#
# @see abide_linux::utils::pwquality
# @see abide_linux::utils::pam_auth
class abide_linux::benchmarks::cis::controls::ensure_password_creation_requirements_are_configured (
  Boolean $enforced = true,
  Hash $config = {},
) {
  if $enforced {
    class { 'abide_linux::utils::pwquality':
      difok          => dig($config, 'difok'),
      minlen         => dig($config, 'minlen'),
      dcredit        => dig($config, 'dcredit'),
      ucredit        => dig($config, 'ucredit'),
      lcredit        => dig($config, 'lcredit'),
      ocredit        => dig($config, 'ocredit'),
      minclass       => dig($config, 'minclass'),
      maxrepeat      => dig($config, 'maxrepeat'),
      maxsequence    => dig($config, 'maxsequence'),
      maxclassrepeat => dig($config, 'maxclassrepeat'),
      gecoscheck     => dig($config, 'gecoscheck'),
      dictcheck      => dig($config, 'dictcheck'),
      usercheck      => dig($config, 'usercheck'),
      enforcing      => dig($config, 'enforcing'),
      badwords       => dig($config, 'badwords'),
      dictpath       => dig($config, 'dictpath'),
      retry          => dig($config, 'retry'),
      pam_retry      => dig($config, 'pam_retry'),
    }
    -> class { 'abide_linux::utils::pam_auth':
      pw_history_module => dig($config, 'pw_history_module'),
      lockout_module    => dig($config, 'lockout_module'),
      pwquality_args    => dig($config, 'pwquality_args'),
      pam_unix_args     => dig($config, 'pam_unix_args'),
      pwhistory_args    => dig($config, 'pwhistory_args'),
      faillock_args     => dig($config, 'faillock_args'),
      faillock_die_args => dig($config, 'faillock_die_args'),
      tally2_args       => dig($config, 'tally2_args'),
    }
  }
}
