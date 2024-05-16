extends Sprite2D

const _libcontroller = preload('res://lib/controller.gd')

@export var input: _libcontroller.ControllerInputType


var _SPRITE_LOOKUP = {
	_libcontroller.ControllerInputType.UP: {
		_libcontroller.ControllerInputAction.PRESSED: Rect2(Vector2(0, 16), Vector2(16, 16)),
		_libcontroller.ControllerInputAction.RELEASED: Rect2(Vector2(0, 0), Vector2(16, 16)),
	},
	_libcontroller.ControllerInputType.DOWN: {
		_libcontroller.ControllerInputAction.PRESSED: Rect2(Vector2(16, 16), Vector2(16, 16)),
		_libcontroller.ControllerInputAction.RELEASED: Rect2(Vector2(16, 0), Vector2(16, 16)),
	},
	_libcontroller.ControllerInputType.LEFT: {
		_libcontroller.ControllerInputAction.PRESSED: Rect2(Vector2(32, 16), Vector2(16, 16)),
		_libcontroller.ControllerInputAction.RELEASED: Rect2(Vector2(32, 0), Vector2(16, 16)),
	},
	_libcontroller.ControllerInputType.RIGHT: {
		_libcontroller.ControllerInputAction.PRESSED: Rect2(Vector2(48, 16), Vector2(16, 16)),
		_libcontroller.ControllerInputAction.RELEASED: Rect2(Vector2(48, 0), Vector2(16, 16)),
	},
	_libcontroller.ControllerInputType.SPACE: {
		_libcontroller.ControllerInputAction.PRESSED: Rect2(Vector2(64, 16), Vector2(32, 16)),
		_libcontroller.ControllerInputAction.RELEASED: Rect2(Vector2(64, 0), Vector2(32, 16)),
	},
}


func _debug_input_detected_handler(
	a: _libcontroller.ControllerInputAction,
	i: _libcontroller.ControllerInputType,
):
	if i != input:
		return
	
	set_region_rect(_SPRITE_LOOKUP[i][a])

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.debug_input_detected.connect(_debug_input_detected_handler)
