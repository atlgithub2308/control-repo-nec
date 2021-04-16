# @summary Configures Journald with basic compliance settings
#
# Configures journald to forward logs to syslog, compress large
# log files, and use persistent (disk) storage. Each of these
# options is toggleable with parameters.
#
# @param [Optional[Stdlib::AbsolutePath]] journald_conf
#   Path to the journald config file. Default: /etc/systemd/journald.conf
# @param [Optional[Boolean]] forward_to_syslog
#   If true, configures option `ForwardToSyslog=yes` in the journald config.
#   Default: true
# @param [Optional[Boolean]] compress_large_files
#   If true, configures option `Compress=yes` in the journald config.
#   Default: true
# @param [Optional[Boolean]] persistent_storage
#   If true, configures option `Storage=persistent` in the journald config.
#   Default: true
#
# @example
#   include abide_linux::utils::services::systemd::journald
class abide_linux::utils::services::systemd::journald (
  Optional[Stdlib::AbsolutePath] $journald_conf = undef,
  Optional[Boolean] $forward_to_syslog = undef,
  Optional[Boolean] $compress_large_files = undef,
  Optional[Boolean] $persistent_storage = undef,
) {
  include stdlib
  $_journald_conf = undef_default($journald_conf, '/etc/systemd/journald.conf')
  $_forward_to_syslog = undef_default($forward_to_syslog, true)
  $_compress_large_files = undef_default($compress_large_files, true)
  $_persistent_storage = undef_default($persistent_storage, true)

  File_line {
    ensure  => present,
    path    => $_journald_conf,
    replace => true,
  }
  if $_forward_to_syslog {
    file_line { 'abide_journald_forward_to_syslog':
      line  => 'ForwardToSyslog=yes',
      match => '^ForwardToSyslog=',
    }
  }
  if $_compress_large_files {
    file_line { 'abide_journald_compress_large_files':
      line  => 'Compress=yes',
      match => '^Compress=',
    }
  }
  if $_persistent_storage {
    file_line { 'abide_journald_persistent_storage':
      line  => 'Storage=persistent',
      match => '^Storage=',
    }
  }
}
