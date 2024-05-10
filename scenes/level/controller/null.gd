extends Node
class_name NullControllerScene

const _libcontroller = preload('res://lib/controller.gd')

var _is_enabled: bool
var _controller: _libcontroller.NullControllerConfig = _libcontroller.NullControllerConfig.new()


func is_enabled() -> bool:
	return _is_enabled


func set_is_enabled(e: bool):
	_is_enabled = e


func _ready():
	_is_enabled = false
