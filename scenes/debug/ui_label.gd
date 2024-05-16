extends Label

const _libcontroller = preload('res://lib/controller.gd')


func _debug_controller_mode_changed(mode: _libcontroller.ControllerMode):
	text = {
		_libcontroller.ControllerMode.NULL: 'null',
		_libcontroller.ControllerMode.DIALOG: 'dialog',
		_libcontroller.ControllerMode.MOVE: 'movement',
	}[mode]


func _ready():
	SignalBus.debug_controller_mode_changed.connect(_debug_controller_mode_changed)
