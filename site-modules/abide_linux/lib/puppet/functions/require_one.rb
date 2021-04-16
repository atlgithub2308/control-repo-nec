# frozen_string_literal: true

# require_one.rb
# Returns true is there at least on value passed in is not nil.
# Returns false otherwise.
Puppet::Functions.create_function(:require_one) do
  dispatch :require_one do
    required_repeated_param 'Any', :params
    return_type 'Boolean'
  end

  def require_one(*params)
    num_nil = 0
    params.each do |i|
      next unless i.nil?
      num_nil += 1
    end
    return false if num_nil >= params.length
    true
  end
end
