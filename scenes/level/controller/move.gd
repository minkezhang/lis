extends NullControllerScene

const _libgeo = preload('res://lib/geo.gd')


const _POLL_RATE_HZ: float = 8
const _POLL_RATE_DELTA: float = 1.0 / _POLL_RATE_HZ

var _input_stack: Array = []


func _ready():
	super()
	_controller = _libcontroller.MoveControllerConfig.new()
	
	var t := Timer.new()
	t.timeout.connect(_timeout_handler)
	t.autostart = true
	t.wait_time = _POLL_RATE_DELTA
	add_child(t)


func _timeout_handler():
	if not is_enabled():
		return
	
	if len(_input_stack) > 0:
		_input_stack[0].call(_libcontroller.ControllerInputAction.PRESSED)


func _unhandled_input(event):
	if not is_enabled():
		return
	
	get_viewport().set_input_as_handled()
	
	if event.is_action_pressed('ui_accept'):
		_controller.accept_handler(_libcontroller.ControllerInputAction.PRESSED)
	
	if event.is_action_pressed('ui_right'):
		_input_stack.push_front(_controller.e_handler)
	if event.is_action_pressed('ui_left'):
		_input_stack.push_front(_controller.w_handler)
	if event.is_action_pressed('ui_up'):
		_input_stack.push_front(_controller.n_handler)
	if event.is_action_pressed('ui_down'):
		_input_stack.push_front(_controller.s_handler)
	
	if event.is_action_released('ui_right'):
		_input_stack.remove_at(_input_stack.find(_controller.e_handler))
	if event.is_action_released('ui_left'):
		_input_stack.remove_at(_input_stack.find(_controller.w_handler))
	if event.is_action_released('ui_up'):
		_input_stack.remove_at(_input_stack.find(_controller.n_handler))
	if event.is_action_released('ui_down'):
		_input_stack.remove_at(_input_stack.find(_controller.s_handler))
