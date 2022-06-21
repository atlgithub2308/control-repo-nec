# Adds the given archives to the toolcache
define profile::cem_gha_runner_venv::toolcache_archives (
  String $toolcache,
  String $runner_user,
  String $base_url,
  Hash $archives,
) {
  include archive

  case $facts['kernel'] {
    /^[Ll].*/: { $temp_dir = '/tmp' }
    default: { fail('Unsupported OS') }
  }

  File {
    ensure  => directory,
    owner   => $runner_user,
    group   => $runner_user,
    mode    => '0777',
    recurse => true,
  }

  file { $toolcache: }
  $archives.each |$version, $data| {
    file { "${toolcache}/${version}": }
    ~> archive { $data['archive']:
      ensure       => present,
      path         => "${temp_dir}/${data['archive']}",
      source       => "${base_url}/${data['pin']}/${data['archive']}",
      extract      => true,
      extract_path => "${toolcache}/${version}",
      user         => $runner_user,
      group        => $runner_user,
      creates      => "${toolcache}/${version}/${data['creates']}",
      cleanup      => true,
    }
  }
}
