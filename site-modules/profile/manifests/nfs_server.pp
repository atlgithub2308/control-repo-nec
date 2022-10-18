# Used to set up a basic NFS server for testing
# This is not a secure NFS server, it is intended for testing only
class profile::nfs_server (
  Stdlib::UnixPath $export_dir,
  String[1] $test_file_name,
  String[1] $test_file_content,
  String[1] $export_clients,
) {
  file { $export_dir:
    ensure => directory,
  }
  ~> file { "${export_dir}/${test_file_name}":
    ensure  => file,
    mode    => '0777',
    content => $test_file_content,
  }
  class { '::nfs':
    server_enabled => true,
  }
  nfs::server::export { $export_dir:
    ensure    => 'mounted',
    clients   => $export_clients,
    subscribe => File["${export_dir}/${test_file_name}"],
  }
}
