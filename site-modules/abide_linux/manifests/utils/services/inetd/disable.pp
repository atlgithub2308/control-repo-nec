# @summary Disables unwanted (x)inetd services
#
# Explicitly disables unwanted (x)inetd services
# by managing /etc/(x)inetd.conf and files in
# the /etc/(x)inetd.d/ directory.
#
# @example
#   include abide_linux::utils::services::inetd::disable
class abide_linux::utils::services::inetd::disable {
  if $facts['abide_inetd'] {
    $svc = $facts['abide_inetd'].dig('svc', undef)
    if $svc !~ Undef {
      $svc.each | $svcname, $paths| {
        if !empty($paths) {
          $paths.each | $source | {
            inetd_service { $svcname:
              disable                  => true,
              absent_satisfies_disable => true,
            }
          }
        }
      }
    }
  }
}
