# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::fstab_entry' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'device' => 'test',
      'fstype' => 'test',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
