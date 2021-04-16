# @summary Provides an interface for applying benchmark classes
#
# abide provides a user-friendly interface for applying compliance
# benchmark classes. Configuration should be driven by Hiera, but
# you can also use class params to configure how a benchmark is
# applied to the system.
#
# @param [Enum['cis']] benchmark
#   The compliance benchmark you would like to enforce.
#
# @param [Optional[Hash]] config
#   A configuration hash for the chosen benchmark. See docs for more details.      
#
# @example Using defaults (CIS server level 1 benchmark)
#   include abide
#
# @example Specifying a benchmark config
#   class { 'abide':
#     benchmark => 'cis',
#     config    => {
#       'level' => '1',
#       'profile' => 'server',
#       'ignore' => ['1.1.1.1', '1.1.1.3'],
#       'control_configs' => {
#         'ensure_tmp_is_configured' => {
#           'noexec' => true,
#         },
#       },
#     },
#   }
#
class abide_linux (
  Enum['cis'] $benchmark = 'cis',
  Optional[Hash] $config = undef,
) {
  $base_dir = $facts['kernel'] ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/abide',
    default => '/opt/puppetlabs/abide',
  }
  $scripts_dir = "${base_dir}/scripts"
  $templates_dir = "${base_dir}/templates"
  @file { $base_dir:
    ensure => directory,
  }
  [$scripts_dir, $templates_dir].each |$dir| {
    @file { $dir:
      ensure  => directory,
      require => File[$base_dir],
    }
  }
  case $benchmark {
    'cis': {
      realize(File[$base_dir], File[$scripts_dir], File[$templates_dir])
      $profile = dig($config, 'profile')
      $level = dig($config, 'level')
      $include_dil = dig($config, 'include_dil')
      $only = dig($config, 'only')
      $ignore = dig($config, 'ignore')
      $control_configs = dig($config, 'control_configs')
      $preferred_exclusives = dig($config, 'preferred_exclusives')
      class { 'abide_linux::benchmarks::cis':
        profile              => $profile,
        level                => $level,
        include_dil          => $include_dil,
        only                 => $only,
        ignore               => $ignore,
        control_configs      => $control_configs,
        preferred_exclusives => $preferred_exclusives,
        require              => File[$base_dir, $scripts_dir, $templates_dir],
      }
    }
    default: {
      warning("Benchmark ${benchmark} not supported! Will not enforce.")
    }
  }
}
