# @summary Manages at.allow and at.deny files
#
# Ensures at.deny file is absent from node, and
# ensures at.allow is present and has correct permissions.
# If permissions for at.allow are managed, will also
# enforce a configurable allow list.
#
# @param [Optional[Boolean]] purge_at_deny
#   If true, removes /etc/at.deny.
#   Default: true
# @param [Optional[Boolean]] manage_at_allow
#   If true, creates the at.allow file at `/etc/at.allow`
#   and enforces `0600` permissions on the file.
#   Default: true
# @param [Optional[Array[String[1]]]] at_allowlist
#   An array of user names to add to the at.allow file.
#   Default: [root]
#
# @example
#   include abide_linux::utils::packages::linux::at
class abide_linux::utils::packages::linux::at (
  Optional[Boolean] $purge_at_deny = undef,
  Optional[Boolean] $manage_at_allow = undef,
  Optional[Array[String[1]]] $at_allowlist = undef,
) {
  include stdlib

  $_purge_at_deny = undef_default($purge_at_deny, true)
  $_manage_at_allow = undef_default($manage_at_allow, true)
  $_at_allowlist = undef_default($at_allowlist, ['root'])

  if $_purge_at_deny {
    file { 'abide_purge_etc_at_deny':
      ensure => absent,
      path   => '/etc/at.deny',
    }
  }
  if $_manage_at_allow {
    file { 'abide_at_allow_permissions':
      ensure  => file,
      path    => '/etc/at.allow',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => epp('abide_linux/config/cron_at.allow.epp', { users => $_at_allowlist })
    }
  }
}
