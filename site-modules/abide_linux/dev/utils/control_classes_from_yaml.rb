#!/usr/bin/env ruby
# frozen_string_literal: true

# This script allows you to bulk create CIS control classes via the PDK
# It reads the Hiera file puppetlabs-abide/data/benchmarks/cis/linux.yaml,
# checks the lists of included controls against the class files present
# in puppetlabs-abide/manifests/benchmarks/cis/controls, and spawns
# PDK processes to create the classes that don't exist.
require 'yaml'

class_prefix = 'abide::benchmarks::cis::controls'
module_root = File.absolute_path("#{__dir__}/../../")
controls_root = File.absolute_path("#{module_root}/manifests/benchmarks/cis/controls")
cis_linux_hiera = YAML.safe_load(File.open("#{module_root}/data/benchmarks/cis/linux.yaml"))

missing_classes = []

puts 'Finding missing control classes based of Hiera defaults...'

cis_linux_hiera.each do |_, value|
  value['include'].each do |item|
    unless File.exist?("#{controls_root}/#{item}.pp")
      missing_classes.push("#{class_prefix}::#{item}")
    end
  end
end
missing_classes = missing_classes.uniq

if !missing_classes.empty?
  puts 'Creating missing classes with PDK...'
  missing_classes.each do |item|
    spawn("pdk new class #{item}")
  end
  Process.waitall
else
  puts 'No missing classes...'
end

puts 'Finished.'
