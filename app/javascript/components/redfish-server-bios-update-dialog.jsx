import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import BiosUpdate from "./forms/bios-update"
import { createBiosUpdateRequest } from "../utils/api";

class RedfishServerBiosUpdateDialog extends React.Component {
  constructor(props) {
    super(props);
    this.handleFormStateUpdate = this.handleFormStateUpdate.bind(this);
    this.state = {
      loading: false,
      physicalServerIds: []
    }
  }

  selectedPhysicalServers = () => {
    if(ManageIQ.gridChecks.length > 0){ // Multi-record page
      this.setState({physicalServerIds: ManageIQ.gridChecks});
    } else if(ManageIQ.record.recordId){ // Single-record page
      this.setState({physicalServerIds: [ManageIQ.record.recordId]});
    } else{
      this.setState({physicalServerIds: [], error: __('Please select at lest one physical server to provision.')});
    }
  };

  componentDidMount() {
    this.props.dispatch({
      type: "FormButtons.init",
      payload: {
        newRecord: true,
        pristine: true,
        addClicked: () => createBiosUpdateRequest(
          this.state.physicalServerIds, this.state.values.biosConfig
        )
      }
    });
    this.props.dispatch({
      type: "FormButtons.customLabel",
      payload: __('Update BIOS')
    });
    this.selectedPhysicalServers();
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
      <BiosUpdate
        updateFormState={this.handleFormStateUpdate}
        physicalServerIds={this.state.physicalServerIds}
        loading={this.state.loading}
        initialValues={this.state.values}
      />
    );
  }
}

RedfishServerBiosUpdateDialog.propTypes = {
  dispatch: PropTypes.func.isRequired,
};

export default connect()(RedfishServerBiosUpdateDialog);
