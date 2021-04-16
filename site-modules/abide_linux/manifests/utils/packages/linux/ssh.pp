# @summary Configures SSH in a secure manner
#
# Ensures that the sshd config file and all host keys have
# proper ownership and permissions. Also exposes a number of
# sshd configuration options aimed at hardening SSH. THIS
# CLASS DISABLES ROOT SSH LOGIN. Please ensure you have
# another account that can log in to the node besides root
# before applying this class.
#
# TODO: param docs
#
# @example
#   include abide_linux::utils::packages::linux::ssh
class abide_linux::utils::packages::linux::ssh (
  Optional[Boolean] $enforce_sshd_config_perms = undef,
  Optional[Boolean] $enforce_host_key_perms = undef,
  Optional[Enum['INFO', 'VERBOSE']] $log_level = undef,
  Optional[Enum['yes', 'no']] $x11_forwarding = undef,
  Optional[Integer] $max_auth_tries = undef,
  Optional[Enum['yes', 'no']] $ignore_rhosts = undef,
  Optional[Enum['yes', 'no']] $host_based_authentication = undef,
  Optional[Enum['yes', 'no']] $permit_root_login = undef,
  Optional[Enum['yes', 'no']] $permit_empty_passwords = undef,
  Optional[Enum['yes', 'no']] $permit_user_environment = undef,
  Optional[Array[String[1]]] $ciphers = undef,
  Optional[String[1]] $macs = undef,
  Optional[String[1]] $kex_algorithms = undef,
  Optional[Integer] $client_alive_interval = undef,
  Optional[Integer] $client_alive_count_max = undef,
  Optional[Integer] $login_grace_time = undef,
  Optional[Stdlib::AbsolutePath] $banner = undef,
  Optional[Enum['yes', 'no']] $use_pam = undef,
  Optional[Enum['yes', 'no']] $allow_tcp_forwarding = undef,
  Optional[String[1]] $max_startups = undef,
  Optional[Integer] $max_sessions = undef,
  Optional[Stdlib::AbsolutePath] $config_path = undef,
  Optional[String] $config_comment = undef,
  Optional[Array[String[1]]] $allow_users = undef,
  Optional[Array[String[1]]] $allow_groups = undef,
  Optional[Array[String[1]]] $deny_users = undef,
  Optional[Array[String[1]]] $deny_groups = undef,
) {
  $_d_ciphers = [
    'aes128-ctr',
    'aes192-ctr',
    'aes256-ctr',
    'aes128-gcm@openssh.com',
    'aes256-gcm@openssh.com',
    'chacha20-poly1305@openssh.com',
  ]
  $_d_mac_algos = [
    'hmac-sha2-512-etm@openssh.com',
    'hmac-sha2-256-etm@openssh.com',
    'hmac-sha2-512',
    'hmac-sha2-256',
  ]
  $_d_keyex_algos = [
    'curve25519-sha256',
    'curve25519-sha256@libssh.org',
    'diffie-hellman-group14-sha256',
    'diffie-hellman-group16-sha512',
    'diffie-hellman-group18-sha512',
    'ecdh-sha2-nistp521',
    'ecdh-sha2-nistp384',
    'ecdh-sha2-nistp256',
    'diffie-hellman-group-exchange-sha256',
  ]
  $_enforce_sshd_config_perms = undef_default($enforce_sshd_config_perms, true)
  $_enforce_host_key_perms = undef_default($enforce_host_key_perms, true)
  $_log_level = undef_default($log_level, 'INFO')
  $_x11_forwarding = undef_default($x11_forwarding, 'no')
  $_max_auth_tries = undef_default($max_auth_tries, 4)
  $_ignore_rhosts = undef_default($ignore_rhosts, 'yes')
  $_host_based_authentication = undef_default($host_based_authentication, 'no')
  $_permit_root_login = undef_default($permit_root_login, 'no')
  $_permit_empty_passwords = undef_default($permit_empty_passwords, 'no')
  $_permit_user_environment = undef_default($permit_user_environment, 'no')
  $_ciphers = undef_default($ciphers, $_d_ciphers)
  $_macs = undef_default($macs, $_d_mac_algos)
  $_kex_algorithms = undef_default($kex_algorithms, $_d_keyex_algos)
  $_client_alive_interval = undef_default($client_alive_interval, 300)
  $_client_alive_count_max = undef_default($client_alive_count_max, 3)
  $_login_grace_time = undef_default($login_grace_time, 60)
  $_banner = undef_default($banner, '/etc/issue.net')
  $_use_pam = undef_default($use_pam, 'yes')
  $_allow_tcp_forwarding = undef_default($allow_tcp_forwarding, 'no')
  $_max_startups = undef_default($max_startups, '10:30:60')
  $_max_sessions = undef_default($max_sessions, 10)
  $_config_path = undef_default($config_path, '/etc/ssh/sshd_config')
  $_config_comment = undef_default($config_comment, 'MANAGED BY PUPPET')

  Exec {
    path     => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    provider => 'shell',
  }

  if $_enforce_sshd_config_perms {
    file { 'abide_sshd_config_permissions':
      ensure => file,
      path   => $_config_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
  }
  if $_enforce_host_key_perms {
    # lint:ignore:140chars
    $_prisetcmd = 'find /etc/ssh -xdev -type f -name "ssh_host_*_key" -exec chmod u-x,g-wx,o- rwx {} \;'
    $_prichkcmd = 'for i in $(find /etc/ssh -xdev -type f -name "ssh_host_*_key" -exec stat -c %a {} \;); do echo "$i" | grep -q "^6[0-4][0-4]"; done'
    $_priowncmd = 'find /etc/ssh -xdev -type f -name "ssh_host_*_key" -exec chown root:ssh_keys {} \;'
    $_prichkown = 'for i in $(find /etc/ssh -xdev -type f -name "ssh_host_*_key" -exec stat -c %U:%G {} \;); do echo "$i" | grep -q "^root:ssh_keys$"; done'
    $_pubsetcmd = 'find /etc/ssh -xdev -type f -name "ssh_host_*_key.pub" -exec chmod u-x,go- wx {} \;'
    $_pubchkcmd = 'for i in $(find /etc/ssh -xdev -type f -name "ssh_host_*_key.pub" -exec stat -c %a {} \;); do echo "$i" | grep -q "^6[0-4][0-4]"; done'
    $_pubowncmd = 'find /etc/ssh -xdev -type f -name "ssh_host_*_key.pub" -exec chown root:ssh_keys {} \;'
    $_pubchkown = 'for i in $(find /etc/ssh -xdev -type f -name "ssh_host_*_key.pub" -exec stat -c %U:%G {} \;); do echo "$i" | grep -q "^root:ssh_keys$"; done'
    # lint:endignore

    exec { 'abide_enforce_private_key_perms':
      command => $_prisetcmd,
      unless  => $_prichkcmd,
    }
    -> exec { 'abide_enforce_private_key_ownership':
      command => $_priowncmd,
      unless  => $_prichkown,
    }
    exec { 'abide_enforce_public_key_perms':
      command => $_pubsetcmd,
      unless  => $_pubchkcmd,
    }
    -> exec { 'abide_enforce_public_key_ownership':
      command => $_pubowncmd,
      unless  => $_pubchkown,
    }
  }

  Sshd_config {
    ensure  => present,
    target  => $_config_path,
    #comment => $_config_comment, temp removed due to bug where it adds comment repeatedly
  }
  sshd_config { 'LogLevel':
    value => $_log_level,
  }
  sshd_config { 'X11Forwarding':
    value => $_x11_forwarding,
  }
  sshd_config { 'MaxAuthTries':
    value => String($_max_auth_tries),
  }
  sshd_config { 'IgnoreRhosts':
    value => $_ignore_rhosts,
  }
  sshd_config { 'HostBasedAuthentication':
    value => $_host_based_authentication,
  }
  sshd_config { 'PermitRootLogin':
    value => $_permit_root_login,
  }
  sshd_config { 'PermitEmptyPasswords':
    value => $_permit_empty_passwords,
  }
  sshd_config { 'PermitUserEnvironment':
    value => $_permit_user_environment,
  }
  sshd_config { 'Ciphers':
    value => $_ciphers,
  }
  sshd_config { 'MACs':
    value => $_macs,
  }
  sshd_config { 'KexAlgorithms':
    value => $_kex_algorithms,
  }
  sshd_config { 'ClientAliveInterval':
    value => String($_client_alive_interval),
  }
  sshd_config { 'ClientAliveCountMax':
    value => String($_client_alive_count_max),
  }
  sshd_config { 'LoginGraceTime':
    value => String($_login_grace_time),
  }
  sshd_config { 'Banner':
    value => $_banner,
  }
  sshd_config { 'UsePAM':
    value => $_use_pam,
  }
  sshd_config { 'AllowTcpForwarding':
    value => $_allow_tcp_forwarding,
  }
  sshd_config { 'MaxStartups':
    value => String($_max_startups),
  }
  sshd_config { 'MaxSessions':
    value => String($_max_sessions),
  }
  if $allow_users !~ Undef {
    sshd_config { 'AllowUsers':
      value  => $allow_users,
      notify => Exec['abide_reload_sshd'],
    }
  }
  if $allow_groups !~ Undef {
    sshd_config { 'AllowGroups':
      value  => $allow_groups,
      notify => Exec['abide_reload_sshd'],
    }
  }
  if $deny_users !~ Undef {
    sshd_config { 'DenyUsers':
      value  => $deny_users,
      notify => Exec['abide_reload_sshd'],
    }
  }
  if $deny_groups !~ Undef {
    sshd_config { 'DenyGroups':
      value  => $deny_groups,
      notify => Exec['abide_reload_sshd'],
    }
  }
  exec { 'abide_reload_sshd':
    command     => 'systemctl reload sshd',
    refreshonly => true,
    subscribe   => Sshd_config[
      'LogLevel',
      'X11Forwarding',
      'MaxAuthTries',
      'IgnoreRhosts',
      'HostBasedAuthentication',
      'PermitRootLogin',
      'PermitEmptyPasswords',
      'PermitUserEnvironment',
      'Ciphers',
      'MACs',
      'KexAlgorithms',
      'ClientAliveInterval',
      'ClientAliveCountMax',
      'LoginGraceTime',
      'Banner',
      'UsePAM',
      'AllowTcpForwarding',
      'MaxStartups',
      'MaxSessions',
    ],
  }
}
