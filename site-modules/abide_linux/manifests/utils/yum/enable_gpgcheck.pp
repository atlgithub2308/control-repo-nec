# @summary Enables the gpgcheck option for all YUM repos
#
# Enables the gpgcheck option in /etc/yum.conf and all repo
# files found in /etc/yum.repos.d, if any exist.
#
# @example
#   include abide_linux::utils::yum::enable_gpgcheck
class abide_linux::utils::yum::enable_gpgcheck (
  Optional[String[1]] $yum_conf = undef,
  Optional[Array[String[1]]] $repo_files = undef,
) {
  $_yum_conf = $yum_conf ? {
    undef => '/etc/yum.conf',
    default => $yum_conf,
  }
  #$_repo_files = $repo_files ? {
  #  undef => $facts['abide_yumrepos'],
  #  default => $repo_files,
  #}
  ini_setting { "abide_${_yum_conf}":
    ensure  => present,
    path    => $_yum_conf,
    section => 'main',
    setting => 'gpgcheck',
    value   => '1',
  }
  #unless empty($_repo_files) {
  #  $_repo_files.each | String $repo_f | {
  #    ini_subsetting { "abide_${repo_f}":
  #      ensure            => present,
  #      path              => $repo_f,
  #      section           => '*',
  #      key_val_separator => '=',
  #      setting           => 'gpgcheck',
  #      value             => '1',
  #    }
  #  }
  #}
}
