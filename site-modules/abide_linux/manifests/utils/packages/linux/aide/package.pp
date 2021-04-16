# @api private
# @summary Installs the AIDE package
#
# Installs the AIDE package
#
# @param [String] package_ensure
#      Passed directly into the package ensure param.
#
# @example
#   include abide_linux::utils::packages::linux::aide::package
class abide_linux::utils::packages::linux::aide::package (
  String $db_dir,
  Optional[String] $package_ensure = undef,
) {
  package { 'aide':
    ensure => present,
  }
  exec { '/usr/sbin/aide --init':
    unless  => "test -f ${db_dir}/aide.db.gz",
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    require => Package['aide'],
  }
  -> exec { "mv ${db_dir}/aide.db.new.gz ${db_dir}/aide.db.gz":
    unless => "test -f ${db_dir}/aide.db.gz",
    path   => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  }
}
