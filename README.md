# Game Controller Integration for Air Manager

[Air Manager](https://www.siminnovations.com) is an application which allows to create your own 2D instrument panels for a variety of flight simulators.

GCI is a plugin that integrates game controllers into Air Manager.

## Requirements

Air Manager or Air Player 4.1

Simulators: MSFS2020, X-Plane 11, P3D or FSX
Game Controllers: USB HID conformant controllers
Platforms: Windows 10/11 and Linux

## Features

Generic integration code.
Easy all-in-one configuration, separate from code.
Code and configuration included in export/import as well as pushable to Air Player.
Aircraft specific configurations for
-	multiple game controllers
- up to 8 axis and 32 buttons
-	configurable axes with
  - response curves (e.g. linear, hyperbolic, cubic)
  - input dead zones 
  -	output scaling and limitation
Configurable actions for
- writing to sim variables/datarefs, or
- sending commands/events, or
- publishing to SI bus for subscription and handling in instrument scripts (IIC).
Support for control subtypes 
- switched axis 
- repeated action buttons
- modal buttons
Support for custom input handlers

## Dependencies

GCI interfaces with Air Manager through its published API.

GCI uses the following API functions:
- static_data_load
- game_controller_add
- si_variable_write
- fs2020_variable_write
- fs2020_event
- fsx_variable_write
- fsx_event
- xpl_dataref_write
- xpl_command
- interpolate_linear
- log
