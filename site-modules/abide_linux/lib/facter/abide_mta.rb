# frozen_string_literal: true

# abide_mta.rb
#
# Detects postfix and / or sendmail and
# enumerates some information about them.
# Currently only supports Linux
Facter.add(:abide_mta) do
  confine kernel: 'Linux'

  setcode do
    def postfix_smtp_iface
      return unless File.exist?('/etc/postfix/main.cf')

      `grep -Po '(?<=^inet_interfaces = ).*' /etc/postfix/main.cf`.strip
    end

    def sendmail_smtp_iface
      cmd = 'grep -Po "(?<=^DAEMON_OPTIONS\\(\\`).*Port=smtp[^\']*" /etc/mail/sendmail.mc'
      return unless File.exist?('/etc/mail/sendmail.mc')

      `#{cmd}`.strip
    end

    def find_smtp_iface(mta)
      case mta
      when 'postfix'
        postfix_smtp_iface
      when 'sendmail'
        sendmail_smtp_iface
      else
        "MTA #{mta} not supported"
      end
    end

    results = {}
    results[:non_lo_listening] = []
    lstn = `ss -lntu | grep -E ':25\\s' | grep -E -v '\\s(127.0.0.1|\\[?::1\\]?):25\\s'`.split("\n")
    lstn.map!(&:split)
    lstn.each do |i|
      lst = {
        netid: i[0],
        state: i[1],
        rec_q: i[2],
        sen_q: i[3],
        local: i[4],
        peer: i[5],
      }
      results[:non_lo_listening].push(lst)
    end
    ['postfix', 'sendmail'].each do |svc|
      s = `$(command -v systemctl) list-unit-files | grep #{svc} | awk '{print $1,$2}'`.strip
      next if s.nil? || s.empty?

      s_name = s.split[0]
      s_status = s.split[1]
      p_name = s_name.split('.')[0]
      results[p_name.to_sym] = {
        service_status: "#{s_name} #{s_status}",
        smtp_iface: find_smtp_iface(p_name)
      }
    end
    results
  end
end
