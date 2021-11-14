# responder model specification

This specifies the requirements for the responder model

## Modeling Requirements

The responder model is a gci_base model
All responders must be based on this responder model

## Interface Requirements

The responder model must 
- be implemented as the object 'gci_responder'
- provide a 'new' constructor for responder objects
- provide a 'respond' method (fallback implementation)

## Functional Requirements

The responder model must provide the following basic features for responder objects
- create a responder object based on the responder model
  - using the 'new' constructor
- maintain
  - a 'events' list for the events to be logged 
- receive 'respond' requests from the control handler with
  - the input value
- use the 'log_event' method of the model base to log events
  - Info on receiving a respond request
  - Warning on missing respond method
  
## Usage Requirements

A responder to be based on this model must provide to the 'new' constructor
- a 'respond' function selected from the global 'api' functions
- a 'var_id' field, which is either a 
  - a 'variable' string for fs2020, fsx and p3d, or
  - a 'event' string for fs2020, fsx and p3d, or
  - a 'dataref' string for xplane, or
  - a 'commandref' string for xplane, or
  - the var_id from creating a SI 'variable'.
- for 'write' and 'publish' actions, a 'unit_id' field, which is either
  - a 'unit' string, for fs2020, fsx, p3d, si, or
  - a 'type' string for xplane.
- for xplane 'write' actions optionally
  - the offset integer
  - the force value (boolean)
- a 'output' function returning an output value calculated from the given input value
 