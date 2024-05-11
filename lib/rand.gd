extends Object

static var _CHARS: String = 'abcdefghijklmnopqrstuvwxyz'

static func randstring(n: int) -> String:
	var s = []
	s.resize(n)
	for i in s.size():
		s[i] = _CHARS[randi() % _CHARS.length()]
	return ''.join(s)
