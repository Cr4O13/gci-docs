# Model Base specification

This specifies the requirements for the model base.

## Modeling Requirements

All gci model object must inherit from the model base.

## Interface Requirements

The model base must 
- be implemented as the object 'gci_base'
- provide a 'new' constructor
- provide a 'log_event' method.

## Functional Requirements

The model base must provide the following common features for the gci model objects
- log event

Logging requires the model base to
- maintain 
  - a list of parametrized log messages for the different events
- receive logging request with the arguments
  - level
  - event
  - the values for replacing the message parameters
- log the message to the Air Manager log file
  - if the object 'log' state is not false
  - using the API helper function 'log'
  - prefix the message with "GCI: "

## Usage Requirements

A gci model object to be based on this base model must provide
- its own list of parametrized log messages for the model events
