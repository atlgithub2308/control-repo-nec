# Holds params that are of global relevance to the github actions virtual env
# I know, I know, inheritance bad, global variables bad
class profile::cem_gha_runner_venv::global (
  String $runner_user = 'runner',
  String $agent_toolsdirectory = '/opt/hostedtoolcache',
) {
  $_os_fact_str = "${facts['os']['name']}${facts['os']['release']['major']}"
  case $_os_fact_str {
    /^Ubuntu20.*$/: {
      $runner_home = "/home/${runner_user}"
      $image_os = 'ubuntu20'
      $path = "${home}/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/snap/bin:/opt/puppetlabs/bin"
      $xdg_config_home = "${runner_home}/.config"
      $base_env_vars = {
        'PATH'                 => $path,
        'HOME'                 => $runner_home,
        'ImageOS'              => $image_os,
        'ACCEPT_EULA'          => 'Y',
        'AGENT_TOOLSDIRECTORY' => $agent_toolsdirectory,
        'XDG_CONFIG_HOME'      => $xdg_config_home,
        'DEBIAN_FRONTEND'      => 'noninteractive',
      }
    }
    default: { fail('Unsupported OS') }
  }
}
