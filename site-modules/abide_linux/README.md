# puppetlabs-abide_linux

*This module is proprietary content of Puppet. It is not to be shared outside of Puppet unless with service delivery partners who have signed the Puppet Strategic Services Amendment or with licensed customers.*

![Travis CI](https://travis-ci.com/puppetlabs/puppetlabs-abide_linux.svg?token=3Rrx4xGsRoTKH8Cun7Wc&branch=main)
![Nightly](https://github.com/puppetlabs/puppetlabs-abide_linux/workflows/nightly/badge.svg)

## Table of Contents

- [puppetlabs-abide](#puppetlabs-abide)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [What Abide affects](#what-abide-affects)
    - [Module Dependencies](#module-dependencies)
    - [Hiera](#hiera)
  - [Usage](#usage)
    - [Basic Example](#basic-example)
    - [Advanced Example](#advanced-example)
    - [More configuration examples](#more-configuration-examples)
  - [Limitations](#limitations)
  - [Development](#development)
    - [Module Dependencies and Licenses](#module-dependencies-and-licenses)
    - [Acceptance tests on PRs from forks](#acceptance-tests-on-prs-from-forks)
    - [Documentation](#documentation)

## Description

Abide aims to be a comprehensive, batteries-included module to enforce
compliance benchmarks. It is also very much a work-in-progress at the
moment.

At this stage, `puppetlabs-abide` **is incomplete**. Please check
back on this repo in the future or reach out to the Services Strategy
team for more information.

Abide is a comprehensive and slightly opinionated module. It's a good idea
to use this module on a test machine and see how it interacts with your
current Puppet code before using this module in production.

The way Abide works lends itself to playing nice with other Puppet code.
Each control you decide to enforce on a machine is a separate class, and
those control classes are dynamically included. This means that when you
ignore a control, that class providing the control never gets loaded into
the catalog. This helps prevent resource and dependency conflicts.

## Setup

### What Abide affects

Abide creates the following directories on posix systems:

- `/opt/puppetlabs/abide/`
- `/opt/puppetlabs/abide/scripts/`

### Module Dependencies

Abide requires the following modules exist in your Puppetfile:

| Module | Minimum Version |
|:------ |:---------------:|
| puppetlabs-stdlib | >= 4.13.1 |
| puppetlabs-concat | >= 6.4.0 |
| puppetlabs-puppet_agent | >= 4.0.0 |
| puppetlabs-inifile | >= 1.6.0 |
| puppetlabs-mount_providers | >= 2.0.1 |
| puppetlabs-augeas_core | >= 1.1.1 |
| puppetlabs-firewall | >= 2.8.1 |
| puppet-firewalld | >= 4.4.0 |
| puppet-logrotate | >= 5.0.0 |
| puppet-selinux | >= 3.2.0 |
| camptocamp-systemd | >= 2.10.0 |
| herculesteam-augeasproviders_core | >= 2.6.0 |
| herculesteam-augeasproviders_sysctl | >= 2.5.1 |
| herculesteam-augeasproviders_grub | >= 3.2.0 |
| herculesteam-augeasproviders_mounttab | >= 2.1.1 |
| herculesteam-augeasproviders_pam | >= 2.2.1 |
| herculesteam-augeasproviders_shellvar | >= 4.0.0 |
| herculesteam-augeasproviders_ssh | >= 4.0.0 |

### Hiera

Abide can be used without Hiera, but the best way to configure
Abide is with Hiera files. For more information about Hiera,
please see the [documentation](https://puppet.com/docs/puppet/latest/hiera_intro.html).

## Usage

Abide's benchmarks are configured to provide control enforcement and configuration
as directly specified by the chosen compliance framework by default.

For example, to enforce the CIS Server Level 1 benchmark for a node, just classify
the node with the class `abide`, set the `benchmark` parameter to `cis`, and run Puppet.

More comprehensive documentation can be found in the [reference](REFERENCE.md).

### Basic Example

Using abide to enforce **ONLY** the CIS level 1 server controls "Ensure AIDE is installed"
and "Ensure filesystem integrity is regularly checked" on a CentOS 7 node.

Step 1: Add some node-level Hiera data to your control repo:

```yaml
# hieradata/nodes/<node name>.yaml
abide::benchmark: 'cis'
abide::config:
  profile: 'server'
  level: '1'
  only:
    - 'ensure_abide_is_installed'
    - 'ensure_filesystem_integrity_is_regularly_checked'
```

Step 2: Classify the node with the class `abide`

Step 3: Run Puppet

Step 4: Several controls require you to run Bolt tasks. Look at the output of the Puppet run for the `notice` logs telling you which tasks to run.

### Advanced Example

Same scenario as the basic example, but this time I want to customize my AIDE
config file. All I need to do is edit my Hiera file like so:

Step 1: Modify the node's Hiera file

```yaml
# hieradata/nodes/<node name>.yaml
abide::benchmark: 'cis'
abide::config:
  profile: 'server'
  level: '1'
  only:
    - 'ensure_abide_is_installed'
    - 'ensure_filesystem_integrity_is_regularly_checked'
  control_configs:
    ensure_aide_is_installed:
      conf_rules:
        - 'PERMS = p+u+g+acl+xattrs'
        - 'CONTENT_EX = sha256+ftype+p+u+g+n+acl+xattrs'
      conf_checks:
        - '/root/\..* PERMS'
        - '/root/   CONTENT_EX'
```

Step 2: Classify the node with the class `abide`

Step 3: Run Puppet

Now my AIDE config file will reflect the changes I made to it via Hiera.
Every control that has something configurable will work like this,
docs for controls and their options are coming soon.

Step 4: Run required Bolt tasks.

### More configuration examples

Configure the `admins` group to grant passwordless sudo access:

```yaml
abide::benchmark: 'cis'
abide::config:
  profile: 'server'
  level: '1'
  control_configs:
    ensure_sudo_is_installed:
      package_ensure: 'installed'
      options:
        user_group:
          %admins:
            options:
              - 'NOPASSWD:'
```

## Limitations

- `nftables` is not currently supported. Please use `firewalld` or `iptables` instead
- Abide does not configure a bootloader password. This is best left to the provisioning process.
  - If you would like to set a bootloader password, please follow the steps below:
    - Run the command `grub2-setpassword` and enter the bootloader password you want to set; or
    - If you're on an older version of grub2:
      - Run the command `grub2-mkpasswd-pbkdf2` and enter the password you want to use to get an encrypted version
      - Add the following into `/etc/grub.d/01_users`
        - `set superusers="<username>"`
        - `password_pbkdf2 <username> <encrypted-password>`
    - Regenerate the grub config by running `grub2-mkconfig -o /boot/grub2/grub.cfg`
- Abide cannot set permissions on removeable media partitions due to the nature of those partitions not always being available.
  - To set the required permissions on these partitions, ensure `nodev,nosuid,noexec` exist in the options portion of `/etc/fstab` for the partition
- XD/NX support is dependent on the host kernel and we cannot automate it / manually configure it
  - Please ensure you are using modern, up-to-date kernels
- Restricting the root login to system console requires knowlege of the site.
  - This control will have to be implemented manually by removing any entries in `/etc/securetty` for consoles that are not in secure locations.

## Development

We've written a helper CLI tool for Abide development. Install it with `gem install abide_dev_utils`. Run `abide -h` for more information. You can find the [source for the dev utils here](https://github.com/hsnodgrass/abide_dev_utils).

### Module Dependencies and Licenses

Since Abide is proprietary, we need to be careful when adding dependencies to the module. Since copyleft licenses would require us to open source Abide and more protective licenses could open us up to legal troubles, we will only allow dependencies with the following licenses:

- BSD licenses except for the 4-clause BSD license
- MIT license
- Apache 2.0 license

### Acceptance tests on PRs from forks

In order to run acceptance tests against PRs from forked repositories, the PR must be labeled with the `acceptance test` label by a member of the SSE team.

### Documentation

Developer documentation for Abide [exists in the wiki](https://github.com/puppetlabs/puppetlabs-abide.wiki.git).
Please take a look at the wiki if you would like to contribute to Abide.
