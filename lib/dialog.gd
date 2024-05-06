extends Object

enum C {
	NONE,
	MAX,
	JEFFERSON,
}


class Line:
	var _c: C
	var _ls: Array
	var _index: int
	
	func _init(c: C, lines: Array):
		_c = c
		_ls = lines.duplicate()
		_index = 0
	
	func character() -> C:
		return _c
	
	func seek(i: int):
		_index = i
	
	func eof():
		return _index >= len(_ls)
	
	func get_next_line() -> String:
		if eof():
			return ''
		
		var s = _ls[_index]
		_index += 1
		
		return s
