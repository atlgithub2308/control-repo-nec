# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/inetd_service'

RSpec.describe 'the inetd_service type' do
  it 'loads' do
    expect(Puppet::Type.type(:inetd_service)).not_to be_nil
  end
end
