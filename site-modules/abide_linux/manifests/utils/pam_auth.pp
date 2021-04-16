# @summary Configures PAM password-auth and system-auth
#
# Configures password history, password lockout, and password
# quality in PAM password-auth and system-auth.
# 
# @param [Optional[Enum[pam_pwhistory.so, pam_unix.so]]] pw_history_module
#   Which PAM module to use for password history configuration.
#   Default: pam_unix.so
# @param [Optional[Enum[pam_faillock.so, pam_tally2.so]]] lockout_module
#   Which PAM module to use for password lockout configuration.
#   Default: pam_faillock.so
# @param [Optional[Array[String[1]]]] pwquality_args
#   Arguments for pam_pwquality.so configuration.
#   Default: [try_first_pass, local_users_only, retry=3, authtok_type=]
# @param [Optional[Array[String[1]]]] pam_unix_args
#   Arguments for pam_unix.so configuration. If pam_unix.so is selected as
#   the password history module (the default) then the argument `remember=5`
#   is added to the default value.
#   Default: [sha512, shadow, nullok, try_first_pass, use_authtok]
# @param [Optional[Array[String[1]]]] pwhistory_args
#   Arguments for pam_pwhistory.so configuration. These arguments are
#   only relevant if you specify pam_pwhistory.so as the password history
#   PAM module.
#   Default: [use_authtok, remember=5, retry=3]
# @param [Optional[Array[String[1]]]] faillock_args
#   Arguments for pam_faillock.so configuration. These arguments are
#   only relevant if you specify pam_faillock.so as the password lockout
#   PAM module (the default).
#   Default: [preauth, silent, sudit, deny=5, unlock_time=900]
# @param [Optional[Array[String[1]]]] faillock_die_args
#   Arguments for secondary pam_faillock.so configuration where the control
#   is `default=die`. These arguments are only relevant if you specify
#   pam_faillock.so as the password lockout PAM module (the default).
#   Default: [authfail, audit, deny=5, unlock_time=900]
# @param [Optional[Array[String[1]]]] tally2_args
#   Arguments for pam_tally2.so configuration. These arguments are only
#   relevant if you specify pam_tally2.so as the password lockout PAM
#   module.
#   Default: [deny=5, onerr=fail, unlock_time=900]
#
# @example
#   include abide_linux::utils::pam_auth
class abide_linux::utils::pam_auth (
  Optional[Enum['pam_pwhistory.so', 'pam_unix.so']] $pw_history_module = undef,
  Optional[Enum['pam_faillock.so', 'pam_tally2.so']] $lockout_module = undef,
  Optional[Array[String[1]]] $pwquality_args = undef,
  Optional[Array[String[1]]] $pam_unix_args = undef,
  Optional[Array[String[1]]] $pwhistory_args = undef,
  Optional[Array[String[1]]] $faillock_args = undef,
  Optional[Array[String[1]]] $faillock_die_args = undef,
  Optional[Array[String[1]]] $tally2_args = undef,
) {
  $_pw_history_module = undef_default($pw_history_module, 'pam_unix.so')
  $_lockout_module = undef_default($lockout_module, 'pam_faillock.so')
  $_pwquality_args = undef_default($pwquality_args, ['try_first_pass', 'local_users_only', 'retry=3', 'authtok_type='])
  $_d_pam_unix = $_pw_history_module ? {
    'pam_unix.so' => ['sha512', 'shadow', 'nullok', 'try_first_pass', 'remember=5', 'use_authtok'],
    'pam_pwhistory.so' => ['sha512', 'shadow', 'nullok', 'try_first_pass', 'use_authtok'],
  }
  $_pam_unix_args = undef_default($pam_unix_args, $_d_pam_unix)
  $_pwhistory_args = undef_default($pwhistory_args, ['use_authtok', 'remember=5', 'retry=3'])
  $_faillock_args = undef_default($faillock_args, ['preauth', 'silent', 'audit', 'deny=5', 'unlock_time=900'])
  $_faillock_die_args = undef_default($faillock_die_args, ['authfail', 'audit', 'deny=5', 'unlock_time=900'])
  $_tally2_args = undef_default($tally2_args, ['deny=5', 'onerr=fail', 'unlock_time=900'])

  ['password-auth', 'system-auth'].each | String $svc | {
    pam { "Abide - set pwquality password requisite in ${svc}":
      ensure           => present,
      service          => $svc,
      type             => 'password',
      control          => 'requisite',
      control_is_param => true,
      module           => 'pam_pwquality.so',
      arguments        => $_pwquality_args,
      position         => 'before module pam_deny.so',
    }
    pam { "Abide - set pam_unix password sufficient in ${svc}":
      ensure           => present,
      service          => $svc,
      type             => 'password',
      control          => 'sufficient',
      control_is_param => true,
      module           => 'pam_unix.so',
      arguments        => $_pam_unix_args,
      position         => 'before module pam_deny.so',
    }
    if $_pw_history_module == 'pam_pwhistory.so' {
      pam { "Abide - set pam_pwhistory password required in ${svc}":
        ensure           => present,
        service          => $svc,
        type             => 'password',
        control          => 'required',
        control_is_param => true,
        module           => $_pw_history_module,
        arguments        => $_pwhistory_args,
        position         => 'before module pam_unix.so',
        require          => Pam["Abide - set pam_unix password requisite in ${svc}"],
      }
    }
    case $_lockout_module {
      'pam_faillock.so': {
        pam { "Abide - set faillock auth required in ${svc}":
          ensure           => present,
          service          => $svc,
          type             => 'auth',
          control          => 'required',
          control_is_param => true,
          module           => $_lockout_module,
          arguments        => $_faillock_args,
          position         => 'after module pam_env.so',
        }
        -> pam { "Abide - set faillock auth default=die in ${svc}":
          ensure           => present,
          service          => $svc,
          type             => 'auth',
          control          => '[default=die]',
          control_is_param => true,
          module           => $_lockout_module,
          arguments        => $_faillock_die_args,
          position         => 'after module pam_faillock.so',
        }
        pam { "Abide - set faillock account required in ${svc}":
          ensure           => present,
          service          => $svc,
          type             => 'account',
          control          => 'required',
          control_is_param => true,
          module           => $_lockout_module,
        }
      }
      'pam_tally2.so': {
        pam { "Abide - set tally2 auth required in ${svc}":
          ensure           => present,
          service          => $svc,
          type             => 'auth',
          control          => 'required',
          control_is_param => true,
          module           => $_lockout_module,
          arguments        => $_tally2_args,
          position         => 'after module pam_env.so',
        }
        pam { "Abide - set tally2 account required in ${svc}":
          ensure           => present,
          service          => $svc,
          type             => 'account',
          control          => 'required',
          control_is_param => true,
          module           => $_lockout_module,
        }
      }
      default: {
        fail("Lockout module ${_lockout_module} is invalid!")
      }
    }
  }
}
