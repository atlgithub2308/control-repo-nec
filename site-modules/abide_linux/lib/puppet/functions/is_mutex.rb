# frozen_string_literal: true

# is_mutex.rb
# Returns true if values passed in are mutually exclusive,
# meaning the other values are Undef (nil). Returns false
# otherwise.
Puppet::Functions.create_function(:is_mutex) do
  dispatch :mutex? do
    required_repeated_param 'Any', :params
    return_type 'Boolean'
  end

  def mutex?(*params)
    num_not_nil = 0
    params.each do |i|
      next if i.nil?
      num_not_nil += 1
    end
    return false if num_not_nil > 1
    true
  end
end
