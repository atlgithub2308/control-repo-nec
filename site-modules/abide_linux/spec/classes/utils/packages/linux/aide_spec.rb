# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::packages::linux::aide' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
    context "on #{os} only control package" do
      let(:params) do
        {
          'manage_config' => false,
          'run_scheduled' => false,
        }
      end

      it { is_expected.to compile }
    end
    context "on #{os} only control service" do
      let(:params) do
        {
          'control_package' => false,
          'manage_config' => false,
        }
      end

      it { is_expected.to compile }
    end
  end
end
