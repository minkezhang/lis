extends Node

const _libgeo = preload('res://lib/geo.gd')

signal input_move(direction: _libgeo.Orientation)

const _POLL_RATE_HZ: float = 8
const _POLL_RATE_DELTA: float = 1.0 / _POLL_RATE_HZ

var _delta_accum: float = 0


func _process(delta):
	if _delta_accum + delta < _POLL_RATE_DELTA:
		_delta_accum += delta
		return
	
	_delta_accum = max(_delta_accum, 1)
	
	if Input.is_action_pressed('ui_right'):
		input_move.emit(_libgeo.Orientation.E)
		_delta_accum = 0
	if Input.is_action_pressed('ui_left'):
		input_move.emit(_libgeo.Orientation.W)
		_delta_accum = 0
	if Input.is_action_pressed('ui_up'):
		input_move.emit(_libgeo.Orientation.N)
		_delta_accum = 0
	if Input.is_action_pressed('ui_down'):
		input_move.emit(_libgeo.Orientation.S)
		_delta_accum = 0
