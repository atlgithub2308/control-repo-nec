# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::account_hardening
class abide_linux::utils::account_hardening (
  Optional[Boolean] $enforce_nologin = undef,
  Optional[Boolean] $enforce_root_default_gid = undef,
) {
  $_enforce_nologin = undef_default($enforce_nologin, true)
  $_enforce_root_default_gid = undef_default($enforce_root_default_gid, true)
  # lint:ignore:140chars
  $_nologin_chk = 'awk -F: \'($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $1!~/^\+/ && $3<\'"$(awk \'/^\s*UID_MIN/{print $2}\' /etc/login.defs)"\' && $7!="\'"$(which nologin)"\'" && $7!="/bin/false") {print}\' /etc/passwd | grep -qE "^\\w+"'
  $_nologin_set = 'awk -F: \'($1!="root" && $1!~/^\+/ && $3<\'"$(awk \'/^\s*UID_MIN/{print $2}\' /etc/login.defs)"\') {print $1}\' /etc/passwd | xargs -I \'{}\' passwd -S \'{}\' | awk \'($2!="L" && $2!="LK") {print $1}\' | while read -r user; do usermod -L "$user"; done'
  # lint:endignore
  $_root_gid_chk = '[[ \$(grep "^root:" /etc/passwd | cut -d: -f4) == 0 ]]'
  $_root_gid_set = 'usermod -g 0 root'

  Exec {
    path     => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    provider => 'shell',
  }
  if $_enforce_nologin {
    exec { 'abide_enforce_nologin':
      command => $_nologin_set,
      unless  => $_nologin_chk,
    }
  }
  if $_enforce_root_default_gid {
    exec { 'abide_enforce_root_default_gid':
      command => $_root_gid_set,
      unless  => $_root_gid_chk,
    }
  }
}
