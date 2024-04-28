extends Node
## Define singletone signals (i.e. SignalBus).
## 
## This script will be AutoLoaded at startup.
##
## Example:
##
## # max.gd
## SignalBus.request_move.emit(self, ...)

const _libgeo = preload('res://lib/geo.gd')

# request_move is shared by all Character instances, and therefore justifies
# Singleton status. This is passed to the scene responsible for pathfinding
# which can then direct Character movement after checking for obstacles.
signal request_move(c: Character, o: _libgeo.Orientation)
