import React from "react";
import { Form, Field, FormSpy } from "react-final-form";
import { Form as PfForm, Grid, Col, Row, Spinner } from "patternfly-react";
import PropTypes from "prop-types";
import { required } from "redux-form-validators";

import { FinalFormTextArea } from "@manageiq/react-ui-components/dist/forms";
import '@manageiq/react-ui-components/dist/forms.css';

const BiosUpdate = ({loading, updateFormState, physicalServerIds, initialValues}) => {
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
                <h2>{__(`Number of servers to update BIOS for: ${physicalServerIds.length}`)}</h2>
              </Col>
            </Row>
            <hr />
            <Row>
              <Col xs={12}>
                <Field
                  name="biosConfig"
                  component={FinalFormTextArea}
                  placeholder={__('BIOS Configuration')}
                  label={__('BIOS Configuration')}
                  validateOnMount={false}
                  validate={required({ msg: 'BIOS Configuration is required' })}
                  labelColumnSize={12}
                  inputColumnSize={12}
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

BiosUpdate.propTypes = {
  updateFormState: PropTypes.func.isRequired,
  physicalServerIds: PropTypes.array.isRequired,
  loading: PropTypes.bool.isRequired
};

BiosUpdate.defaultProps = {
  loading: false,
};

export default BiosUpdate;
