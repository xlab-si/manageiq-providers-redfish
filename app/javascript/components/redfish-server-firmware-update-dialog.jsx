import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import FirmwareUpdate from "./forms/firmware-update"
import { handleApiError, fetchFirmwareBinariesForServer, createFirmwareUpdateRequest } from "../utils/api";

class RedfishServerFirmwareUpdateDialog extends React.Component {
  constructor(props) {
    super(props);
    this.handleFormStateUpdate = this.handleFormStateUpdate.bind(this);
    this.state = {
      loading: true,
      physicalServerIds: [],
      firmwareBinaries: [],
    }
  }

  selectedPhysicalServers = async () => {
    if(ManageIQ.gridChecks.length > 0){ // Multi-record page
      await this.setState({physicalServerIds: ManageIQ.gridChecks});
    } else if(ManageIQ.record.recordId){ // Single-record page
      await this.setState({physicalServerIds: [ManageIQ.record.recordId]});
    } else{
      await this.setState({physicalServerIds: [], error: __('Please select at lest one physical server to update firmware for.')});
    }
  };

  fwBinaryToSelectOption = fwBinary => { return { value: fwBinary.id, label: `${fwBinary.name} (${fwBinary.description})` } };

  initializeData = () => fetchFirmwareBinariesForServer(this.state.physicalServerIds[0]).then((fwBinaries) => {
      this.setState({
        firmwareBinaries: fwBinaries.resources.map(this.fwBinaryToSelectOption),
        loading: false
      });
    }, handleApiError(this));

  componentDidMount() {
    this.props.dispatch({
      type: "FormButtons.init",
      payload: {
        newRecord: true,
        pristine: true,
        addClicked: () => createFirmwareUpdateRequest(this.state.physicalServerIds, this.state.values.firmwareBinary)
      }
    });
    this.props.dispatch({
      type: "FormButtons.customLabel",
      payload: __('Apply Firmware')
    });
    this.selectedPhysicalServers().then(this.initializeData);
  }

  handleFormStateUpdate(formState) {
    this.props.dispatch({
      type: "FormButtons.saveable",
      payload: formState.valid
    });
    this.props.dispatch({
      type: "FormButtons.pristine",
      payload: formState.pristine
    });
    this.setState({
      values: formState.values
    });
  }

  render() {
    if(this.state.error) {
      return <p>{this.state.error}</p>
    }
    return (
      <FirmwareUpdate
        updateFormState={this.handleFormStateUpdate}
        physicalServerIds={this.state.physicalServerIds}
        firmwareBinaries={this.state.firmwareBinaries}
        loading={this.state.loading}
        initialValues={this.state.values}
      />
    );
  }
}

RedfishServerFirmwareUpdateDialog.propTypes = {
  dispatch: PropTypes.func.isRequired,
};

export default connect()(RedfishServerFirmwareUpdateDialog);
