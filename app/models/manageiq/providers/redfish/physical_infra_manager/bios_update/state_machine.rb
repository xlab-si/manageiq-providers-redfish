module ManageIQ::Providers::Redfish::PhysicalInfraManager::BiosUpdate::StateMachine
  def start_bios_update
    update_and_notify_parent(:message => msg("start BIOS update"))

    case power_state = source.power_state_now
    when "poweringon"  then signal :poll_server_on_initial
    when "on"          then signal :power_off_server
    when "poweringoff" then signal :poll_server_off
    when "off"         then signal :apply_bios_settings
    else raise MiqException::MiqProvisionError, "Unexpected #{power_state}"
    end
  end

  def poll_server_on_initial
    if source.powered_on_now?
      signal :power_off_server
    else
      requeue_phase
    end
  end

  def power_off_server
    update_and_notify_parent(:message => msg("stop server"))
    source.power_down
    signal :poll_server_off
  end

  def poll_server_off
    if source.powered_off_now?
      signal :apply_bios_settings
    else
      requeue_phase
    end
  end

  def apply_bios_settings
    update_and_notify_parent(:message => msg("apply BIOS settings"))

    source.with_provider_object do |system|
      phase_context[:time] = system.Bios["@Redfish.Settings"].Time
      phase_context[:attributes] = system.Bios.Attributes.raw

      # TODO(@tadeboro): This is seriously bad, since we are loding YAML from
      # an untrusted source.
      attributes = YAML.load(options[:config])

      system.Bios["@Redfish.Settings"].SettingsObject.patch(payload: {
        "@Redfish.SettingsApplyTime" => { "ApplyTime" => "OnReset" },
        "Attributes"                 => attributes
      })
    end
    source.power_up

    signal :poll_bios_settings_applied
  end

  def poll_bios_settings_applied
    settings_applied = source.with_provider_object do |system|
      system.Bios["@Redfish.Settings"].Time != phase_context[:time] ||
        # TODO(@tadeboro): Implement logic for determining the end of the
        # operation on systems that do not have Time field. This is currently
        # tweaked for Dell servers (14G).
        system.Bios["@Redfish.Settings"].SettingsObject.Attributes.raw.empty?
    end

    if settings_applied
      signal :store_diff
    else
      requeue_phase
    end
  end

  def store_diff
    update_and_notify_parent(:message => msg("store BIOS settings diff"))
    old_attributes = phase_context[:attributes]
    new_attributes = source.with_provider_object { |s| s.Bios.Attributes.raw }
    options[:diff] = new_attributes.each_with_object([]) do |(k, v), acc|
      acc << [k, old_attributes[k], v] if v != old_attributes[k]
    end
    signal :done_bios_update
  end
end
