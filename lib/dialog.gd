extends Object

enum C {
	NONE,
	MAX,
	JEFFERSON,
}


class LineReader:
	var _ls: Array
	var _index: int
	
	func _split_lines(ls: Array, n: int) -> Array:
		if not n:
			return ls.duplicate()
		
		var res = []
		var r = RegEx.new()
		r.compile("[^\\s]+")
		
		for l in ls:
			var ws = r.search_all(l)
			var curr = ""
			for i in range(ws.size()):
				var w = ws[i].get_string()
				if (curr.length() + w.length() + (1 if i < ws.size() - 1 else 0)) <= n:
					curr += " " + w
				else:
					res.append(curr)
					curr = w
			if curr != "":
				res.append(curr)
		
		return res
	
	func _init(line: Line, n: int = 0):
		_index = 0
		_ls = _split_lines(line._ls, n)
	
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
