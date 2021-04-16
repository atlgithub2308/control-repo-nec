# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::disable_fs_mounting' do
  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context "on #{os} - UEFI true, FS vfat" do
      let(:title) { 'vfat' }
      let(:facts) do
        super().merge({ 'abide_uefi_boot' => 'true' })
      end

      it {
        is_expected.to compile
        is_expected.not_to contain_file('/etc/modprobe.d/vfat.conf')
        is_expected.not_to contain_exec('rmmod -s vfat')
      }
    end
    context "on #{os} - UEFI false, FS vfat" do
      let(:title) { 'vfat' }
      let(:facts) do
        super().merge({ 'abide_uefi_boot' => 'false' })
      end

      it {
        is_expected.to compile
        is_expected.to contain_file('/etc/modprobe.d/vfat.conf')
        is_expected.to contain_exec('rmmod -s vfat')
      }
    end
  end
end
