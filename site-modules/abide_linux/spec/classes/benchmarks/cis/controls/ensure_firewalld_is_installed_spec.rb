# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::benchmarks::cis::controls::ensure_firewalld_is_installed' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'config' => {
            'ensure_package' => 'installed',
            'purge_direct_rules' => true,
          }
        }
      end

      it { is_expected.to compile }
    end
  end
end
