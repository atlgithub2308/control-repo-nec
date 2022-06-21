# Class for installing GCP gcloud sdk
class profile::cem_gha_runner_venv::gcloud {
  include archive

  case $facts['os']['family'] {
    'Debian': {
      profile::cem_gha_runner_venv::apt_source { 'google-cloud-sdk.list':
        url          => 'https://packages.cloud.google.com/apt',
        distribution => 'cloud-sdk',
        gpg_url      => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
        gpg_target   => 'cloud.google.gpg',
      }
      ~> package { 'google-cloud-cli':
        ensure          => 'present',
        provider        => 'apt',
        install_options => ['-y'],
      }
    }
    default: { fail('OS family is not supported') }
  }
}
