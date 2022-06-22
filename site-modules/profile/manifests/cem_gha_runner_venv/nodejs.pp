# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::cem_gha_runner_venv::nodejs
class profile::cem_gha_runner_venv::nodejs (
  String $version,
  Array[String] $node_modules,
) {
  include archive

  archive::download { '/opt/node_installer':
    url      => 'https://raw.githubusercontent.com/tj/n/master/bin/n',
    checksum => false,
  }
  ~> exec { "bash /opt/node_installer ${version}":
    path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    unless      => "/bin/bash -c '[[ \"$(npm --version)\" =~ ^${version}.* ]] && exit 0 || exit 1'",
    refreshonly => true,
    provider    => 'shell',
  }
  $node_modules.each |$nm| {
    exec { "npm -g install ${nm}":
      path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      unless      => "npm -g ls | grep -q ${nm}",
      provider    => 'shell',
      refreshonly => true,
      subscribe   => Exec["bash /opt/node_installer ${version}"],
      before      => File['vercel symlink'],
    }
  }
  file { 'vercel symlink':
    ensure => 'link',
    path   => '/usr/local/bin/vercel',
    target => '/usr/local/bin/now',
  }
  file { '/usr/local/lib/node_modules':
    ensure    => directory,
    mode      => '0777',
    subscribe => Exec["bash /opt/node_installer ${version}"],
  }
}
