extends Object

class LookupMap:
	var _static = {}
	var _dynamic = {}
	
	func _init(s: Array):
		for t in s:
			_static[t] = true
	
	func query(v: Vector2i) -> bool:
		return _static.get(v, false) or _dynamic.get(v, false)
	
	func mark(vs: Array):
		for v in vs:
			_dynamic[v] = true
	
	func clear(vs: Array):
		for v in vs:
			_dynamic.erase(v)
