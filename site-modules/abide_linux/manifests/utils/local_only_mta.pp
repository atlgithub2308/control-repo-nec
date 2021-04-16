# @summary Configures MTAs to only process local mail
#
# Configure Mail Transfer Agents (MTAs) to only process
# local mail. Currently, postfix and sendmail are supported.
#
# @example
#   include abide_linux::utils::local_only_mta
class abide_linux::utils::local_only_mta {
  $_non_lo_listening = dig($facts, 'abide_mta', 'non_lo_listening')
  if $_non_lo_listening and !empty($_non_lo_listening) {
    $_postfix = dig($facts, 'abide_mta', 'postfix')
    $_sendmail = dig($facts, 'abide_mta', 'sendmail')
    if $_postfix {
      unless $_postfix['smtp_iface'] =~ /loopback-only/ {
        augeas { 'abide_postfix_iface_lo_only':
          context => '/files/etc/postfix/main.cf',
          changes => 'set inet_interfaces loopback-only'
        }
        ~> exec { 'abide_restart_postfix':
          command     => 'systemctl restart postfix',
          path        => '/bin:/sbin:/usr/bin:/usr/sbin',
          refreshonly => true,
        }
      }
    }
    if $_sendmail {
      unless $_sendmail['smtp_iface'] =~ /.*Addr=127.0.0.1.*/ {
        file_line { 'abide_sendmail_iface_lo_only':
          ensure  => present,
          path    => '/etc/mail/sendmail.mc',
          line    => 'DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA\')dnl',
          match   => '^DAEMON_OPTIONS(`Port=smtp',
          replace => true,
        }
        ~> exec { 'abide_restart_sendmail':
          command     => 'systemctl restart sendmail',
          path        => '/bin:/sbin:/usr/bin:/usr/sbin',
          refreshonly => true,
        }
      }
    }
  }
}
