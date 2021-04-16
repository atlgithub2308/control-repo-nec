# frozen_string_literal: true

# TODO: This needs to be updated to include all resources

require 'spec_helper_acceptance'

# We ignore disable_automounting because it doesn't work on Docker
# We also need to configure permit_root_login so that connection
# doesn't fail during tests. We also ignore
# ensure_password_creation_requirements_are_configured because
# by default root accounts in Docker containers have no password
# and, therefore, are disabled from logging in. This doesn't
# prevent you from getting into a shell with docker exec, but
# it does kill litmus.
pp_basic_content = <<-BCON
  class { 'abide_linux':
    benchmark => 'cis',
    config    => {
      'profile' => 'server',
      'level'   => '1',
      'ignore'  => [
        'disable_automounting',
        'ensure_password_creation_requirements_are_configured',
      ],
      'control_configs' => {
        'ensure_permissions_on_etcsshsshd_config_are_configured' => {
          'permit_root_login' => 'yes',
        },
        'ensure_sudo_is_installed' => {
          'options' => {
            'user_group' => {
              '%wheel' => {
                'host' => 'ALL',
                'target_users' => 'ALL',
                'commands' => 'ALL',
                'options' => ['NOPASSWD:'],
              },
              'multi-test' => {
                'user_group' => ['test1', 'test2'],
                'host' => 'ALL',
                'target_users' => 'ALL',
                'commands' => ['/sbin/mount', '/sbin/umount'],
                'options' => ['NOPASSWD:'],
                'priority' => 99,
              },
            },
          },
        },
      },
    },
  }
BCON

pp_iptables = <<-IPTCON
  class { 'abide_linux':
    benchmark => 'cis',
    config    => {
      'profile' => 'server',
      'level'   => '1',
      'ignore'  => [
        'disable_automounting',
        'ensure_password_creation_requirements_are_configured',
      ],
      'preferred_exclusives' => [
        'ensure_iptables_packages_are_installed',
      ],
      'control_configs' => {
        'ensure_permissions_on_etcsshsshd_config_are_configured' => {
          'permit_root_login' => 'yes',
        },
      },
    },
  }
IPTCON
describe 'Abide' do
  describe 'with defaults on RHEL family', if: os[:family] == 'redhat' do
    it 'creates testuser1 before applying Abide' do
      run_shell('useradd testuser1')
      run_shell('echo -e "changeme\\nchangeme" | (passwd --stdin testuser1)')
    end
    it 'applies in noop' do
      apply_manifest(pp_basic_content, catch_failures: true, noop: true)
    end
    it 'applies idempotently' do
      idempotent_apply(pp_basic_content)
    end
    it 'creates testuser2 after applying Abide' do
      run_shell('useradd testuser2')
      run_shell('echo -e "changeme\\nchangeme" | (passwd --stdin testuser2)')
    end
    describe service('tmp.mount') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe file('/etc/modprobe.d/cramfs.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to contain 'install cramfs /bin/true' }
    end
    # The containers we use don't have grub files to modify
    describe file('/boot/grub2/grub.cfg'), if: host_inventory['virtualization'][:system] != 'docker' do
      it { is_expected.to be_mode 600 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end
    describe service('firewalld.service') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe command('rpm -q cups') do
      its(:exit_status) { is_expected.to eq 1 }
    end
    describe command('rpm -q rsync') do
      its(:exit_status) { is_expected.to eq 1 }
    end
    describe command('grep "SELINUXTYPE=.*" /etc/selinux/config') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{SELINUXTYPE=targeted} }
    end
    describe command('sshd -T | grep loglevel') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{loglevel INFO} }
    end
    describe command('sshd -T | grep x11forwarding') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{x11forwarding no} }
    end
    describe command('grep \'^\s*PASS_MAX_DAYS\' /etc/login.defs') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{PASS_MAX_DAYS(\t+|\s+)365.*} }
    end
    describe command('grep \'^testuser1\' /etc/shadow | cut -d: -f5') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{365} }
    end
    describe command('grep \'^testuser2\' /etc/shadow | cut -d: -f5') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{365} }
    end
    describe command('grep \'^testuser1\' /etc/shadow | cut -d: -f4') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{1} }
    end
    describe command('grep \'^testuser2\' /etc/shadow | cut -d: -f4') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{1} }
    end
    describe command('grep \'^testuser1\' /etc/shadow | cut -d: -f6') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{7} }
    end
    describe command('grep \'^testuser2\' /etc/shadow | cut -d: -f6') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{7} }
    end
    describe command('test -f /etc/profile.d/999-default_umask.sh') do
      its(:exit_status) { is_expected.to eq 0 }
    end
    describe command('grep -E \'^\s*auth\s+required\s+pam_wheel\.so\s+(\S+\s+)*use_uid\s+(\S+\s+)*group=\S+\s*(\S+\s*)*(\s+#.*)?$\' /etc/pam.d/su') do
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match %r{auth\s+required\s+pam_wheel\.so\s+use_uid\s+group=abide_sugroup} }
    end
    describe file('/etc/logrotate.conf') do
      it { is_expected.to be_file }
    end
    describe file('/etc/sudoers.d/10-group_wheel') do
      it { is_expected.to be_file }
    end
    describe file('/etc/sudoers.d/99-abide_ug_multi-test') do
      it { is_expected.to be_file }
    end
  end

  describe 'with defaults preferring iptables on RHEL family', if: os[:family] == 'redhat' do
    it 'applies idempotently' do
      idempotent_apply(pp_iptables)
    end
    describe service('iptables') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe service('ip6tables') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe service('firewalld.service') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
end
