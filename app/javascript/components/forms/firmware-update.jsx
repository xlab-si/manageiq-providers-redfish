import React, { Component } from "react";
import { Form, Field, FormSpy } from "react-final-form";
import { Form as PfForm, Grid, Button, Col, Row, Spinner } from "patternfly-react";
import PropTypes from "prop-types";
import { required } from "redux-form-validators";

import { FinalFormField, FinalFormSelect } from "@manageiq/react-ui-components/dist/forms";
import '@manageiq/react-ui-components/dist/forms.css';

const FirmwareUpdate = ({loading, updateFormState, physicalServerIds, initialValues, firmwareBinaries}) => {
  if(loading){
    return (
      <Spinner loading size="lg" />
    );
  }

  return (
    <Form
      onSubmit={() => {}} // handled by modal
      initialValues={initialValues}
      render={({ handleSubmit }) => (
        <PfForm horizontal>
          <FormSpy onChange={state => updateFormState({ ...state, values: state.values })} />
          <Grid fluid>
            <Row>
              <Col xs={12}>
                <h2>{__(`Number of servers to update firmware for: ${physicalServerIds.length}`)}</h2>
              </Col>
            </Row>
            <hr />
            <Row>
              <Col xs={12}>
                <Field
                  name="firmwareBinary"
                  component={FinalFormSelect}
                  placeholder={__('Select a Firmware Binary')}
                  options={firmwareBinaries}
                  label={__('Firmware Binary')}
                  validateOnMount={false}
                  validate={required({ msg: 'Firmware Binary is required' })}
                  labelColumnSize={3}
                  inputColumnSize={8}
                  searchable
                />
              </Col>
              <hr />
            </Row>
          </Grid>
        </PfForm>
      )}
    />
  );
};

FirmwareUpdate.propTypes = {
  updateFormState: PropTypes.func.isRequired,
  physicalServerIds: PropTypes.array.isRequired,
  firmwareBinaries: PropTypes.array.isRequired,
  loading: PropTypes.bool.isRequired
};

FirmwareUpdate.defaultProps = {
  loading: false,
};

export default FirmwareUpdate;
