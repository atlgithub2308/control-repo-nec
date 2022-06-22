# Type that manages apt-key gpg key commands
define profile::cem_gha_runner_venv::apt_key (
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl] $url,
  Pattern[/[a-zA-Z0-9][a-zA-Z0-9._-]*\.(gpg|asc)/] $target = $title,
) {
  include archive
  include stdlib

  if $facts['os']['family'] != 'Debian' {
    fail('apt_key only works on Debian-family operating systems')
  }
  $target_path = "/usr/share/keyrings/${target}"

  archive::download { $target_path:
    ensure   => present,
    url      => $url,
    checksum => false,
  }
}
