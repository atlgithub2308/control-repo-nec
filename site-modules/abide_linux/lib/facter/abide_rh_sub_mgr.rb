# frozen_string_literal: true

# abide_rh_sub_mgr.rb
#
# Reports whether the RedHat subscription manager has an identity
Facter.add(:abide_redhat_subscription_manager) do
  confine Facter.value(:os)['name'] => 'RedHat'
  setcode do
    iden = `subscription-manager identity`.strip
    return 'unregistered' if %r{This system is not yet registered.*}.match?(iden)
    'registered'
  end
end
