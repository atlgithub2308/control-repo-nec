# @summary Sets multiple sysctl settings with the same value
#
# Using either a comma-separated string of settings or an
# explicitly set $settings array, sets each setting with
# the value provided. Exposes all options of the 
# augeasproviders_sysctl custom type which is used to
# manage the settings.
#
# @param [String[1]] value
#   The value to set on EACH setting. Is passed directly
#   to the sysctl provider.
# @param [Enum[present, absent]] ensure
#   Used in determining ensurable of the provider. If
#   ensure is set to absent, all other parameters are
#   ignored with the exception of target.
# @param [Array[String[1]]] settings
#   An array of the sysctl settings you wish to modify.
#   By default, settings populates from the title by
#   splitting the title string on commas. This can be
#   overridden, however, if you would like a different
#   resource title.
# @param [Boolean] apply
#   Whether or not the setting should be applied via
#   the sysctl command. If set to false, the value will
#   still be written to file unless persist is also false.
# @param [Boolean] persist
#   Whether or not the setting should be written to
#   file. If set to false, the setting will still be
#   applied via the sysctl command unless apply is also
#   false.
# @param [Boolean] silent
#   If true, does not report errors if the system key
#   does not exist.
# @param [Stdlib::AbsolutePath] target
#   A path to a file to write the sysctl settings to.
# @param [String] comment
#   A comment to put into the file along with the sysctl
#   setting. Setting comment to a blank string will ensure
#   no comment is set.
#
# @example Disable IPv4 ICMP redirects and persist to a new file.
#   abide_linux::utils::multi_sysctl { 'net.ipv4.conf.all.accept_redirects,net.ipv4.conf.default.accept_redirects':
#     value  => '0',
#     target => '/etc/sysctl.d/10-disable_icmp_redirects.conf',
#   }
define abide_linux::utils::multi_sysctl (
  String[1] $value,
  Enum['present', 'absent'] $ensure = 'present',
  Array[String[1]] $settings = split($title, ','),
  Boolean $apply = true,
  Boolean $persist = true,
  Boolean $silent = false,
  Stdlib::AbsolutePath $target = '/etc/sysctl.conf',
  String $comment = 'MANAGED BY PUPPET',
) {
  if $ensure == 'absent' {
    $settings.each | String $setting | {
      sysctl { $setting:
        ensure => absent,
        target => $target,
      }
    }
  } else {
    $settings.each | String $setting | {
      sysctl { $setting:
        ensure  => present,
        value   => $value,
        apply   => $apply,
        persist => $persist,
        silent  => $silent,
        target  => $target,
        comment => $comment,
      }
    }
  }
}
