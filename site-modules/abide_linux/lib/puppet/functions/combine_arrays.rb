# frozen_string_literal: true

# combine_arrays.rb
# Combines arrays into a one new array.
# Exposes options for uniqueness and flatness.
Puppet::Functions.create_function(:combine_arrays) do
  dispatch :comb_arrays do
    optional_param 'Boolean', :unique
    optional_param 'Boolean', :flatten
    optional_repeated_param 'Array', :arrays
    return_type 'Array'
  end

  def comb_arrays(unique = true, flatten = true, *arrays)
    return [] if arrays.empty?

    output = []
    arrays.each { |i| output.concat(i) }
    output.uniq! if unique
    output.flatten! if flatten
    output
  end
end
