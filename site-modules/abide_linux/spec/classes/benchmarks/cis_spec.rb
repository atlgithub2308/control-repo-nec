# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::benchmarks::cis' do
  let(:pre_condition) do
    [
      '@file {"/opt/puppetlabs/abide": }',
      '@file {"/opt/puppetlabs/abide/scripts": }',
    ]
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os} with all" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      if os.match?(%r{[Cc]ent.*}) # CentOS has mutual exclusion in place for the following by default
        it { is_expected.to contain_class('abide_linux::benchmarks::cis::controls::ensure_firewalld_is_installed') }
        it { is_expected.not_to contain_class('abide_linux::benchmarks::cis::controls::ensure_iptables_packages_are_installed') }
      end
    end

    context "on #{os} with nftables" do
      let(:facts) do
        os_facts['kernelversion'] = '3.13.0'
        os_facts
      end
      let(:params) { { 'preferred_exclusives' => ['ensure_iptables_packages_are_installed'] } }

      it { is_expected.to compile }
      if os.match?(%r{[Cc]ent.*})
        it { is_expected.to contain_class('abide_linux::benchmarks::cis::controls::ensure_iptables_packages_are_installed') }
        it { is_expected.not_to contain_class('abide_linux::benchmarks::cis::controls::ensure_firewalld_is_installed') }
      end
    end

    context "on #{os} with only" do
      let(:facts) { os_facts }
      let(:params) { { 'only' => ['ensure_aide_is_installed', 'ensure_filesystem_integrity_is_regularly_checked'] } }

      it { is_expected.to compile }
    end
  end
end
