# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::yum::enable_gpgcheck' do
  on_supported_os.each do |os, os_facts|
    let(:facts) { os_facts }

    context "on #{os} with repos" do
      it { is_expected.to compile }
    end
  end
end
