# Type that manages apt-key gpg key commands
define profile::cem_gha_runner_venv::apt_key (
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl] $url,
  String $target = $title,
) {
  include archive
  include stdlib

  if $facts['os']['family'] != 'Debian' {
    fail('apt_key only works on Debian-family operating systems')
  }
  $target_path = "/usr/share/keyrings/${target}"

  archive::download { $target_path:
    url       => $url,
  }
  ~> file { $target:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  ~> exec { "apt-key --keyring ${target_path} add ${target_path}":
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    provider    => 'shell',
    refreshonly => true,
  }
}
