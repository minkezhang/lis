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
const _libevent = preload('res://lib/event/event.gd')
const _libdialog = preload('res://lib/dialog.gd')


# signal_handlers_ready is sent by the root node (i.e. level) at the end of the
# _ready function which indicates all nodes in the tree are ready to recieve
# signals.
@warning_ignore("unused_signal")
signal signal_handlers_installed()


@warning_ignore("unused_signal")
signal target_reached(c: Character, target: Vector2i)
@warning_ignore("unused_signal")
signal target_requested(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2i,
	target: Vector2i,
)

@warning_ignore("unused_signal")
signal interact_requested(c: Character, target: Vector2i)

@warning_ignore("unused_signal")
signal eof_reached(lid: String)

@warning_ignore("unused_signal")
signal event_triggered(eid: String)

# Controller signals
@warning_ignore("unused_signal")
signal enable_controller_mode_requested(mode: _libcontroller.ControllerMode)
@warning_ignore("unused_signal")
signal disable_controller_mode_requested(mode: _libcontroller.ControllerMode)
@warning_ignore("unused_signal")
signal input_move_requested(direction: _libgeo.Orientation)
@warning_ignore("unused_signal")
signal input_advance_dialog_requested()
@warning_ignore("unused_signal")
signal input_interact_requested()

@warning_ignore("unused_signal")
signal debug_input_detected(
	action: _libcontroller.ControllerInputAction,
	input: _libcontroller.ControllerInputType,
)
@warning_ignore("unused_signal")
signal debug_controller_mode_changed(mode: _libcontroller.ControllerMode)
