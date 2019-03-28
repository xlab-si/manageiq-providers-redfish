module ManageIQ::Providers::Redfish::Inventory::Persister::Definitions::PhysicalInfraCollections
  include ActiveSupport::Concern

  def initialize_physical_infra_collections
    %i(
      physical_servers
      physical_server_details
      computer_systems
      hardwares
      physical_racks
      physical_chassis
      physical_chassis_details
    ).each do |name|
      add_collection(physical_infra, name)
    end

    add_physical_server_nics
    add_physical_server_storages
    add_physical_server_firmwares
  end

  private

  def add_physical_server_nics
    add_collection(physical_infra, :nics) do |builder|
      builder.add_properties(
        :model_class                  => ::GuestDevice,
        :manager_ref                  => %i(device_type uid_ems),
        :parent_inventory_collections => %i(physical_servers)
      )
    end
  end

  def add_physical_server_storages
    add_collection(physical_infra, :storage_adapters) do |builder|
      builder.add_properties(
        :model_class                  => ::GuestDevice,
        :manager_ref                  => %i(device_type uid_ems),
        :parent_inventory_collections => %i(physical_servers)
      )
    end
  end

  def add_physical_server_firmwares
    add_collection(physical_infra, :firmwares) do |builder|
      builder.add_properties(
        :model_class                  => ::Firmware,
        :manager_ref                  => %i(name resource),
        :parent_inventory_collections => %i(physical_servers)
      )
    end
  end
end
