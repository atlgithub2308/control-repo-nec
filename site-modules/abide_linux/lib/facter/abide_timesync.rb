# frozen_string_literal: true

# abide_timesync.rb
#
# Detects if a time synchronization package is installed
# and reports which one is in use (ntp or chrony).
# Currently only supports Linux.
Facter.add(:abide_timesync) do
  confine kernel: 'Linux'
  confine :os do |os|
    os['family'] == 'RedHat'
  end

  setcode do
    def installed?(val)
      !val.include?('not installed')
    end

    def zero?(val)
      val.strip == '0'
    end

    results = {}
    h_chrony = nil
    h_ntp = nil
    chrony_pkg = `$(command -v rpm) -q chrony`.strip
    ntp_pkg = `$(command -v rpm) -q ntp`.strip
    pkgs = []
    [chrony_pkg, ntp_pkg].each { |pkg| pkgs.push(pkg) if installed?(pkg) }

    if pkgs.include?(chrony_pkg)
      h_chrony = {}
      chrony_conf = File.exist?('/etc/chrony.conf')
      chrony_sysconfig = File.exist?('/etc/sysconfig/chronyd')
      h_chrony[:servers] = chrony_conf ? `grep -E "^(server|pool)" /etc/chrony.conf`.split("\n") : []
      h_chrony[:in_sysconfig_options] = chrony_sysconfig ? zero?(`grep -q '^OPTIONS=".*(-u chrony).*"' /etc/sysconfig/chronyd; echo $?`) : false
    end

    if pkgs.include?(ntp_pkg)
      h_ntp = {}
      ntp_conf = File.exist?('/etc/ntp.conf')
      ntp_sysconfig = File.exist?('/etc/sysconfig/ntpd')
      ntp_systemd = File.exist?('/usr/lib/systemd/system/ntpd.service')
      h_ntp[:restrict] = ntp_conf ? `grep "^restrict" /etc/ntp.conf`.split("\n") : []
      h_ntp[:servers] = ntp_conf ? `grep -E "^(server|pool)" /etc/ntp.conf`.split("\n") : []
      h_ntp[:in_sysconfig_options] = ntp_sysconfig ? zero?(`grep -q '^OPTIONS=".*(-u ntp:ntp).*"' /etc/sysconfig/ntpd; echo $?`) : false
      h_ntp[:in_systemd_execstart] = ntp_systemd ? zero?(`grep -q '^ExecStart=.*(-u ntp:ntp).*' /usr/lib/systemd/system/ntpd.service; echo $?`) : false
    end

    results[:installed] = pkgs.join(',')
    results[:details] = {}
    results[:details][:chrony] = h_chrony unless h_chrony.nil?
    results[:details][:ntp] = h_ntp unless h_ntp.nil?
    results
  end
end

Facter.add(:abide_timesync) do
  confine kernel: 'Linux'
  confine :os do |os|
    os['family'] != 'RedHat'
  end

  setcode do
    {}
  end
end
