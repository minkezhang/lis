extends NullControllerScene


@export var debug: bool = false


func is_enabled() -> bool:
	return _is_enabled


func set_is_enabled(e: bool):
	_is_enabled = e


func _ready():
	_is_enabled = true
	_controller = _libcontroller.DebugControllerConfig.new()

func _process(_delta):
	if not _is_enabled:
		return
	
	if Input.is_action_just_pressed('ui_up'):
		_controller.n_handler(_libcontroller.ControllerInputAction.PRESSED)
	if Input.is_action_just_pressed('ui_down'):
		_controller.s_handler(_libcontroller.ControllerInputAction.PRESSED)
	if Input.is_action_just_pressed('ui_left'):
		_controller.w_handler(_libcontroller.ControllerInputAction.PRESSED)
	if Input.is_action_just_pressed('ui_right'):
		_controller.e_handler(_libcontroller.ControllerInputAction.PRESSED)
	if Input.is_action_just_pressed('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.PRESSED)
	if Input.is_action_just_released('ui_up'):
		_controller.n_handler(_libcontroller.ControllerInputAction.RELEASED)
	if Input.is_action_just_released('ui_down'):
		_controller.s_handler(_libcontroller.ControllerInputAction.RELEASED)
	if Input.is_action_just_released('ui_left'):
		_controller.w_handler(_libcontroller.ControllerInputAction.RELEASED)
	if Input.is_action_just_released('ui_right'):
		_controller.e_handler(_libcontroller.ControllerInputAction.RELEASED)
	if Input.is_action_just_released('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.RELEASED)
