extends NullControllerScene


func _unhandled_input(event):
	if not is_enabled():
		return
	
	get_viewport().set_input_as_handled()
	
	if event.is_action_pressed('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.PRESSED)


func _ready():
	super()
	_controller = _libcontroller.DialogControllerConfig.new()
