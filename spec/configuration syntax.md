# Configuration Syntax
This specifies the syntax for the GCI configuration file

## JSON-Syntax

The specification file uses the JSON syntax. JSON is quite finnicky about missing or wrong delimiting characters like braces, brackets, commas, colons, and quotation marks.

All identifiers need to be enclosed in matching quotation marks `" "`. 

Literal string values need to be enclosed in matching quotation marks as well. 

All other literal values, like numbers, the boolean literals `true` and `false` or the `null` value, must not be enclosed in quotes. 

All fields of an object must be enclosed in matching curly braces `{ }`. Inside the objects, fields must be separated using commas `,`. A field name and its value must be separated with a colon `:`. 

All values of an array must be enclosed in matching brackets `[ ]`. Inside the array, values must be separated using commas `,`.

## EBNF Form
The following subsections describe the GCI syntax in the formal EBNF notation. This is given here for creating test cases and proper implementation only.

The EBNF notation defines the canonical form, which is the JSON object style. For some specification objects an array style form is available and possibly a simplified form. This is described in the WIKI documentation where applicable.

In deviation from standard EBNF rules, all curly braces `{ }`, brackets `[ ]`, colons `:`, quotation marks `" "` and commas `,` used in the EBNF notation below are meant to be entered literally. 

The double colon `::` and the parentheses `( )` retain their meaning in EBNF. They are not meant to be entered literally.

### GCI Configuration

This is the top-level entry of the formal notation

~~~
gci-configuration :: { configuration-spec }
configuration-spec :: controllers-field ( , defaults-field ) 
~~~

### Controllers

~~~
controllers-field :: "controllers" : [ controller-list ]
controller-list :: controller-spec ( , controller-list )
controller-spec :: { controller-name-field, controls ( , attributes ) }

controller-name-field :: "name" : controller-name
controller-name :: lua-string
~~~

The controller's name must be identical to the name Air Manager returns in the API function `game_controller_list`. This name should be identical to the name displayed by the Windows 'Game Controller' control panel (joy.cpl).

### Controls

~~~
controls :: controls-field ( , controls )
controls-field :: axis-field | button-field

axis-field :: "axis" : [ control-list ]
button-field :: "button" : [ control-list ]

control-list :: control-spec ( , control-list )
control-spec :: { id-field , action-field ( , subtype-field ) ( , attributes ) }
~~~

There are two basic types of control: `axis` and `button`. A control specification must be placed in the corresponding section in the configuration file.

#### Control Identification

~~~
id-field :: "id" : { "index" : index-value ( , "label" : label-value ) }
index-value :: lua-number
label-value :: lua-string
~~~

#### Control Action

~~~
action-field :: action-keyword : { responder-list }
action-keyword :: "write" | "send" | "publish"

responder-list :: responder-spec ( , responder-list )
responder-spec :: trigger-keyword : { responder-field-list }

responder-field-list :: responder-field (, responder-field-list )
responder-field :: var-id-field | unit-id-field | initial-field | offset-field | force-field | output-field
~~~

The `trigger-keyword` is specific to a control subtype (see below for the different subtypes.)

#### Control Subtypes

~~~
subtype-field :: "subtype" : { "name" : subtype-keyword ( , "parameters" : { parameter-list } ) }
subtype-keyword :: subtype-keyword

parameter-list :: parameter-value ( , parameter-list )
parameter-value :: lua-value
~~~

The `subtype-keyword` is specific to a control subtype (see below for the different subtypes.)

##### Keywords for Axis Subtype

`axis` is the subtype for true axes controls. The specified action is executed every time the input changes.

~~~
subtype-keyword :: "axis"
trigger-keyword :: "on_change"
~~~

##### Keywords for Switched Subtype

The `switched` subtype is used for axis inputs that have 3 states. The states are represented by the input values `-1.0`, `0.0` and `+1.0`. This is sometimes the case for some POV multiway switches. Two actions can be specified, one for each state. The corresponding action is executed when the state changes.

