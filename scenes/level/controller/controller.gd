extends Node

const _libcontroller = preload('res://lib/controller.gd')
const _libgeo = preload('res://lib/geo.gd')


var _SCENES_LOOKUP: Dictionary

var _prev_controller_mode: _libcontroller.ControllerMode = _libcontroller.ControllerMode.NULL
var _curr_controller_mode: _libcontroller.ControllerMode = _libcontroller.ControllerMode.NULL


func _toggle_controller_mode_requested_handler(
	mode: _libcontroller.ControllerMode,
	target_enabled_state: bool,
):
	# Do something only if a change was detected.
	if (
		target_enabled_state and mode == _curr_controller_mode
	) or (
		not target_enabled_state and mode != _curr_controller_mode
	):
		return
	
	if target_enabled_state:
		_prev_controller_mode = _curr_controller_mode
		_curr_controller_mode = mode
	else:
		_curr_controller_mode = _prev_controller_mode
		_prev_controller_mode = mode
	_SCENES_LOOKUP[_curr_controller_mode].set_is_enabled(true)
	_SCENES_LOOKUP[_prev_controller_mode].set_is_enabled(false)


func _ready():
	_SCENES_LOOKUP = {
		_libcontroller.ControllerMode.NULL: $Null,
		_libcontroller.ControllerMode.MOVE: $Move,
		_libcontroller.ControllerMode.DIALOG: $Dialog,
	}
	
	SignalBus.enable_controller_mode_requested.connect(
		func(m: _libcontroller.ControllerMode): _toggle_controller_mode_requested_handler(m, true),
	)
	SignalBus.disable_controller_mode_requested.connect(
		func(m: _libcontroller.ControllerMode): _toggle_controller_mode_requested_handler(m, false),
	)
