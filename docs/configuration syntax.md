# Configuration Syntax
This specifies the syntax for the GCI configuration file

## JSON-Syntax

The specification file uses the JSON syntax. JSON is quite finnicky about missing or wrong delimiting characters like braces, brackets, commas, colons and quotation marks.

All identifiers need to be enclosed in matching quotation marks. 

Litersl string values need to be enclosed in matching quotation marks as well. 

All other literal values, like numbers, the boolean literals `true` an `false` or the `null` value, must not be enclosed in quotes. 

All fields of an object must be enclosed in matching curly braces `{ }`. Inside the objects, fields must be separated using commas `,`. A field name and its value must be separated with a colon `:`. 

All values of an array must be enclosed in matching curly brackets `[ ]`. Inside the array, values must be separated using commas `,`.


## EBNF Form
The following subsections describe the GCI syntax in the formal EBNF notation. This is given here for creating test cases and proper implementation only.

The EBNF notation defines the canonical form, which is the JSON object style. For some specification objects an array style form is available as well as a simplified form. This is described in the WIKI documentation where applicable.

### GCI Configuration

This is the top level entry of the formal notation

~~~
gci-configuration :: "{" configuration-spec "}"
configuration-spec :: controllers-field ( "," defaults-field ) 
~~~

### Controllers

~~~
controllers-field :: "controllers" ":" "[" controller-list "]"
controller-list :: controller-spec ( "," controller-list )
controller-spec :: "{" controller-name-field, controls ( "," attributes ) "}"

controller-name-field :: "name" ":" controller-name
controller-name :: string
~~~

The controller name must be identical to the name Air Manager returns in the API function `game_controller_list`. This name should be identical to the name displayed by the Windows 'Game Controller' control panel (joy.cpl).

### Controls

~~~
controls :: controls-field ( "," controls )
controls-field :: axes-field | buttons-field
axes-field :: "axes" ":" "[" axis-list "]"
buttons-field :: "buttons" ":" "[" button-list "]"

axis-list :: axis-spec ( "," axis-list )
axis-spec :: "{" axis-required-fields ( axis-optional-fields ) "}"
axis-required-fields :: axis-required-field ( "," axis-required-fields )
axis-required-field :: id-field | respond-field
axis-optional-fields :: axis-optional-field ( "," axis-optional-fields )
axis-optional-field :: subtype-field | action-field | attributes
button-list :: button-spec ( "," button-list )
~~~

### Defaults

~~~
defaults-field :: "defaults" ":" "{" defaults-spec "}"

defaults-spec :: 

log-defaults :: log-attribute
~~~

### Attributes

~~~
attributes :: attribute-field ( "," attributes )
attribute-field :: ignore-attribute | log-attribute

ignore-attribute :: "ignore" ":" ignore-value
ignore-value :: condition

log-attribute :: "log" ":" log-value
log-value :: condition

condition :: false-condition | true-condition
false-condition :: false | null
true-condition :: <any value different from false-condition> 
~~~

## Additional Rules



## File Requirements

