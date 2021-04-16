# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::timesync
class abide_linux::utils::timesync (
  Optional[Enum['chrony', 'ntp']] $preferred_package = undef,
  Optional[Boolean] $manage_package = undef,
  Optional[Boolean] $force_exclusivity = undef,
  Optional[Boolean] $add_user_option = undef,
  Optional[String[1]] $ntp_user = undef,
  Optional[Array[String[1]]] $ntp_restricts = undef,
  Optional[Array[String[1]]] $timeservers = undef,
  Optional[String[1]] $sysconfig_options = undef,
  Optional[String[1]] $ntp_systemd_exec_start = undef,
) {
  $_def_ntp_restricts = [
    '-4 default kod nomodify notrap nopeer noquery',
    '-6 default kod nomodify notrap nopeer noquery',
  ]
  $_preferred_package = $preferred_package ? {
    undef => 'chrony',
    default => $preferred_package,
  }
  $_manage_package = $manage_package ? {
    undef => true,
    default => $manage_package,
  }
  $_force_exclusivity = $force_exclusivity ? {
    undef => true,
    default => $force_exclusivity,
  }
  $_ntp_restricts = $ntp_restricts ? {
    undef => $_def_ntp_restricts,
    default => $ntp_restricts,
  }
  $_has_chrony = dig($facts, 'abide_timesync', 'details', 'chrony')
  $_has_ntp = dig($facts, 'abide_timesync', 'details', 'ntp')
  if $_preferred_package == 'chrony' and $_has_chrony {
    $_selector = 'chrony'
    if $_force_exclusivity {
      $_remove = 'ntp'
    } else {
      $_remove = false
    }
  } elsif $_preferred_package == 'chrony' and $_manage_package {
    $_selector = 'chrony'
    if $_force_exclusivity {
      $_remove = 'ntp'
    } else {
      $_remove = false
    }
  } elsif $_preferred_package == 'ntp' and $_has_ntp {
    $_selector = 'ntp'
    if $_force_exclusivity {
      $_remove = 'chrony'
    } else {
      $_remove = false
    }
  } elsif $_preferred_package == 'ntp' and $_manage_package {
    $_selector = 'ntp'
    if $_force_exclusivity {
      $_remove = 'chrony'
    } else {
      $_remove = false
    }
  } elsif $_has_chrony {
    $_warn = @("ABIDE_WARNING")
      Your preferred timesync package ${_preferred_package} does not
      exist on this machine and the manage_package param is
      ${_manage_package}. We have found the 'chrony' package on this
      system and will ensure it's configs are compliant. To install
      your preferred package, please set manage_package to true. Due
      to this ambiguous configuration, exclusivity will not be forced.
      | ABIDE_WARNING
    warning($_warn)
    $_selector = 'chrony'
    $_remove = false
  } elsif $_has_ntp {
    $_warn = @("ABIDE_WARNING")
      Your preferred timesync package ${_preferred_package} does not
      exist on this machine and the manage_package param is
      ${_manage_package}. We have found the 'ntp' package on this
      system and will ensure it's configs are compliant. To install
      your preferred package, please set manage_package to true. Due
      to this ambiguous configuration, exclusivity will not be forced.
      | ABIDE_WARNING
    warning($_warn)
    $_selector = 'ntp'
    $_remove = false
  } else {
    # Getting here means that neither NTP nor
    $_selector = 'invalid'
    $_remove = false
  }
  case $_selector {
    'chrony': {
      class { 'abide_linux::utils::packages::linux::chrony':
        manage_package    => $_manage_package,
        timeservers       => $timeservers,
        sysconfig_options => $sysconfig_options,
      }
    }
    'ntp': {
      class { 'abide_linux::utils::package::linux::ntp':
        manage_package     => $_manage_package,
        restricts          => $ntp_restricts,
        timeservers        => $timeservers,
        sysconfig_options  => $sysconfig_options,
        systemd_exec_start => $ntp_systemd_exec_start,
      }
    }
    default: {
      $_warn = @("ABIDE_WARNING")
        The current class configuration is invalid. If you do not want
        to enforce this control, please add it to the ignore list. No
        configurations will be enforced.
        | ABIDE_WARNING
      warning($_warn)
    }
  }
  if $_remove {
    abide_linux::utils::packages::absenter { $_remove: }
  }
}
