# Sets up toolcache for Ruby
class profile::cem_gha_runner_venv::ruby::toolcache (
  Hash[String, Array[String]] $versions = {}
) inherits profile::cem_gha_runner_venv::global {
  include archive

  $toolcache = "${profile::cem_gha_runner_venv::global::agent_toolsdirectory}/Ruby"
  $download_url = 'https://github.com/ruby/ruby-builder/releases/download/toolcache/'
  $archive_suffix = "-${downcase($facts['os']['name'])}-${facts['os']['release']['major']}.tar.gz"
  File {
    ensure => directory,
    owner  => $profile::cem_gha_runner_venv::global::runner_user,
    group  => $profile::cem_gha_runner_venv::global::runner_user,
    mode   => '0777',
  }

  file { $toolcache: }
  -> profile::cem_gha_runner_venv::env_var { 'ruby path':
    key   => 'RUBY_PATH',
    value => $toolcache,
  }
  $versions.each |$ruby_type, $vers| {
    $vers.each |$ver| {
      file { "${toolcache}/${ver}":
        subscribe => Profile::Cem_gha_runner_venv::Env_var['ruby path'],
      }
      ~> archive { "${ruby_type} ${ver}":
        ensure        => present,
        path          => "/tmp/${ruby_type}-${ver}${archive_suffix}",
        source        => "${download_url}/${ruby_type}-${ver}${archive_suffix}",
        extract       => true,
        extract_path  => "${toolcache}/${ver}",
        extract_flags => 'xf',
        user          => $profile::cem_gha_runner_venv::global::runner_user,
        group         => $profile::cem_gha_runner_venv::global::runner_user,
        creates       => "${toolcache}/${ver}/x64/bin/ruby",
        cleanup       => true,
      }
    }
  }
}
