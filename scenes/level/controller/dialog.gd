extends NullControllerScene


func _input(event):
	if not is_enabled():
		return
	
	if event.is_action_pressed('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.PRESSED)


func _ready():
	super()
	_controller = _libcontroller.DialogControllerConfig.new()
