extends Object

const _libdialog = preload('res://lib/dialog.gd')

class Test:
	func get_next_line() -> Array:
		var cs = [
			{
				'name': 'Trivial',
				'l': _libdialog.Line.new(_libdialog.C.NONE, ['a sentence']),
				'n': 0,
				'i': 0,
				'want': 'a sentence',
			},
			{
				'name': 'Simple/N=0',
				'l': _libdialog.Line.new(_libdialog.C.NONE, ['a sentence']),
				'n': 0,
				'i': 0,
				'want': 'a sentence',
			},
			{
				'name': 'Simple/N=0/EOF',
				'l': _libdialog.Line.new(_libdialog.C.NONE, ['a sentence']),
				'n': 0,
				'i': 100,
				'want': '',
			},
			{
				'name': 'Simple/N=1/I=0',
				'l': _libdialog.Line.new(_libdialog.C.NONE, ['a sentence']),
				'n': 1,
				'i': 0,
				'want': 'a',
			},
			{
				'name': 'Simple/N=1/I=1',
				'l': _libdialog.Line.new(_libdialog.C.NONE, ['a sentence']),
				'n': 1,
				'i': 1,
				'want': 'sentence',
			},
		]
		var tests = []
		for config in cs:
			var r = _libdialog.LineReader.new(config['l'], config['n'])
			r.seek(config['i'])
			var got = r.get_next_line()
			
			tests.append({
				'name': config['name'],
				'got': got,
				'want': config['want'],
			})
		return tests
	
	func split_lines() -> Array:
		var cs = [
			{
				'name': 'Trivial',
				'ls': [],
				'n': 0,
				'want': [],
			},
			{
				'name': 'Simple/N=0',
				'ls': ['some short line'],
				'n': 0,
				'want': ['some short line'],
			},
			{
				'name': 'Simple/N=10',
				'ls': ['some short line'],
				'n': 10,
				'want': ['some short', 'line'],
			},
			{
				'name': 'Simple/N=1',
				'ls': ['some short line'],
				'n': 1,
				'want': ['some', 'short', 'line'],
			},
			{
				'name': 'SentenceBreaks',
				'ls': ['Some? Short. Line!'],
				'n': 1,
				'want': ['Some?', 'Short.', 'Line!'],
			},
			{
				'name': 'MultiLine',
				'ls': ['a sentence', 'a different sentence'],
				'n': 1,
				'want': ['a', 'sentence', 'a', 'different', 'sentence'],
			},
		]
		var tests = []
		for config in cs:
			tests.append({
				'name': config['name'],
				'got': _libdialog._split_lines(config['ls'], config['n']),
				'want': config['want'],
			})
		return tests
