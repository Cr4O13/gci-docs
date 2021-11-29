# Game Controller Integration for Air Manager

[Air Manager](https://www.siminnovations.com) is an application which allows to create your own 2D instrument panels for a variety of flight simulators.

GCI is a plugin that integrates game controllers into Air Manager.

## Versions

There are 2 packages available:
- a LITE version, available as a download from this [GiHub Releases Page](https://github.com/Cr4O13/gci-docs/releases) (free)
- a HOME version, available as a download. The distribution channel will be defined soon.

## Requirements

Air Manager or Air Player 4.1

Simulators: MSFS2020, X-Plane 11, P3D or FSX

Game Controllers: USB HID conformant controllers

Platforms: Windows 10/11 and Linux

## Features Lite Version

Generic integration code.

Easy all-in-one configuration, separate from code.

Code and configuration included in export/import as well as push able to Air Player.

Support for basic control types 'axis' and 'button'

Aircraft specific configurations for
-	multiple game controllers
- up to 8 axis and 32 buttons
-	configurable axes with different output options

Configurable actions for
- writing to simulator variables/datarefs
- sending commands/events to simulator

## Additional Features in the Home Version

Additional output options for axes 
- nonlinear response curves (e.g. hyperbolic, cubic)
- input dead zones

Additional action options
- 'publish' to SI bus for subscription and handling in instrument scripts (IIC).

Additional control subtypes 
- 'switched' axis 
- 'timed' action buttons
- 'modal' buttons

Additional notation styles in the (JSON) configuration file
- Array style notation (instead of object style)
- Simplified notation on specific cases

Planned features
- Support for custom control types

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
