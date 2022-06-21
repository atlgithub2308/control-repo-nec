# Primary profile for bootstrapping a Github Actions self-hosted runner for CEM
class profile::cem_gha_runner_venv inherits profile::cem_gha_runner_venv::global {
  include stdlib

  user { $profile::cem_gha_runner_venv::global::runner_user:
    ensure => present,
    home   => $profile::cem_gha_runner_venv::global::runner_home,
  }
  -> file { $profile::cem_gha_runner_venv::global::agent_toolsdirectory:
    ensure => directory,
    owner  => $profile::cem_gha_runner_venv::global::runner_user,
    group  => $profile::cem_gha_runner_venv::global::runner_user,
    mode   => '0755',
  }
  $profile::cem_gha_runner_venv::global::env_vars.each |$key, $val| {
    profile::cem_gha_runner_venv::env_var { "env_var ${key}=${val}":
      key   => $key,
      value => $val
    }
  }
  include profile::cem_gha_runner_venv::apt
  include profile::cem_gha_runner_venv::gcloud
  include profile::cem_gha_runner_venv::java
  include profile::cem_gha_runner_venv::nodejs
  include profile::cem_gha_runner_venv::python
  include profile::cem_gha_runner_venv::ruby
}