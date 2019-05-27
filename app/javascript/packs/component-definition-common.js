import RedfishServerProvisionDialog
  from "../components/redfish-server-provision-dialog";
import RedfishServerFirmwareUpdateDialog
  from "../components/redfish-server-firmware-update-dialog";
import RedfishServerBiosUpdateDialog
  from "../components/redfish-server-bios-update-dialog";

ManageIQ.component.addReact(
  "RedfishServerProvisionDialog", RedfishServerProvisionDialog
);

ManageIQ.component.addReact(
  "RedfishServerFirmwareUpdateDialog", RedfishServerFirmwareUpdateDialog
);

ManageIQ.component.addReact(
  "RedfishServerBiosUpdateDialog", RedfishServerBiosUpdateDialog
);
