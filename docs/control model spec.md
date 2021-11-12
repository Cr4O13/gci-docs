# control model specification

This specifies the requirements for the control model

## Modeling Requirements

The control model is a gci_base model
All game controller controls must be based on this control model

## Interface Requirements

The control model must 
- be implemented as the object 'gci_control'
- provide a 'new' constructor
- provide a 'handle' method.
- provide a 'handler' method (fallback implementation) 

## Functional Requirements

The control model must provide the following basic features for control objects
- create a control object based on the control model
  - using the 'new' constructor
- maintain
  - a 'events' list for the events to be logged 
- receive handle requests from the dispatcher 
  - with the input as argument
  - map the input to a trigger
  - select the responder using the trigger
  - call the control handler with the responder and input
- use the 'log_event' method of the base model to log events
  - Info on receiving a 'handle' request
  - Info when no responder configured for the trigger
  - Error when default handler is executed.
  
## Usage Requirements

A control to be based on this model must provide to the 'new' constructor
- a map function to map inputs to triggers
- a list of responders for the different input triggers
- a class attribute
- a id.label attribute
- a handler specific to the control
and may provide
- additional events to log in the handler
