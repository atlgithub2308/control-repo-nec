# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::cem_gha_runner_venv::java
class profile::cem_gha_runner_venv::java (
  String $default_vendor,
  String $default_version,
  Array[Hash] $repos,
  Array[Hash] $packages,
  Optional[Hash] $maven = undef,
  Optional[Hash] $gradle = undef,
) inherits profile::cem_gha_runner_venv::global {
  include archive
  include stdlib

  $repos.each |$repo| {
    profile::cem_gha_runner_venv::apt_source { $repo['name']:
      target     => $repo['target'],
      url        => $repo['url'],
      gpg_url    => $repo['gpg_url'],
      gpg_target => $repo['gpg_target'],
    }
  }
  $packages.each |$package| {
    $package['versions'].each |$version| {
      if $package['vendor'] == 'Temuran-Hotspot' {
        package { "temurin-${version}-jdk=\\*":
          ensure          => present,
          provider        => 'apt',
          install_options => ['-y'],
          subscribe       => Profile::Cem_gha_runner_venv::Apt_source['GPG Java adoptium', 'GPG Java adopt'],
        }
        if $package['vendor'] == $default_vendor and $version == $default_version {
          profile::cem_gha_runner_venv::env_var { "export JAVA_HOME=/usr/lib/jvm/temurin-${version}-jdk-amd64":
            key       => 'JAVA_HOME',
            value     => "/usr/lib/jvm/temurin-${version}-jdk-amd64",
            subscribe => Package["temurin-${version}-jdk=\\*"],
          }
        } else {
          profile::cem_gha_runner_venv::env_var { "export JAVA_HOME_${version}_X64=/usr/lib/jvm/temurin-${version}-jdk-amd64":
            key       => "JAVA_HOME_${version}_X64",
            value     => "/usr/lib/jvm/temurin-${version}-jdk-amd64",
            subscribe => Package["temurin-${version}-jdk=\\*"],
          }
        }
      } elsif $package['vendor'] == 'Adopt' {
        package { "adoptopenjdk-${version}-hotspot=\\*":
          ensure          => present,
          provider        => 'apt',
          install_options => ['-y'],
          subscribe       => Profile::Cem_gha_runner_venv::Apt_source['GPG Java adoptium', 'GPG Java adopt'],
        }
        if $package['vendor'] == $default_vendor and $version == $default_version {
          profile::cem_gha_runner_venv::env_var { "export JAVA_HOME=/usr/lib/jvm/adoptopenjdk-${version}-hotspot-amd64":
            key       => 'JAVA_HOME',
            value     => "/usr/lib/jvm/adoptopenjdk-${version}-hotspot-amd64",
            subscribe => Package["adoptopenjdk-${version}-hotspot=\\*"],
          }
        } else {
          profile::cem_gha_runner_venv::env_var { "export JAVA_HOME_${version}_X64=/usr/lib/jvm/adoptopenjdk-${version}-hotspot-amd64":
            key       => "JAVA_HOME_${version}_X64",
            value     => "/usr/lib/jvm/adoptopenjdk-${version}-hotspot-amd64",
            subscribe => Package["adoptopenjdk-${version}-hotspot=\\*"],
          }
        }
      } else {
        fail("Java vendor ${package['vendor']} is not supported!")
      }
    }
  }
}
