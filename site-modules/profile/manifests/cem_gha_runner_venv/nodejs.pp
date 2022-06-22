# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::cem_gha_runner_venv::nodejs
class profile::cem_gha_runner_venv::nodejs (
  String $version,
  Array[String] $node_modules,
  Optional[Array[Hash]] $modules_in_bin = undef,
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
      unless      => "npm --location=global ls | grep -q ${nm}",
      provider    => 'shell',
      refreshonly => true,
      subscribe   => Exec["bash /opt/node_installer ${version}"],
    }
  }
  $modules_in_bin.each |$nm| {
    exec { "npm -g install ${nm['name']}":
      path        => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      unless      => "file ${nm['path']}",
      provider    => 'shell',
      refreshonly => true,
      subscribe   => Exec["bash /opt/node_installer ${version}"],
    }
    if $nm['symlink'] {
      file { 'vercel symlink':
        ensure    => 'link',
        path      => $nm['path'],
        target    => $nm['symlink_path'],
        subscribe => Exec["npm -g install ${nm['name']}"],
      }
    }
  }
  file { '/usr/local/lib/node_modules':
    ensure    => directory,
    mode      => '0777',
    subscribe => Exec["bash /opt/node_installer ${version}"],
  }
}
