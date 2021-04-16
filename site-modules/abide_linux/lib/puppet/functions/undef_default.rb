# frozen_string_literal: true

# undef_default.rb
# Takes two params, one is a Puppet class param and the
# other is a default value. If the Puppet class param is
# Undef, the default will be returned. Otherwise, the param
# value is returned.
Puppet::Functions.create_function(:undef_default) do
  dispatch :undef_default do
    required_param 'Any', :class_param
    required_param 'Any', :default
    return_type 'Any'
  end

  def undef_default(class_param, default = nil)
    if class_param.nil?
      default
    else
      class_param
    end
  end
end
