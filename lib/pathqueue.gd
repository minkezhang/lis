extends Object

const _libgeo = preload('res://lib/geo.gd')


class PathQueue:
	var _capacity: int
	var _buf = []
	
	func _init(capacity: int):
		_capacity = capacity
		
	func enqueue(o: _libgeo.Orientation) -> _PathNode:
		if len(_buf) < _capacity:
			_buf.push_back(o)
			return _PathNode.new(o, true)
		return _PathNode.new(_libgeo.Orientation.S, false)
		
	func dequeue() -> _PathNode:
		if len(_buf) > 0:
			return _PathNode.new(_buf.pop_front(), true)
		return _PathNode.new(_libgeo.Orientation.S, false)


class _PathNode:
	var orientation: _libgeo.Orientation
	var success: bool
	func _init(o: _libgeo.Orientation, s: bool):
		orientation = o
		success = s