~~~
subtype-keyword :: "switched
trigger-keyword :: "on_plus" | "on_zero" | "on_minus"
~~~

##### Keywords for Button Subtype

`button` is the subtype for true buttons and switches (latching and non-latching). Two actions can be specified, one for a pressed button and one for a released action. The action is executed when the state changes.

~~~
subtype-keyword :: "button"
trigger-keyword :: "on_true" | "on_false"
~~~

##### Keywords for Timed Subtype

A `timed` button is a non-latching push button that repeats an action if the button is held pressed. The initial delay time, the repeating period and optionally a limit on the number of actions can be parameterized. Two actions can be specified, one for the repeating action and one for the stop action.

~~~
subtype-keyword :: "timed"
trigger-keyword :: "on_time" | "on_stop"
~~~

##### Keywords for Modal Subtype

A `modal` button is a non-latching push button that behaves differently depending on how much time the button is held pressed. The delay time for switching from mode 1 to mode 2 can be parameterized. Two actions can be specified, one for mode 1 and one for mode 2. The action is executed on release of the button.

~~~
subtype-keyword :: "modal"
trigger-keyword :: "on_mode1" | "on_mode2"
~~~

### Responder Fields

The responder is the specification object that defines the action content. The required content is defined by the API that Air Manager provides for the supported simulators. GCI uses that API for executing the actions.

#### Variable identifier

The API functions for the different simulators use specific identifiers for similar data references. GCI uses a generalized identifier, but the specific identifiers can be used as alias.

~~~
var-id-field :: var-id-keyword : var-name
var-id-keyword :: "var_id" | var_id-alias
var_id-alias :: "variable" | "dataref" | "event" | "commandref"
var-name :: lua-string
~~~

#### Variable identifier

The API functions for the different simulators use specific identifiers for similar data units. GCI uses a generalized identifier, but the specific identifiers can be used as alias.

~~~
unit-id-field :: unit-id-keyword : unit-name
unit-id-keyword :: "unit_id" | unit-id-alias
unit-id-alias :: "unit" | "type"
unit-name :: lua-string
~~~

#### Initial Value (for IIC)

For publishing a game controller input for IIC, an initial value is required.

~~~
initial-field :: "initial" : initial-value
initial-value :: lua-literal-value
~~~

#### Offset and Force Arguments

Writing to X-Plane dataref allows for two specific arguments.

~~~
offset-field :: "offset" : offset-value
offset-value :: lua-integer

force-field :: "force" : force-value
force-value :: lua-boolean
~~~

### Output Specification

The Output Specification defines the output value for the action. 

Axes and buttons use a slightly different set of output options.

~~~
output-field :: output-spec
output-spec :: axis-output-spec | other-output-spec
~~~

#### Axis Output Options

An axis type control can produce 
- direct output of the input value
- an inverted output
- a scaled output
- a nonlinear output response
- a combination of the above rules

~~~
axis-output-spec :: { axis-output-field-list }
axis-output-field-list :: axis-output-field ( , axis-output-field-list )
axis-output-field :: invert-field | scale-field | response-field

invert-field :: "invert" : invert-value
invert-value :: lua boolean

scale-field :: "scale" : scale-value
scale-value :: lua-number

response-field :: "response" : response-settings 
response-settings :: [ fix-point, fix-point-list ]

fix-point-list :: fix-point ( , fix-point-list )
fix-point :: [ input-value, output-value ]

input-value :: input-range-number
input-range-number :: -1.0 =< lua-number =< +1.0

output-value :: lua-number
~~~

#### Button Output

A button type control can produce 
- no output-value
- direct output of the input value
- an inverted output
- a fixed value

~~~
button-output-spec :: { ( button-output-field ) }
button-output-field :: invert-field | value-field

invert-field :: "invert" : invert-value
invert-value :: lua-boolean

value-field :: "value" : fixed-value
fixed-value :: lua-value
~~~

### Defaults

Some of the required specification fields can be omitted. GCI defines default values for them. The specification vene allows to change the default values individually.

~~~
defaults-field :: "defaults" : { defaults-list }
defaults-list :: defaults-field ( , defaults-list )

