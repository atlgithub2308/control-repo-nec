# Tests DSC resources on Windows Server 2022
class profile::win_serv_2022_dsc_test {
  # lint:ignore:140chars
  # lint:ignore:arrow_alignment
  dsc_securityoption { 'CEM - DSC SecurityOption':
    dsc_accounts_administrator_account_status => 'Disabled',
    dsc_accounts_block_microsoft_accounts => 'Users cant add or log on with Microsoft accounts',
    dsc_accounts_guest_account_status => 'Disabled',
    dsc_accounts_limit_local_account_use_of_blank_passwords_to_console_logon_only => 'Enabled',
    dsc_accounts_rename_administrator_account => 'magic',
    dsc_accounts_rename_guest_account => 'pumpkin',
    dsc_audit_audit_the_access_of_global_system_objects => 'Enabled',
    dsc_audit_audit_the_use_of_backup_and_restore_privilege => 'Enabled',
    dsc_audit_force_audit_policy_subcategory_settings_windows_vista_or_later_to_override_audit_policy_category_settings => 'Enabled',
    dsc_audit_shut_down_system_immediately_if_unable_to_log_security_audits => 'Enabled',
    dsc_dcom_machine_access_restrictions_in_security_descriptor_definition_language_sddl_syntax => undef,
    dsc_dcom_machine_launch_restrictions_in_security_descriptor_definition_language_sddl_syntax => undef,
    dsc_devices_allow_undock_without_having_to_log_on => 'Enabled',
    dsc_devices_allowed_to_format_and_eject_removable_media => 'Administrators',
    dsc_devices_prevent_users_from_installing_printer_drivers => 'Enabled',
    dsc_devices_restrict_cd_rom_access_to_locally_logged_on_user_only => 'Enabled',
    dsc_devices_restrict_floppy_access_to_locally_logged_on_user_only => 'Enabled',
    dsc_domain_member_digitally_encrypt_or_sign_secure_channel_data_always => 'Enabled',
    dsc_domain_member_digitally_encrypt_secure_channel_data_when_possible => 'Enabled',
    dsc_domain_member_digitally_sign_secure_channel_data_when_possible => 'Enabled',
    dsc_domain_member_disable_machine_account_password_changes => 'Enabled',
    dsc_domain_member_maximum_machine_account_password_age => undef,
    dsc_domain_member_require_strong_windows_2000_or_later_session_key => 'Enabled',
    dsc_interactive_logon_display_user_information_when_the_session_is_locked => 'Do not display user information',
    dsc_interactive_logon_do_not_display_last_user_name => 'Enabled',
    dsc_interactive_logon_do_not_require_ctrl_alt_del => 'Enabled',
    dsc_interactive_logon_machine_account_lockout_threshold => undef,
    dsc_interactive_logon_machine_inactivity_limit => undef,
    dsc_interactive_logon_message_text_for_users_attempting_to_log_on => 'Test logon text',
    dsc_interactive_logon_message_title_for_users_attempting_to_log_on => 'Test logon title',
    dsc_interactive_logon_number_of_previous_logons_to_cache_in_case_domain_controller_is_not_available => undef,
    dsc_interactive_logon_prompt_user_to_change_password_before_expiration => undef,
    dsc_interactive_logon_require_domain_controller_authentication_to_unlock_workstation => 'Disabled',
    dsc_interactive_logon_require_smart_card => 'Disabled',
    dsc_interactive_logon_smart_card_removal_behavior => 'Lock workstation',
    dsc_microsoft_network_client_digitally_sign_communications_always => 'Disabled',
    dsc_microsoft_network_client_digitally_sign_communications_if_server_agrees => 'Enabled',
    dsc_microsoft_network_client_send_unencrypted_password_to_third_party_smb_servers => 'Disabled',
    dsc_microsoft_network_server_amount_of_idle_time_required_before_suspending_session => undef,
    dsc_microsoft_network_server_attempt_s4u2self_to_obtain_claim_information => 'Default',
    dsc_microsoft_network_server_digitally_sign_communications_always => 'Disabled',
    dsc_microsoft_network_server_digitally_sign_communications_if_client_agrees => 'Enabled',
    dsc_microsoft_network_server_disconnect_clients_when_logon_hours_expire => 'Enabled',
    dsc_microsoft_network_server_server_spn_target_name_validation_level => 'Accept if provided by client',
    dsc_network_access_allow_anonymous_sid_name_translation => 'Disabled',
    dsc_network_access_do_not_allow_anonymous_enumeration_of_sam_accounts => 'Enabled',
    dsc_network_access_do_not_allow_anonymous_enumeration_of_sam_accounts_and_shares => 'Enabled',
    dsc_network_access_do_not_allow_storage_of_passwords_and_credentials_for_network_authentication => 'Enabled',
    dsc_network_access_let_everyone_permissions_apply_to_anonymous_users => 'Disabled',
    dsc_network_access_named_pipes_that_can_be_accessed_anonymously => undef,
    dsc_network_access_remotely_accessible_registry_paths => undef,
    dsc_network_access_remotely_accessible_registry_paths_and_subpaths => undef,
    dsc_network_access_restrict_anonymous_access_to_named_pipes_and_shares => 'Enabled',
    dsc_network_access_restrict_clients_allowed_to_make_remote_calls_to_sam => undef,
    dsc_network_access_shares_that_can_be_accessed_anonymously => undef,
    dsc_network_access_sharing_and_security_model_for_local_accounts => 'Classic - Local users authenticate as themselves',
    dsc_network_security_allow_local_system_to_use_computer_identity_for_ntlm => 'Enabled',
    dsc_network_security_allow_localsystem_null_session_fallback => 'Enabled',
    dsc_network_security_allow_pku2u_authentication_requests_to_this_computer_to_use_online_identities => 'Enabled',
    dsc_network_security_configure_encryption_types_allowed_for_kerberos => undef,
    dsc_network_security_do_not_store_lan_manager_hash_value_on_next_password_change => 'Enabled',
    dsc_network_security_force_logoff_when_logon_hours_expire => 'Enabled',
    dsc_network_security_lan_manager_authentication_level => 'Send LM & NTLM - use NTLMv2 session security if negotiated',
    dsc_network_security_ldap_client_signing_requirements => 'Negotiate Signing',
    dsc_network_security_minimum_session_security_for_ntlm_ssp_based_including_secure_rpc_clients => 'Require NTLMv2 session security',
    dsc_network_security_minimum_session_security_for_ntlm_ssp_based_including_secure_rpc_servers => 'Require NTLMv2 session security',
    dsc_network_security_restrict_ntlm_add_remote_server_exceptions_for_ntlm_authentication => undef,
    dsc_network_security_restrict_ntlm_add_server_exceptions_in_this_domain => undef,
    dsc_network_security_restrict_ntlm_audit_incoming_ntlm_traffic => 'Enable auditing for all accounts',
    dsc_network_security_restrict_ntlm_audit_ntlm_authentication_in_this_domain => 'Enable all',
    dsc_network_security_restrict_ntlm_incoming_ntlm_traffic => 'Allow all',
    dsc_network_security_restrict_ntlm_ntlm_authentication_in_this_domain => 'Disable',
    dsc_network_security_restrict_ntlm_outgoing_ntlm_traffic_to_remote_servers => 'Allow all',
    dsc_recovery_console_allow_automatic_administrative_logon => 'Disabled',
    dsc_recovery_console_allow_floppy_copy_and_access_to_all_drives_and_folders => 'Disabled',
    dsc_shutdown_allow_system_to_be_shut_down_without_having_to_log_on => 'Disabled',
    dsc_shutdown_clear_virtual_memory_pagefile => 'Enabled',
    dsc_system_cryptography_force_strong_key_protection_for_user_keys_stored_on_the_computer => 'User input is not required when new keys are stored and used',
    dsc_system_cryptography_use_fips_compliant_algorithms_for_encryption_hashing_and_signing => 'Enabled',
    dsc_system_objects_require_case_insensitivity_for_non_windows_subsystems => 'Disabled',
    dsc_system_objects_strengthen_default_permissions_of_internal_system_objects_eg_symbolic_links => 'Disabled',
    dsc_system_settings_optional_subsystems => undef,
    dsc_system_settings_use_certificate_rules_on_windows_executables_for_software_restriction_policies => 'Enabled',
    dsc_user_account_control_admin_approval_mode_for_the_built_in_administrator_account => 'Enabled',
    dsc_user_account_control_allow_uiaccess_applications_to_prompt_for_elevation_without_using_the_secure_desktop => 'Enabled',
    dsc_user_account_control_behavior_of_the_elevation_prompt_for_administrators_in_admin_approval_mode => 'Prompt for consent on the secure desktop',
    dsc_user_account_control_behavior_of_the_elevation_prompt_for_standard_users => 'Prompt for credentials on the secure desktop',
    dsc_user_account_control_detect_application_installations_and_prompt_for_elevation => 'Enabled',
    dsc_user_account_control_only_elevate_executables_that_are_signed_and_validated => 'Disabled',
    dsc_user_account_control_only_elevate_uiaccess_applications_that_are_installed_in_secure_locations => 'Disabled',
    dsc_user_account_control_run_all_administrators_in_admin_approval_mode => 'Enabled',
    dsc_user_account_control_switch_to_the_secure_desktop_when_prompting_for_elevation => 'Enabled',
    dsc_user_account_control_virtualize_file_and_registry_write_failures_to_per_user_locations => 'Enabled',
    dsc_name => 'cem_dsc_securityoption',
    validation_mode => 'resource',
  }
  dsc_accountpolicy { 'CEM - DSC AccountPolicy':
    dsc_account_lockout_duration                             => 30,
    dsc_account_lockout_threshold                            => 5,
    dsc_enforce_password_history                             => 24,
    dsc_enforce_user_logon_restrictions                      => 'Disabled',
    dsc_maximum_lifetime_for_service_ticket                  => undef,
    dsc_maximum_lifetime_for_user_ticket_renewal             => undef,
    dsc_maximum_password_age                                 => 365,
    dsc_maximum_tolerance_for_computer_clock_synchronization => undef,
    dsc_minimum_password_age                                 => 1,
    dsc_minimum_password_length                              => 14,
    dsc_password_must_meet_complexity_requirements           => 'Enabled',
    dsc_reset_account_lockout_counter_after                  => 30,
    dsc_store_passwords_using_reversible_encryption          => 'Disabled',
    dsc_name                                                 => 'cem_dsc_accountpolicy',
    validation_mode                                          => 'resource',
  }
  # lint:endignore
  # lint:endignore
}
