extends NullControllerScene


@export var debug: bool = false


func is_enabled() -> bool:
	return _is_enabled


func set_is_enabled(e: bool):
	_is_enabled = e


func _ready():
	_is_enabled = true
	_controller = _libcontroller.DebugControllerConfig.new()


func _input(event):
	if not is_enabled():
		return
	
	if event.is_action_pressed('ui_up'):
		_controller.n_handler(_libcontroller.ControllerInputAction.PRESSED)
	if event.is_action_pressed('ui_down'):
		_controller.s_handler(_libcontroller.ControllerInputAction.PRESSED)
	if event.is_action_pressed('ui_left'):
		_controller.w_handler(_libcontroller.ControllerInputAction.PRESSED)
	if event.is_action_pressed('ui_right'):
		_controller.e_handler(_libcontroller.ControllerInputAction.PRESSED)
	if event.is_action_pressed('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.PRESSED)
	if event.is_action_released('ui_up'):
		_controller.n_handler(_libcontroller.ControllerInputAction.RELEASED)
	if event.is_action_released('ui_down'):
		_controller.s_handler(_libcontroller.ControllerInputAction.RELEASED)
	if event.is_action_released('ui_left'):
		_controller.w_handler(_libcontroller.ControllerInputAction.RELEASED)
	if event.is_action_released('ui_right'):
		_controller.e_handler(_libcontroller.ControllerInputAction.RELEASED)
	if event.is_action_released('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.RELEASED)
