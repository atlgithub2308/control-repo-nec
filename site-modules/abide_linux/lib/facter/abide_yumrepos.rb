# frozen_string_literal: true

# abide_yumrepos.rb
#
# Enumerates YUM repo files that exist on the system
Facter.add('abide_yumrepos') do
  confine kernel: 'Linux'
  confine osfamily: 'RedHat'

  setcode do
    repos_d = '/etc/yum.repos.d'
    repos = Dir.children(repos_d) if Dir.exist?(repos_d)
    repos.map { |r| "#{repos_d}/#{r}" if r.end_with?('.repo') }
  end
end
