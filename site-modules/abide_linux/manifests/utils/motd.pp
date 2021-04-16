# @summary
#   This class configures a system message of the day on a wide variety of systems.
#   This class is a pretty direct clone of puppetlabs/puppetlabs-motd. It was
#   vendored to save from having to add another dependency to the Puppetfile.
#   The only updates to this class are surrounding parameter handling.
#
# @example Basic usage
#   include motd
#
# @param dynamic_motd
#   Enables or disables dynamic motd on Debian systems.
#
# @param template
#   Specifies a custom template. A template takes precedence over `content`. Valid options:  '/mymodule/mytemplate.erb'.
#
# @param content
#   Specifies a static string as the motd content.
#
# @param issue_template
#   Specifies a custom template to process and save to `/etc/issue`. A template takes precedence over `issue_content`.
#
# @param issue_content
#   Specifies a static string as the `/etc/issue` content.
#
# @param issue_net_template
#   Specifies a custom template to process and save to `/etc/issue.net`. A template takes precedence over `issue_net_content`.
#
# @param issue_net_content
#   Specifies a static string as the `/etc/issue.net` content.
#
# @param windows_motd_title
#   Specifies a static string to be used for:
#   'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext'
#   and 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption'
#   The 'legalnoticetext' registry key is shown before login on a Windows system.
#
class abide_linux::utils::motd (
  Optional[Boolean] $dynamic_motd       = undef,
  Optional[String] $template            = undef,
  Optional[String] $content             = undef,
  Optional[String] $issue_template      = undef,
  Optional[String] $issue_content       = undef,
  Optional[String] $issue_net_template  = undef,
  Optional[String] $issue_net_content   = undef,
  Optional[String] $windows_motd_title  = undef,
) {
  $defaults = lookup('abide_linux::utils::motd::defaults')
  $_d_dynamic_motd = $dynamic_motd ? {
    undef => dig($defaults, 'dynamic_motd'),
    default => $dynamic_motd,
  }
  $_d_template = $template ? {
    undef => dig($defaults, 'template'),
    default => $template,
  }
  $_d_content = $content ? {
    undef => dig($defaults, 'content'),
    default => $content,
  }
  $_d_issue_template = $issue_template ? {
    undef => dig($defaults, 'issue_template'),
    default => $issue_template,
  }
  $_d_issue_content = $issue_content ? {
    undef => dig($defaults, 'issue_content'),
    default => $issue_content,
  }
  $_d_issue_net_template = $issue_net_template ? {
    undef => dig($defaults, 'issue_net_template'),
    default => $issue_net_template,
  }
  $_d_issue_net_content = $issue_net_content ? {
    undef => dig($defaults, 'issue_net_template'),
    default => $issue_net_template,
  }
  $_d_windows_motd_title = $windows_motd_title ? {
    undef => dig($defaults, 'windows_motd_title'),
    default => $windows_motd_title,
  }

  if $_d_template {
    if $_d_content {
      warning(translate('Both $template and $content parameters passed to motd, ignoring content'))
    }
    $motd_content = epp($_d_template)
  } elsif $_d_content {
    $motd_content = $_d_content
  }

  if $_d_issue_template {
    if $_d_issue_content {
      warning(translate('Both $issue_template and $issue_content parameters passed to motd, ignoring issue_content'))
    }
    $_issue_content = epp($_d_issue_template)
  } elsif $_d_issue_content {
    $_issue_content = $_d_issue_content
  } else {
    $_issue_content = false
  }

  if $_d_issue_net_template {
    if $_d_issue_net_content {
      warning(translate('Both $issue_net_template and $issue_net_content parameters passed to motd, ignoring issue_net_content'))
    }
    $_issue_net_content = epp($_d_issue_net_template)
  } elsif $_d_issue_net_content {
    $_issue_net_content = $_d_issue_net_content
  } else {
    $_issue_net_content = false
  }

  $owner = $facts['kernel'] ? {
    'AIX'   => 'bin',
    default => 'root',
  }

  $group = $facts['kernel'] ? {
    'AIX'   => 'bin',
    'FreeBSD' => 'wheel',
    default => 'root',
  }

  $mode = $facts['kernel'] ? {
    default => '0644',
  }

  File {
    owner => $owner,
    group => $group,
    mode  => $mode,
  }

  if $facts['kernel'] in ['Linux', 'SunOS', 'FreeBSD', 'AIX'] {
    file { '/etc/motd':
      ensure  => file,
      backup  => false,
      content => $motd_content,
    }

    if $facts['kernel'] != 'FreeBSD' {
      if $_issue_content {
        file { '/etc/issue':
          ensure  => file,
          backup  => false,
          content => $_issue_content,
        }
      }

      if $_issue_net_content {
        file { '/etc/issue.net':
          ensure  => file,
          backup  => false,
          content => $_issue_net_content,
        }
      }
    }

    if ($facts['osfamily'] == 'Debian') and ($_d_dynamic_motd == false) {
      if $facts['operatingsystem'] == 'Debian' and versioncmp($facts['operatingsystemmajrelease'], '7') > 0 {
        $_line_to_remove = 'session    optional     pam_motd.so  motd=/run/motd.dynamic'
      } elsif $facts['operatingsystem'] == 'Ubuntu' and versioncmp($facts['operatingsystemmajrelease'], '16.00') > 0 {
        $_line_to_remove = 'session    optional     pam_motd.so  motd=/run/motd.dynamic'
      } else {
        $_line_to_remove = 'session    optional     pam_motd.so  motd=/run/motd.dynamic noupdate'
      }

      file_line { 'dynamic_motd':
        ensure => absent,
        path   => '/etc/pam.d/sshd',
        line   => $_line_to_remove,
      }
    }
  } elsif $facts['kernel'] == 'windows' {
    registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticecaption':
      ensure => present,
      type   => string,
      data   => $_d_windows_motd_title,
    }
    registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\policies\system\legalnoticetext':
      ensure => present,
      type   => string,
      data   => $motd_content,
    }
  }
}
