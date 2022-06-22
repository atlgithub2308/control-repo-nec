# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::cem_gha_runner_venv::python
class profile::cem_gha_runner_venv::python (
  Array[String] $pip,
  Array[String] $pipx,
  String $pipx_bin_dir = '/opt/pipx_bin',
  String $pipx_home = '/opt/pipx',
) inherits profile::cem_gha_runner_venv::global {
  File {
    ensure => directory,
    owner  => $profile::cem_gha_runner_venv::global::runner_user,
    group  => $profile::cem_gha_runner_venv::global::runner_user,
    mode   => '0777',
  }
  file { $pipx_home: }
  -> file { $pipx_bin_dir: }
  -> profile::cem_gha_runner_venv::env_var { "export PIPX_HOME=${pipx_home}":
    key   => 'PIPX_HOME',
    value => $pipx_home,
  }
  -> profile::cem_gha_runner_venv::env_var { "export PIPX_BIN_DIR=${pipx_bin_dir}":
    key   => 'PIPX_BIN_DIR',
    value => $pipx_bin_dir,
  }

  Package {
    ensure          => present,
    provider        => 'apt',
    install_options => ['-y', '--no-install-recommends'],
    require         => Profile::Cem_gha_runner_venv::Env_var["export PIPX_BIN_DIR=${pipx_bin_dir}"],
  }
  package { 'python3': }
  -> package { 'python3-dev': }
  -> package { 'python3-pip': }
  -> package { 'python3-venv': }
  -> package { 'pipx':
    provider        => 'pip',
    install_options => [],
  }
  ~> exec { 'python3 -m pipx ensurepath':
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    refreshonly => true,
    provider    => 'shell',
  }
}
