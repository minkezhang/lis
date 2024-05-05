extends Object

enum C {
	NONE,
	MAX,
}


class Line:
	var _c: C
	var _ls: Array
	
	func _init(char: C, lines: Array):
		_c = char
		_ls = lines.duplicate()
	
	func c() -> C:
		return _c
	
	func ls() -> Array:
		return _ls
