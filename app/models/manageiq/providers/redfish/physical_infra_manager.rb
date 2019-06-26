module ManageIQ::Providers::Redfish
  class PhysicalInfraManager < ManageIQ::Providers::PhysicalInfraManager
    require_nested :EventCatcher
    require_nested :EventParser
    require_nested :Refresher
    require_nested :RefreshWorker
    require_nested :PhysicalServer

    include Vmdb::Logging
    include ManagerMixin
    include_concern "Operations"

    has_many :physical_server_details,
             :class_name => "AssetDetail",
             :source     => :asset_detail,
             :through    => :physical_servers,
             :as         => :physical_server
    has_many :physical_chassis_details,
             :class_name => "AssetDetail",
             :source     => :asset_detail,
             :through    => :physical_chassis
    has_many :computer_systems,
             :through => :physical_servers,
             :as      => :computer_system
    has_many :hardwares,
             :through => :physical_servers,
             :as      => :hardware
    has_many :nics,
             :through => :hardwares
    has_many :storage_adapters,
             :through => :hardwares
    has_many :firmwares,
             :through => :hardwares

    def self.ems_type
      @ems_type ||= "redfish_ph_infra".freeze
    end

    def self.description
      @description ||= "Redfish".freeze
    end
  end
end
