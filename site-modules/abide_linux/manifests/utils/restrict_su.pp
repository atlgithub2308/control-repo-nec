# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include abide_linux::utils::restrict_su
class abide_linux::utils::restrict_su (
  Optional[String[1]] $group_name = undef,
  Optional[Integer] $group_gid = undef,
) {
  $_group_name = undef_default($group_name, 'abide_sugroup')
  $_group_gid = undef_default($group_gid, 9999)

  group { $_group_name:
    ensure    => present,
    allowdupe => false,
    gid       => $_group_gid,
    system    => true,
  }
  -> pam { "Abide - restrict su to users in ${_group_name} group":
    ensure    => present,
    service   => 'su',
    type      => 'auth',
    control   => 'required',
    module    => 'pam_wheel.so',
    arguments => ['use_uid', "group=${_group_name}"],
  }
}
