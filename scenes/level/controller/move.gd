extends NullControllerScene

const _libgeo = preload('res://lib/geo.gd')


const _POLL_RATE_HZ: float = 8
const _POLL_RATE_DELTA: float = 1.0 / _POLL_RATE_HZ

var _delta_accum: float = 0


func _ready():
	super()
	_controller = _libcontroller.MoveControllerConfig.new()


func _process(delta):
	if not is_enabled():
		return
	
	if _delta_accum + delta < _POLL_RATE_DELTA:
		_delta_accum += delta
		return
	
	_delta_accum = max(_delta_accum, 1)
	
	if Input.is_action_pressed('ui_right'):
		_controller.e_handler(_libcontroller.ControllerInputAction.PRESSED)
		_delta_accum = 0
	if Input.is_action_pressed('ui_left'):
		_controller.w_handler(_libcontroller.ControllerInputAction.PRESSED)
		_delta_accum = 0
	if Input.is_action_pressed('ui_up'):
		_controller.n_handler(_libcontroller.ControllerInputAction.PRESSED)
		_delta_accum = 0
	if Input.is_action_pressed('ui_down'):
		_controller.s_handler(_libcontroller.ControllerInputAction.PRESSED)
		_delta_accum = 0
