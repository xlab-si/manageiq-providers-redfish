class ManageIQ::Providers::Redfish::PhysicalInfraManager::BiosUpdate < ::PhysicalServerBiosUpdateTask
  include_concern 'StateMachine'
end
