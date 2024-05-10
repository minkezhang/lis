extends Node

const _libcontroller = preload('res://lib/controller.gd')
const _libgeo = preload('res://lib/geo.gd')


var _SCENES_LOOKUP: Dictionary


func _controller_mode_change_requested_handler(
	mode: _libcontroller.ControllerMode
):
	for k in _SCENES_LOOKUP:
		print(k)
		_SCENES_LOOKUP[k].set_is_enabled(mode == k)


func _ready():
	_SCENES_LOOKUP = {
		_libcontroller.ControllerMode.NULL: $Null,
		_libcontroller.ControllerMode.MOVE: $Move,
		_libcontroller.ControllerMode.DIALOG: $Dialog,
	}
	
	SignalBus.controller_mode_change_requested.connect(
		_controller_mode_change_requested_handler
	)
	
	SignalBus.controller_mode_change_requested.emit(
		_libcontroller.ControllerMode.MOVE,
	)
