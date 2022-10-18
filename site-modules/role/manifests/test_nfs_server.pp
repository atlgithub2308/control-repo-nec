# Designates a test NFS server
class role::test_nfs_server {
  include profile::nfs_server
}
