# frozen_string_literal: true

# abide_uses_uefi.rb
#
# Detects if a machine booted with UEFI
# Currently only supports Linux
Facter.add(:abide_uefi_boot) do
  confine kernel: 'Linux'

  setcode do
    code = File.exist?('/sys/firmware/efi') ? 'true' : 'false'
    code
  end
end
