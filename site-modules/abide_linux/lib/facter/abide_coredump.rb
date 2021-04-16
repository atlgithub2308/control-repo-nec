# frozen_string_literal: true

# abide_coredumps.rb
#
# Detects if core dumps are restricted
# Currently only supports Linux
Facter.add(:abide_coredump) do
  confine kernel: 'Linux'

  setcode do
    results = {
      unit_file_loaded: `systemctl list-unit-files | grep -q "coredump.service" && echo "true" || echo "false"`.strip,
      is_active: `systemctl is-active coredump.service`.strip,
      unit_file_exists: `test -f /etc/systemd/coredump.conf && echo "true" || echo "false"`.strip,
      is_enabled: `systemctl -q is-enabled coredump.service 2>/dev/null && echo "true" || echo "false"`.strip,
    }
    results
  end
end
