# @summary Manages rsyslog for basic compliance needs
#
# Installs, configures, and manages rsyslog in an opinionated
# manner specific to compliance. If you need more robust rsyslog
# management, you should annotate this class as ignored and
# implement your own rsyslog solution. Vox Pupuli maintains
# an excellent rsyslog module: https://forge.puppet.com/modules/puppet/rsyslog.
#
# @param [Optional[Integer]] tcp_port
#   The port to use for the $InputTCPServerRun option. Default: 514
# @param [Optional[Hash]] logging_conf
#   Key-value pairs of rsyslog logging options.
#   Default: { '*.emerg' => ':omusrmsg:*',
#              'auth,authpriv.*' => '/var/log/secure',
#              'mail.*' => '-/var/log/mail',
#              'mail.info' => '-/var/log/mail.info',
#              'mail.warning' => '-/var/log/mail.warn',
#              'mail.err' => '-/var/log/mail.err',
#              'news.crit' => '-/var/log/news/news.crit',
#              'news.err' => '-/var/log/news/news.err',
#              'news.notice' => '/-var/log/news/news.notice',
#              '*.=warning;*.=err' => '-/var/log/warn',
#              '*.crit' => '/var/log/warn',
#              '*.*;mail.none;news.none' => '-/var/log/messages',
#              'local0,local1.*' => '-/var/log/localmessages',
#              'local2,local3.*' => '-/var/log/localmessages',
#              'local4,local5.*' => '-/var/log/localmessages',
#              'local6,local7.*' => '-/var/log/localmessages' }
# @param [Optional[Variant[Stdlib::IP::Address, String[1]]]] remote_log_host
#   A remote host for rsyslog to send logs to.
#
# @example
#   include abide_linux::utils::packages::linux::rsyslog
class abide_linux::utils::packages::linux::rsyslog (
  Optional[Hash] $logging_conf = undef,
  Optional[Variant[Stdlib::IP::Address, String[1]]] $remote_log_host = undef,
  Optional[Boolean] $tcp_log_receiver = undef,
  Optional[Integer] $tcp_port = undef,
) {
  $_d_logging_conf = {
    '*.emerg' => ':omusrmsg:*',
    'auth,authpriv.*' => '/var/log/secure',
    'mail.*' => '-/var/log/mail',
    'mail.info' => '-/var/log/mail.info',
    'mail.warning' => '-/var/log/mail.warn',
    'mail.err' => '-/var/log/mail.err',
    'news.crit' => '-/var/log/news/news.crit',
    'news.err' => '-/var/log/news/news.err',
    'news.notice' => '/-var/log/news/news.notice',
    '*.=warning;*.=err' => '-/var/log/warn',
    '*.crit' => '/var/log/warn',
    '*.*;mail.none;news.none' => '-/var/log/messages',
    'local0,local1.*' => '-/var/log/localmessages',
    'local2,local3.*' => '-/var/log/localmessages',
    'local4,local5.*' => '-/var/log/localmessages',
    'local6,local7.*' => '-/var/log/localmessages',
  }
  include stdlib

  $_logging_conf = undef_default($logging_conf, $_d_logging_conf)
  $_tcp_log_receiver = undef_default($tcp_log_receiver, false)
  $_tcp_port = undef_default($tcp_port, 514)

  package { 'abide_rsyslog':
    ensure => present,
    name   => 'rsyslog',
  }
  file { 'abide_rsyslog_conf':
    ensure  => file,
    path    => '/etc/rsyslog.conf',
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => epp('abide_linux/config/rsyslog.conf.epp', {
      'logging_conf' => $_logging_conf,
      'receiver'     => $_tcp_log_receiver,
      'tcp_port'     => $_tcp_port,
      'remote_host'  => $remote_log_host,
    } ),
    require => Package['abide_rsyslog'],
  }
  service { 'abide_rsyslog_service':
    ensure  => running,
    name    => 'rsyslog',
    enable  => true,
    require => File['abide_rsyslog_conf'],
  }
}
