module ManageIQ::Providers::Redfish::PhysicalInfraManager::BiosUpdate::StateMachine
  def start_bios_update
    update_and_notify_parent(:message => msg('start bios update'))

    $redfish_log.info("BIOS update on physical server [#{source.id}] #{source.name}")
    $redfish_log.info("BIOS update with options #{options}")

    # The two lines above log:
    # [----] I, [2019-06-10T14:45:36.697490 #41212:2b1f16e24f18]  INFO -- : Q-task_id([r2_physical_server_bios_update_task_2]) BIOS update on physical server [2] Dell G5 Computer System (23840jr9384j)
    # [----] I, [2019-06-10T14:45:36.697795 #41212:2b1f16e24f18]  INFO -- : Q-task_id([r2_physical_server_bios_update_task_2]) BIOS update with options {:request_type=>"physical_server_bios_update", :src_ids=>["2"], :config=>"{\n\"BUREK\": \"PICA\"\n}", :delivered_on=>2019-06-10 12:45:32 UTC}

    signal :done_bios_update
  end
end