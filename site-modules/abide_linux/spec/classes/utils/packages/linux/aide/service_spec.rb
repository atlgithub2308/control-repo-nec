# frozen_string_literal: true

require 'spec_helper'

describe 'abide_linux::utils::packages::linux::aide::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'timer_schedule' => '*-*-* 00:00:00',
          'systemd_service_content' => 'test content',
        }
      end

      it { is_expected.to compile }
    end
  end
end
