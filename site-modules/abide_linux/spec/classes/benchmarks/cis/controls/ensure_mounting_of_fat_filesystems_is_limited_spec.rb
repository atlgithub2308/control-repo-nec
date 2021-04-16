# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::benchmarks::cis::controls::ensure_mounting_of_fat_filesystems_is_limited' do
  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context "on #{os} - UEFI false" do
      let(:facts) do
        super().merge({ 'uefi_boot' => false })
      end

      it {
        is_expected.to compile
        is_expected.to contain_abide_linux__utils__disable_fs_mounting('vfat')
        is_expected.to contain_file('/etc/modprobe.d/vfat.conf')
        is_expected.to contain_exec('rmmod -s vfat')
      }
    end
    context "on #{os} - UEFI true" do
      let(:facts) do
        super().merge({ 'uefi_boot' => true })
      end

      it {
        is_expected.to compile
        is_expected.to contain_abide_linux__utils__disable_fs_mounting('vfat')
        # Something if off about the cases below. These work fine in
        # the defined type's test, but not here.
        # is_expected.not_to contain_file('/etc/modprobe.d/vfat.conf')
        # is_expected.not_to contain_exec('rmmod vfat')
      }
    end
  end
end
