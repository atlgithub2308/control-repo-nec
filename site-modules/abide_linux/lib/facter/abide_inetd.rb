# frozen_string_literal: true

# abide_inetd.rb
#
# Provides information about (x)inted services
Facter.add(:abide_inetd) do
  confine kernel: 'Linux'
  setcode do
    def chk_inet_svc(svc)
      paths = '/etc/inetd.* /etc/xinetd.*'
      `grep -l -R "#{svc}" #{paths} 2>/dev/null`.split("\n")
    end
    results = {
      inetd_running: `ps -C inetd &> /dev/null && echo "true" || echo "false"`,
      xinetd_running: `ps -C xinetd &> /dev/null && echo "true" || echo "false"`,
      svc: {
        chargen: chk_inet_svc('chargen'),
        daytime: chk_inet_svc('daytime'),
        discard: chk_inet_svc('discard'),
        echo: chk_inet_svc('echo'),
        time: chk_inet_svc('time'),
        shell: chk_inet_svc('shell'),
        login: chk_inet_svc('login'),
        exec: chk_inet_svc('exec'),
        talk: chk_inet_svc('talk'),
        ntalk: chk_inet_svc('ntalk'),
        telnet: chk_inet_svc('telnet'),
        tftp: chk_inet_svc('tftp'),
      },
    }
    results
  end
end
