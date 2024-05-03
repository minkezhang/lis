extends Node
## Define singletone signals (i.e. SignalBus).
## 
## This script will be AutoLoaded at startup.
##
## Example:
##
## # max.gd
## SignalBus.move_requested.emit(self, ...)

const _libgeo = preload('res://lib/geo.gd')

# move_requested is shared by all Character instances, and therefore justifies
# Singleton status. This is passed to the scene responsible for pathfinding
# which can then direct Character movement after checking for obstacles.
signal move_requested(c: Character, o: _libgeo.Orientation)

signal move_started(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2,
	target: Vector2,
)

signal move_ended(c: Character)
