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
    key                      => 'RUBY_PATH',
    value                    => $toolcache,
    add_to_environment_files => true,
    environment_file_paths   => [
      $profile::cem_gha_runner_venv::global::runner_svc_env_file,
    ],
  }
  $versions.each |$ruby_type, $vers| {
    $vers.each |$ver| {
      if $ruby_type == 'ruby' {
        $extract_path = "${toolcache}/${ver}"
        $creates = "${extract_path}/x64/bin/ruby"
      } elsif $ruby_type == 'jruby' {
        $extract_path = $toolcache
        $creates = "${toolcache}/jruby-${ver}/bin/jruby"
      } else {
        fail("${ruby_type} is not a supported Ruby type")
      }
      file { "${toolcache}/${ver}":
        subscribe => Profile::Cem_gha_runner_venv::Env_var['ruby path'],
      }
      ~> archive { "${ruby_type} ${ver}":
        ensure        => present,
        path          => "/tmp/${ruby_type}-${ver}${archive_suffix}",
        source        => "${download_url}/${ruby_type}-${ver}${archive_suffix}",
        extract       => true,
        extract_path  => $extract_path,
        extract_flags => 'xf',
        user          => $profile::cem_gha_runner_venv::global::runner_user,
        group         => $profile::cem_gha_runner_venv::global::runner_user,
        creates       => $creates,
        cleanup       => true,
      }
    }
  }
}
