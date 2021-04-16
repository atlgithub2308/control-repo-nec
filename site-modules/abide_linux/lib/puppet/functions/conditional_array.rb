# frozen_string_literal: true

# conditional_array.rb
# Builds an array based on conditional assignment.
# Each argument should be an 2 item array where
# the first item is a boolean value and the second
# item is the value to add to the array if item 1
# is true.
Puppet::Functions.create_function(:conditional_array) do
  dispatch :cond_array do
    required_repeated_param 'Array', :cond_arrays
    return_type 'Array'
  end

  def cond_array(*cond_arrays)
    output = []
    cond_arrays.each { |i| output.push(i[1]) if i[0] }
    output
  end
end
