extends Node
## Define singletone signals (i.e. SignalBus).
## 
## This script will be AutoLoaded at startup.
##
## Example:
##
## # character.gd
## SignalBus.move_requested.emit(self, ...)

const _libgeo = preload('res://lib/geo.gd')


signal character_created(c: Character, position: Vector2i)
signal target_reached(c: Character, target: Vector2i)
signal target_requested(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2i,
	target: Vector2i,
)
