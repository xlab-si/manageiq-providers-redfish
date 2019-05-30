class ManageIQ::Providers::Redfish::PhysicalInfraManager::FirmwareUpdate < ::PhysicalServerFirmwareUpdateTask
  # Firmware update is triggered in a single Redfish API call for a list of servers
  # hence we don't need more than one task per firmware update request.
  SINGLE_TASK = true

  include_concern 'StateMachine'
end
