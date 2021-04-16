# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::firewall::nftables' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts['kernelversion'] = '3.13.0'
        os_facts
      end

      it { is_expected.to compile }
    end

    context "on unsupported kernel version of #{os}" do
      let(:facts) do
        os_facts['kernelversion'] = '3.10.0'
        os_facts
      end

      it { is_expected.not_to compile }
    end
  end
end
