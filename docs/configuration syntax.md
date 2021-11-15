# Configuration Syntax
This specifies the syntax for the GCI configuration file

## EBNF Form

~~~
gci-configuration :: "{" configuration "}"
configuration :: controllers-field ( "," defaults-field ) 

controllers-field :: "controllers" ":" "[" controller-list "]"
controller-list :: controller-spec ( "," controller-list )
controller-spec :: "{" controller-name-field, controls ( "," attributes ) "}"

controller-name-field :: "name" ":" controller-name
controller-name :: string

controls :: controls-field ( "," controls )
controls-field :: axes-field | buttons-field
axes-field :: "axes" ":" "[" axis-list "]"
buttons-field :: "buttons" ":" "[" button-list "]"

axis-list :: axis-spec ( "," axis-list )
axis-spec :: "{" id-field, controls ( "," attributes ) "}"


button-list :: button-spec ( "," button-list )

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
false-condition :: false, null
true-condition :: <any value different from false-condition> 

~~~

### Defaults

~~~
defaults-field :: "defaults" ":" "{" defaults-spec "}"

defaults-spec :: 

log-defaults :: log-attribute

~~~

## Additional Rules



## JSON-Syntax


## File Requirements