defaults-field :: simulator-defaults | controller-defaults | control-defaults | axis-defaults | switched-defaults | button-defaults | timed-defaults | modal-defaults
~~~

#### Simulator Defaults

This specifies which simulator API is to be used by GCI. GCI supports the X-Plane, MSFS2020, FSX and P3D APIs for send and write actions. For publish actions the SI API is used.

~~~
simulator-defaults :: "simulator" : simulator-name
simulator-name :: "xpl" | "fs2020" | "fsx" | "p3d"
~~~

#### Controller Defaults

This specifies a default log attribute for controllers.

~~~
controller-defaults :: "controller" : { controller-default-list }
controller-default-list :: controller-default ( , controller-default-list )
controller-default :: log-attribute
~~~

#### Control Defaults

This specifies a default log attribute for controls.

~~~
control-defaults :: "control" : { control-default-list }
control-default-list :: control-default ( , control-default-list )
control-default :: log-attribute
~~~

#### Axis Defaults

This specifies some default values for axis subtype controls.

~~~
axis-defaults :: "axis" : { axis-default-list }
axis-default-list :: axis-default ( , axis-default-list )
axis-default :: axis-scale-default | axis-invert-default | axis-unit-default | axis-initial-default | axis-trigger-default

axis-scale-default :: lua-number
axis-invert-default :: lua-boolean

axis-unit-default :: unit-string
axis-initial-default :: lua-value

axis-trigger-default :: trigger-keyword
~~~

#### Button Defaults

This specifies some default values for button subtype controls.

~~~
button-defaults :: "button" : { button-default-list }
button-default-list :: button-default ( , button-default-list )
button-default :: button-invert-default | button-unit-default | button-initial-default | button-trigger-default

button-invert-default :: lua-boolean

button-unit-default :: unit-string
button-initial-default :: lua-value

button-trigger-default :: trigger-keyword
~~~

#### Timed Defaults

This specifies some default timer values for timed subtype controls.

~~~
timed-defaults :: "timed" : { timer-default-list }
timed-default-list :: timed-default ( , timer-default-list )
timed-default :: timed-delay-default | timed-period-default | timed-trigger-default

timed-delay-default :: lua-number
timed-period-default :: lua-number

timed-trigger-default :: trigger-keyword
~~~

#### Modal Defaults

This specifies some default timer values for modal subtype controls.

~~~
modal-defaults :: "modal" : { modal-default-list }
modal-default-list :: modal-default ( , modal-default-list )
modal-default :: modal-delay-default | modal-trigger-default

modal-delay-default :: lua-number

modal-trigger-default :: trigger-keyword
~~~

#### Switched Defaults

This specifies some default values for switched subtype controls.

~~~
switched-defaults :: "switched" : { switched-default-list }
switched-default-list :: switched-default ( , switched-default-list )
switched-default :: switched-trigger-default

switched-trigger-default :: trigger-keyword
~~~

### Attributes

GCI allows to add two attributes to each controller and each control specification. The attributes are mainly for testing and troubleshooting a specification. The `log` attribute controls logging to the Air Manager log file. The `ignore` attribute is meant to temporarily ignore a controller or control specification.

~~~
attributes :: attribute-field ( , attributes )
attribute-field :: ignore-attribute | log-attribute

ignore-attribute :: "ignore" : ignore-value
ignore-value :: condition

log-attribute :: "log" : log-value
log-value :: condition

condition :: false-condition | true-condition
false-condition :: false | null
true-condition :: <any value different from false-condition> 
~~~

## Additional Rules

The same field must not occur more than once in the same object. Any previously field value will be overwritten with the new field value if double fields occur. As the order of loading the JSON file is not determined, the resulting configuration object may be inconsistent.

## File Requirements

The configuration file must have the name `gci.json'.

GCI uses the Air Manager API function `static_data_load` to load the configuration file.

Air Manager must be able to find the configuration file in the `resources` folder of the panel or the instrument that calls the GCI API function `integrate_controllers`.
