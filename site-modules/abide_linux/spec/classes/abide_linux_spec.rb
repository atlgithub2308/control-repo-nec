# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux' do
  on_supported_os.each do |os, os_facts|
    context "using $only on #{os}" do
      let(:facts) { os_facts }

      let(:params) { { 'config' => { 'only' => ['disable_usb_storage'] } } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('abide_linux::benchmarks::cis::controls::disable_usb_storage') }
      it { is_expected.not_to contain_class('abide_linux::benchmarks::cis::controls::ensure_aide_is_installed') }
    end
    context "using $ignore on #{os}" do
      let(:facts) { os_facts }

      let(:params) { { 'config' => { 'ignore' => ['ensure_aide_is_installed'] } } }

      it { is_expected.to compile }
      it { is_expected.not_to contain_class('abide_linux::benchmarks::cis::controls::ensure_aide_is_installed') }
      it { is_expected.to contain_class('abide_linux::benchmarks::cis::controls::disable_usb_storage') }
    end
    context "using defaults on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('abide_linux::benchmarks::cis::controls::ensure_aide_is_installed') }
      it { is_expected.to contain_class('abide_linux::benchmarks::cis::controls::disable_usb_storage') }
    end
    context "using control_configs on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'config' => {
            'control_configs' => {
              'ensure_aide_is_installed' => {
                'conf_db_dir' => '/fake/db/test',
                'conf_log_dir' => '/fake/log/test',
              },
            },
          },
        }
      end

      it {
        is_expected.to compile
        is_expected.to contain_class('abide_linux::utils::packages::linux::aide').with('conf_db_dir' => '/fake/db/test', 'conf_log_dir' => '/fake/log/test')
      }
    end
  end
end
