module ManageIQ::Providers::Redfish
  class PhysicalInfraManager::ProvisionTask < MiqProvisionTask
    alias_attribute :physical_server, :source

    AUTOMATE_DRIVES = false
    SUCCESS = 200

    def description
      "Apply configuration pattern"
    end

    def self.request_class
      PhysicalServerProvisionRequest
    end

    def model_class
      ManageIQ::Providers::Redfish::PhysicalInfraManager::PhysicalServer
    end

    def deliver_to_automate
      super("physical_server_provision", my_zone)
    end

    def do_request
      $redfish_log.info("Started provisioning Redfish server #{source.name}.")

      # TODO(tadeboro): PXE server should come from dropdown
      pxe_server_id = PxeServer.first.id

      source.provision(pxe_server_id,
                       options[:src_pxe_image_id][0],
                       options[:src_configuration_profile_id][0])
      update_and_notify_parent(
        :state   => "finished",
        :status  => "Ok",
        :message => "#{request_class::TASK_DESCRIPTION} complete"
      )

      $redfish_log.info("Done provisioning Redfish server #{source.name}.")
    rescue StandardError => e
      update_and_notify_parent(
        :state   => "finished",
        :status  => "Error",
        :message => e.to_s
      )
      $redfish_log.warn(e.to_s)
    end
  end
end
