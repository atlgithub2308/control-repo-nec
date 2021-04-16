# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::sticky_bit' do
  let(:pre_condition) do
    [
      '@file {"/opt/puppetlabs/abide": }',
      '@file {"/opt/puppetlabs/abide/scripts": }',
    ]
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
