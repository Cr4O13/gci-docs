# Controller Model Specification

This specifies the requirements for the controller model.

## Modeling Requirements

The controller model must inherit from the model base.
All gci controller objects must inherit from this controller model.

## Interface Requirements

The controller model must 
- be implemented as the object 'gci_controller'
- provide a 'new' constructor
- provide a 'dispatcher' method.

## Functional Requirements

The controller model must provide the following common features
- maintain 
  - a list of parametrized log messages for the events
  - a list of the configured controls
- act as dispatcher through
  - receive calls from Air Manager with the arguments
    - type (basic type of control)
    - index (identification of control)
    - input (input value)
  - select the control, based on type and index
  - call the handle method of the control
- create 'new' controller using the Air Manager API function 'game_controller_add' with
  - the game controller 'name'
  - a callback function that calls the dispatcher method 
  - maintain the game controller id returned
  - return the controller
- use the log_event method of the model base when
  - game controller 'not found'
  - game controller 'added'
  - dispatcher 'called' from Air Manager
  - input dispatched to control handle method

## Usage Requirements

a gci contoller object based on this controller model must provide 
- the game controller 'name'
- the set of configured 'controls'
and may provide
- a log attribute

