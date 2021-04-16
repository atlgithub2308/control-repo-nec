# frozen_string_literal: true

# process_conditionals.rb
# Takes an array of strings and a conditionals hash,
# usually from a Hiera lookup, and processes the conditional
# statements against the array and returns the resulting,
# mutated array.
Puppet::Functions.create_function(:process_conditionals) do
  dispatch :process_conditionals do
    required_param 'Array', :current_set
    required_param 'Hash', :conditionals
    optional_param 'Optional[Array]', :preferred
    return_type 'Array'
  end

  # Processes the `exclude` property of a control target.
  def exclude_controls(current_set, controls, preferred = nil)
    exclusions = []
    return exclusions if controls.nil?

    first = nil
    pref = nil
    controls.each do |key, _v|
      next unless current_set.include?(key) # If the control isn't in the current set, we don't care

      first = key if exclusions.empty? # Default behavior is to treat first like preferred if preferred is nil
      pref = key if preferred.include?(key) # This control will be exempt from exclusion
      excludes = controls.dig(key, 'exclude') # Get the controls in the exclude block
      next if excludes.nil? # if there isn't an exclude block, we don't care

      ex_children = controls.dig(key, 'exclude_children')
      excludes.each do |item|
        exclusions << item
        next unless ex_children

        controls[item]['children'].each { |chld| exclusions << chld }
      end
    end
    # Get rid of any nested arrays and duplicate elements
    exclusions.flatten.uniq!
    final_exclusions = if pref.nil? && !first.nil?
                         exclusions - [first, controls[first]['children']].flatten.uniq
                       elsif !pref.nil?
                         exclusions - [pref, controls[pref]['children']].flatten.uniq
                       else
                         exclusions
                       end
    final_exclusions
  end

  # Handles processing the `if` conditional against any targets.
  # Currently, the only target is `control` but this allows for
  # easy extension of the syntax.
  def if_control(current_set, controls, preferred = nil)
    return current_set if controls.nil?

    final_set = current_set
    exclude_op = false
    controls.each do |_ctrl, val|
      exclude_op = true if val['exclude']
    end
    final_set -= exclude_controls(current_set, controls, preferred) if exclude_op
    final_set
  end

  # Processes conditionals against the current set of controls.
  # Currently, the only implemented conditional is `if`, however
  # this allows for easy extension of the conditional syntax.
  def process_conditionals(current_set, conditionals, preferred = nil)
    final_set = []
    cond_if = conditionals['if']
    unless cond_if.nil?
      final_set += if_control(current_set, conditionals['if']['control'], preferred)
    end
    return current_set if final_set.empty?

    final_set.flatten.uniq
  end
end
