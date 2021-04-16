# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::packages::linux::aide::package' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'db_dir' => '/var/lib/abide' } }

      it { is_expected.to compile }
    end
  end
end
