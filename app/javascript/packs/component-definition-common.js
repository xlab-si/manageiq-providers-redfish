import RedfishServerProvisionDialog
  from "../components/redfish-server-provision-dialog";
import RedfishServerBiosUpdateDialog
  from "../components/redfish-server-bios-update-dialog";

ManageIQ.component.addReact(
  "RedfishServerProvisionDialog", RedfishServerProvisionDialog
);

ManageIQ.component.addReact(
  "RedfishServerBiosUpdateDialog", RedfishServerBiosUpdateDialog
);
