# Game Controller Integration for Air Manager

[Air Manager](https://www.siminnovations.com) is an application which allows to create your own 2D instrument panels for a variety of flight simulators.

GCI is a plugin that integrates game controllers into Air Manager.


## Dependencies

GCI interfaces with Air Manager through its published API.

GCI uses the following API functions:
- game_controller_add
- si_variable_write
- fs2020_variable_write
- fs2020_event
- fsx_variable_write
- fsx_event
- xpl_dataref_write
- xpl_command
- log
