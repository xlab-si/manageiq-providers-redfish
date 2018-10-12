require "set"

module ManageIQ::Providers::Redfish
  module PhysicalInfraManager::PhysicalServer::Operations
    def provision(pxe_server_id, pxe_image_id, customization_template_id)
      pxe_server = PxeServer.find(pxe_server_id)
      image = PxeImage.find(pxe_image_id)
      template = CustomizationTemplate.find(customization_template_id)

      ext_management_system.with_provider_connection do |client|
        system = client.find(ems_ref)
        get_mac_addresses(system).each do |addr|
          pxe_server.create_provisioning_files(image, addr, nil, template)
        end
        reboot_using_pxe(system)
      end
    end

    private

    def get_mac_addresses(system)
      macs = system.EthernetInterfaces.Members.reduce(Set.new) do |a, e|
        a.add(e.PermanentMACAddress).add(e.MACAddress)
      end

      if macs.empty?
        ["e0:d5:5e:52:4d:a1", "e0:d5:5e:52:4d:a2",
         "e0:d5:5e:52:4e:41", "e0:d5:5e:52:4e:42"]
      else
        macs
      end
    end

    def reboot_using_pxe(system)
      r = system.patch(:payload => {
        "Boot" => {
          "BootSourceOverrideEnabled" => "Once",
          "BootSourceOverrideTarget"  => "Pxe"
        }
      })
      $redfish_log.info(r)
      raise "Cannot override boot order" if r.status >= 400

      restart_operation = find_restart_operation(system)

      # TODO(@tadeboro): This is a temporary implementation. Redfish client
      # should get a refresh functionality and then we can add a loop here
      # that will gracefully handle any state.
      reset_type = system.PowerState == "On" ? restart_operation : "On"
      r = system.Actions["#ComputerSystem.Reset"].post(
        :field => "target", :payload => { "ResetType" => reset_type }
      )
      $redfish_log.info(r)
      raise "Cannot initialte reboot" if r.status >= 400
    end

    def find_restart_operation(system)
      supported_ops = system.dig("Actions", "#ComputerSystem.Reset",
                                 "ResetType@Redfish.AllowableValues") || []
      %w[GracefulRestart ForceRestart].find { |r| supported_ops.include?(r) }
    end
  end
end
