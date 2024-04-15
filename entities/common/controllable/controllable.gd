extends Node2D

signal input_north
signal input_south
signal input_east
signal input_west

const _POLL_RATE_HZ: float = 5
const _POLL_RATE_DELTA: float = 1.0 / _POLL_RATE_HZ

var _delta_accum: float = 0


func _process(delta):
	if _delta_accum + delta < _POLL_RATE_DELTA:
		_delta_accum += delta
		return
	
	_delta_accum = 0
	
	if Input.is_action_pressed('ui_right'):
		input_east.emit()
	if Input.is_action_pressed('ui_left'):
		input_west.emit()
	if Input.is_action_pressed('ui_up'):
		input_north.emit()
	if Input.is_action_pressed('ui_down'):
		input_south.emit()
