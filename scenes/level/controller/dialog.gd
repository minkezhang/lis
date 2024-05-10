extends NullControllerScene


func _process(_delta):
	if not is_enabled():
		return
	
	if Input.is_action_just_pressed('ui_accept'):
		_controller.accept_handler()


func _ready():
	super()
	_controller = _libcontroller.DialogControllerConfig.new()
