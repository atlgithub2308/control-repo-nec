# frozen_string_literal: true

# has_class.rb
# Determines whether a class manifest exists
# in the current module.
Puppet::Functions.create_function(:has_class) do
  dispatch :class? do
    required_param 'String', :class_name
    required_param 'String', :class_dir
    return_type 'Boolean'
  end

  def class?(class_name, class_dir)
    all_classes = Dir.children(class_dir)
    all_classes.include?(class_name) || all_classes.include?("#{class_name}.pp")
  end
end
