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
const _libcontroller = preload('res://lib/controller.gd')
const _libevent = preload('res://lib/event.gd')
const _libdialog = preload('res://lib/dialog.gd')


# signal_handlers_ready is sent by the root node (i.e. level) at the end of the
# _ready function which indicates all nodes in the tree are ready to recieve
# signals.
signal signal_handlers_installed()


signal target_reached(c: Character, target: Vector2i)
signal target_requested(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2i,
	target: Vector2i,
)

signal eof_reached(l: String)

signal event_triggered(e: String)

# Controller signals
signal enable_controller_mode_requested(mode: _libcontroller.ControllerMode)
signal disable_controller_mode_requested(mode: _libcontroller.ControllerMode)
signal move_requested(direction: _libgeo.Orientation)
signal advance_dialog_requested()

