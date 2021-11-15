# Configuration Syntax
This specifies the syntax for the GCI configuration file

## JSON-Syntax
The configuration file uses the JSON syntax. 

## EBNF Form

### GCI Configuration

~~~
gci-configuration :: "{" configuration "}"
configuration :: controllers-field ( "," defaults-field ) 
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
axis-spec :: "{" id-field, controls ( "," attributes ) "}"


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

