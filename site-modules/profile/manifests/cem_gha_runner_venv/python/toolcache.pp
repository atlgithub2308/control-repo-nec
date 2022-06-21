# Python toolcache
class profile::cem_gha_runner_venv::python::toolcache (
  String $base_url,
  Hash $archives = {}
) inherits profile::cem_gha_runner_venv::global {
  profile::cem_gha_runner_venv::toolcache_archives { 'python toolcache':
    toolcache   => "${profile::cem_gha_runner_venv::global::agent_toolsdirectory}/Python",
    runner_user => $profile::cem_gha_runner_venv::global::runner_user,
    base_url    => $base_url,
    archives    => $archives,
  }
}
