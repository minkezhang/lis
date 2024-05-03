extends Node
## Define singletone signals (i.e. SignalBus).
## 
## This script will be AutoLoaded at startup.
##
## Example:
##
## # character.gd
## SignalBus.move_started.emit(self, ...)

const _libgeo = preload('res://lib/geo.gd')


signal move_started(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2,
	target: Vector2,
)

signal move_ended(c: Character)
