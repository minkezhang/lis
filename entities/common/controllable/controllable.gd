extends Node2D

signal action_north
signal action_south
signal action_east
signal action_west

const _POLL_RATE_HZ: float = 10
const _POLL_RATE_DELTA: float = 1.0 / _POLL_RATE_HZ

var _delta_accum: float = 0


func _process(delta):
	if _delta_accum + delta < _POLL_RATE_DELTA:
		_delta_accum += delta
		return
	
	_delta_accum = 0
	
	if Input.is_action_pressed('ui_right'):
		action_east.emit()
	if Input.is_action_pressed('ui_left'):
		action_west.emit()
	if Input.is_action_pressed('ui_up'):
		action_north.emit()
	if Input.is_action_pressed('ui_down'):
		action_south.emit()
