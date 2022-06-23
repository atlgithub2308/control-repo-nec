# Primary profile for bootstrapping a Github Actions self-hosted runner for CEM
# These profiles are designed to work with Ubuntu 20.04 and closely mirror
# the official GitHub actions runner virtual environment found here: https://github.com/actions/virtual-environments/tree/main/images/linux
class profile::cem_gha_runner_venv inherits profile::cem_gha_runner_venv::global {
  include stdlib

  user { $profile::cem_gha_runner_venv::global::runner_user:
    ensure     => present,
    home       => $profile::cem_gha_runner_venv::global::runner_home,
    managehome => true,
    shell      => '/bin/bash',
  }
  -> file { $profile::cem_gha_runner_venv::global::agent_toolsdirectory:
    ensure => directory,
    owner  => $profile::cem_gha_runner_venv::global::runner_user,
    group  => $profile::cem_gha_runner_venv::global::runner_user,
    mode   => '0777',
  }
  -> file { $profile::cem_gha_runner_venv::global::runner_svc_dir:
    ensure => directory,
    owner  => $profile::cem_gha_runner_venv::global::runner_user,
    group  => $profile::cem_gha_runner_venv::global::runner_user,
    mode   => '0777',
  }
  -> file { $profile::cem_gha_runner_venv::global::runner_svc_env_file:
    ensure => file,
    owner  => $profile::cem_gha_runner_venv::global::runner_user,
    group  => $profile::cem_gha_runner_venv::global::runner_user,
    mode   => '0777',
  }
  $profile::cem_gha_runner_venv::global::base_env_vars.each |$key, $val| {
    profile::cem_gha_runner_venv::env_var { "env_var ${key}=${val}":
      key                      => $key,
      value                    => $val,
      add_to_environment_files => true,
      environment_file_paths   => [
        $profile::cem_gha_runner_venv::global::runner_svc_env_file,
      ],
      before                   => Systemd::Unit_file[$profile::cem_gha_runner_venv::global::runner_svc_unit_file],
    }
  }
  systemd::unit_file { $profile::cem_gha_runner_venv::global::runner_svc_unit_file:
    ensure  => present,
    enable  => true,
    active  => true,
    content => epp('profile/cem_gha_runner_venv/actions.runner.service.epp', {
      'runner_user'    => $profile::cem_gha_runner_venv::global::runner_user,
      'runner_svc_dir' => $profile::cem_gha_runner_venv::global::runner_svc_dir,
    })
  }
  include profile::cem_gha_runner_venv::apt
  include profile::cem_gha_runner_venv::gcloud
  include profile::cem_gha_runner_venv::java
  include profile::cem_gha_runner_venv::nodejs
  include profile::cem_gha_runner_venv::python
  include profile::cem_gha_runner_venv::ruby
}
