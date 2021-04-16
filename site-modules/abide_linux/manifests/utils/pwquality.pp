# @summary Configures password quality rules
#
# This class allows you to configure /etc/security/pwquality.conf.
# If you enforce this class, the existing /etc/security/pwquality.conf
# will be overwritten. All parameter defaults, except those set by CIS,
# were taken from https://www.systutorials.com/docs/linux/man/5-pwquality.conf/.
# Please see the link above for explanations of all the parameters.
#
# @param [Optional[Integer]] difok
#   Default: 1
# @param [Optional[Integer]] minlen
#   Default: 14
# @param [Optional[Integer]] dcredit
#   Default: -1
# @param [Optional[Integer]] ucredit
#   Default: -1
# @param [Optional[Integer]] lcredit
#   Default: -1
# @param [Optional[Integer]] ocredit
#   Default: -1
# @param [Optional[Integer]] minclass
#   Default: 4
# @param [Optional[Integer]] maxrepeat
#   Default: 0
# @param [Optional[Integer]] maxsequence
#   Default: 0
# @param [Optional[Integer]] maxclassrepeat
#   Default: 0
# @param [Optional[Enum[0, 1]]] gecoscheck
#   Default: '0'
# @param [Optional[Enum[0, 1]]] dictcheck
#   Default: '1'
# @param [Optional[Enum[0, 1]]] usercheck
#   Default: '1'
# @param [Optional[Enum[0, 1]]] enforcing
#   Default: '1'
# @param [Optional[Integer]] retry
#   Default: 1
# @param [Optional[Integer]] pam_retry
#   Default: 3
# @param [Optional[String]] badwords
# @param [Optional[Stdlib::AbsolutePath]] dictpath
#
# @example
#   include abide_linux::utils::pwquality
class abide_linux::utils::pwquality (
  Optional[Integer] $difok = undef,
  Optional[Integer] $minlen = undef,
  Optional[Integer] $dcredit = undef,
  Optional[Integer] $ucredit = undef,
  Optional[Integer] $lcredit = undef,
  Optional[Integer] $ocredit = undef,
  Optional[Integer] $minclass = undef,
  Optional[Integer] $maxrepeat = undef,
  Optional[Integer] $maxsequence = undef,
  Optional[Integer] $maxclassrepeat = undef,
  Optional[Enum['0', '1']] $gecoscheck = undef,
  Optional[Enum['0', '1']] $dictcheck = undef,
  Optional[Enum['0', '1']] $usercheck = undef,
  Optional[Enum['0', '1']] $enforcing = undef,
  Optional[String] $badwords = undef,
  Optional[Stdlib::AbsolutePath] $dictpath = undef,
  Optional[Integer] $retry = undef,
  Optional[Integer] $pam_retry = undef,
) {
  $_difok = undef_default($difok, 1)
  $_minlen = undef_default($minlen, 14)
  $_dcredit = undef_default($dcredit, -1)
  $_ucredit = undef_default($ucredit, -1)
  $_lcredit = undef_default($lcredit, -1)
  $_ocredit = undef_default($ocredit, -1)
  $_minclass = undef_default($minclass, 4)
  $_maxrepeat = undef_default($maxrepeat, 0)
  $_maxsequence = undef_default($maxsequence, 0)
  $_maxclassrepeat = undef_default($maxclassrepeat, 0)
  $_gecoscheck = undef_default($gecoscheck, '0')
  $_dictcheck = undef_default($dictcheck, '1')
  $_usercheck = undef_default($usercheck, '1')
  $_enforcing = undef_default($enforcing, '1')
  $_retry = undef_default($retry, 1)
  $_pam_retry = undef_default($pam_retry, 3)

  $_settings = {
    'difok'          => $_difok,
    'minlen'         => $_minlen,
    'dcredit'        => $_dcredit,
    'ucredit'        => $_ucredit,
    'lcredit'        => $_lcredit,
    'ocredit'        => $_ocredit,
    'minclass'       => $_minclass,
    'maxrepeat'      => $_maxrepeat,
    'maxsequence'    => $_maxsequence,
    'maxclassrepeat' => $_maxclassrepeat,
    'gecoscheck'     => $_gecoscheck,
    'dictcheck'      => $_dictcheck,
    'usercheck'      => $_usercheck,
    'enforcing'      => $_enforcing,
    'badwords'       => $badwords,
    'dictpath'       => $dictpath,
    'retry'          => $_retry,
  }

  file { 'abide_pwquality_conf':
    ensure  => file,
    path    => '/etc/security/pwquality.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('abide_linux/config/pwquality.conf.epp', { 'settings' => $_settings }),
  }
}
