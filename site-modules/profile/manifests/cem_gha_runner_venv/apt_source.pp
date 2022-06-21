# Type for managing apt sources
define profile::cem_gha_runner_venv::apt_source (
  String $target = $title,
  Boolean $add_signed_by = true,
  Boolean $deb_archive = true,
  Boolean $deb_src_archive = false,
  String $components = 'main',
  Optional[String] $distribution = undef,
  Optional[Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]] $url = undef,
  Optional[Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]] $gpg_url = undef,
  Optional[String] $gpg_target = undef,
) {
  $target_path = "/etc/apt/sources.list.d/${target}"
  $gpg_target_path = "/usr/share/keyrings/${gpg_target}"
  $_distribution = $distribution =~ Undef ? {
    true => $facts['os']['distro']['codename'],
    default => $distribution,
  }
  if $add_signed_by {
    $content = "deb [signed-by=${gpg_target_path}] ${url} ${_distribution} ${components}"
  } else {
    $content = "deb ${url} ${_distribution} ${components}"
  }
  file { $target_path:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
  }
  if $gpg_target !~ Undef {
    profile::cem_gha_runner_venv::apt_key { $gpg_target:
      url     => $gpg_url,
      require => File[$target_path],
      before  => Exec["apt update for source ${target}"],
    }
  }
  exec { "apt update for source ${target}":
    command     => 'apt-get update -y',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    provider    => 'shell',
    refreshonly => true,
  }
}
