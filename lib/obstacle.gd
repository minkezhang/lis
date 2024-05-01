extends Object

class Obstacle:
	var _static = {}
	
	func _init(s: Dictionary):
		_static = s.duplicate()
	
	func query(v: Vector2i) -> bool:
		return _static.get(v, false)
