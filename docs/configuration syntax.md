# Configuration Syntax
This specifies the syntax for the GCI configuration file

## JSON-Syntax

The specification file uses the JSON syntax. JSON is quite finnicky about missing or wrong delimiting characters like braces, brackets, commas, colons and quotation marks.

All identifiers need to be enclosed in matching quotation marks `" "`. 

Literal string values need to be enclosed in matching quotation marks as well. 

All other literal values, like numbers, the boolean literals `true` and `false` or the `null` value, must not be enclosed in quotes. 

All fields of an object must be enclosed in matching curly braces `{ }`. Inside the objects, fields must be separated using commas `,`. A field name and its value must be separated with a colon `:`. 

All values of an array must be enclosed in matching brackets `[ ]`. Inside the array, values must be separated using commas `,`.

## EBNF Form
The following subsections describe the GCI syntax in the formal EBNF notation. This is given here for creating test cases and proper implementation only.

The EBNF notation defines the canonical form, which is the JSON object style. For some specification objects an array style form is available as well as a simplified form. This is described in the WIKI documentation where applicable.

In deviation from standard EBNF rules, all curly braces `{ }`, brackets `[ ]`, colons `:`, quotation marks `" "` and commas `,` used in the EBNF notation below are meant to be entered literally. 

The double colon `::` an the parentheses `( )` retain their meaning in EBNF. They are not meant to be entered literrally.

### GCI Configuration

This is the top level entry of the formal notation

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

The controller name must be identical to the name Air Manager returns in the API function `game_controller_list`. This name should be identical to the name displayed by the Windows 'Game Controller' control panel (joy.cpl).

### Controls

~~~
controls :: controls-field ( , controls )
controls-field :: axes-field | buttons-field
~~~

#### Axes

~~~
axes-field :: "axes" : [ axis-list ]
axis-list :: axis-spec ( , axis-list )

axis-spec :: { axis-required-fields ( axis-optional-fields ) }

axis-required-fields :: axis-required-field ( , axis-required-fields )
axis-required-field :: id-field | respond-field

axis-optional-fields :: axis-optional-field ( , axis-optional-fields )
axis-optional-field :: subtype-field | action-field | attributes
~~~

#### Buttons

~~~
buttons-field :: "buttons" : [ button-list ]
button-list :: button-spec ( , button-list )

button-spec :: { button-required-fields ( button-optional-fields ) }

button-required-fields :: button-required-field ( , button-required-fields )
button-required-field :: id-field | respond-field

button-optional-fields :: axis-optional-field ( , axis-optional-fields )
button-optional-field :: subtype-field | action-field | attributes
~~~

#### Common Fields

~~~
id-field :: "id" : { "index" : index-value ( , "label" : label-value ) }
index-value :: lua-number
label-value :: lua-string

subtype-field :: "subtype" : { "name" : subtype-keyword ( , "parameters" : { parameter-list } ) }
subtype-keyword :: axis-subtype-keyword | button-subtype-keyword

parameter-list :: parameter-value ( , parameter-list )
parameter-value :: lua-value

action-field :: "action" : action-keyword
action-keyword :: "write" | "send" | "publish"

respond-field :: "respond" : { responder-list }
responder-list :: responder-spec ( , responders-list )

responder-spec :: subtype-trigger-keyword : { responder-field-list } 

subtype-trigger-keyword :: 
  axis-trigger-keyword | button-trigger-keyword | 
  switched-trigger-keyword | timed_trigger-keyword | modal_trigger-keyword
~~~

#### Axis Fields

~~~
axis-subtype-keyword :: "axis" | "switched"

axis-trigger-keyword :: "on_change"
switched-trigger-keyword :: "on_plus" | "on_zero" | "on_minus"
~~~

#### Button Fields

~~~
button-subtype-keyword :: "button" | "timed" | "modal"

button_trigger-keyword :: "on_true" | "on_false"
timed_trigger-keyword  :: "on_time" | "on_stop"
modal_trigger-keyword  :: "on_mode1" | "on_mode2"
~~~

### Responder Fields

~~~
responder-field-list :: responder-field (, responder-field-list )
responder-field :: var-id-field | unit-id-field | offset-field | force-field | output-field

var-id-field :: var-id-keyword : var-identifier
var-id-keyword :: "var_id" | "variable" | "dataref"
var-identifier :: lua-string

unit-id-field :: unit-id-keyword : unit-identifier
unit-id-keyword :: "unit_id" | "unit" | "type"
unit-identifier :: lua-string

offset-field :: "offset" : offset-value
offset-value :: lua-integer

force-field :: "force" : force-value
force-value :: lua-boolean

output-field :: output-spec
~~~

### Output Specification

~~~
output-spec :: axis-output-spec | other-output-spec

axis-output-spec :: { axis-output-field-list }
axis-output-field-list :: axis-output-field ( , axis-output-field-list )
axis-output-field :: invert-field | scale-field | response-field

other-output-spec :: { other-output-field }
other-output-field :: invert-field | value-field

invert-field :: "invert" : invert-value 
invert-value :: lua-boolean

scale-field :: "scale" : scale-value 
scale-value :: lua-number

value-field :: "value" : lua-value

response-field :: "response" : response-settings 
response-settings :: [ fix-point, fix-point-list ]

fix-point-list :: fix-point ( , fix-point-list )
fix-point :: [ input-value, output-value ]

input-value :: input-range-number
input-range-number :: -1.0 =< lua-number =< +1.0

output-value :: lua-number
~~~

### Defaults

~~~
defaults-field :: "defaults" : { defaults-list }
defaults-list :: defaults-field ( , defaults-list )

defaults-field :: controller-defaults | control-defaults
  axis-defaults | button-defaults | timer-defaults | modal-defaults

controller-defaults :: "controller" : { controller-default-list }
controller-default-list :: controller-default ( , controller-default-list )
controller-default :: log-attribute

control-defaults :: "control" : { control-default-list }
control-default-list :: control-default ( , control-default-list )
control-default :: log-attribute

axis-defaults :: "axis" : { axis-default-list }
axis-default-list :: axis-default ( , axis-default-list )
axis-default :: axis-scale-default | axis-invert-default | axis-unit-default | axis-initial-default
axis-scale-default :: lua-number
axis-invert-default :: lua-boolean
axis-unit-default :: unit-string
axis-initial-default :: lua-value

button-defaults :: "button" : { button-default-list }
button-default-list :: button-default ( , button-default-list )
button-default :: button-invert-default | button-unit-default | axis-initial-default
button-invert-default :: lua-boolean
button-unit-default :: unit-string
button-initial-default :: lua-value

timer-defaults :: "timer" : { timer-default-list }
timer-default-list :: timer-default ( , timer-default-list )
timer-default :: timer-delay-default | timer-period-default
timer-delay-default :: lua-number
timer-period-default :: lua-number

modal-defaults :: "modal" : { modal-default-list }
modal-default-list :: modal-default ( , modal-default-list )
modal-default :: modal-delay-default
modal-delay-default :: lua-number
~~~

### Attributes

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

The same field must not occure more than once in the same object. Any previously field value will be overrwritten with the new field value if double fields occure. As the order of loading the JSON file is not determined, the resulting configuration object may be inconsistent.

## File Requirements

The configuration file must have the name `gci.json'.

GCI uses the Air Manager API function `static_data_load` to load the configuration file.

Air Manager must be able to find the configuration file in the `resources` folder of the panel or the instrument that calls the GCI API function `integrate_controllers`.
