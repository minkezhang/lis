extends Object

const _libgeo = preload('res://lib/geo.gd')

class Test:
	func to_grid() -> Array:
		var ts = [
			{
				'name': 'TestTrivial',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(0, 0),
				'want': Vector2i(0, 0),
			},
			{
				'name': 'TestTrivial/Offset',
				'c': Vector2i(8, 8),
				'd': 16,
				'w': Vector2(0, 0),
				'want': Vector2i(0, 0),
			},
			{
				'name': 'TestOffset/Border',
				'c': Vector2i(8, 8),
				'd': 16,
				'w': Vector2(7, 7),
				'want': Vector2i(0, 0),
			},
			{
				'name': 'TestOffset/Adjacent/X',
				'c': Vector2i(8, 8),
				'd': 16,
				'w': Vector2(8, 0),
				'want': Vector2i(1, 0),
			},
			{
				'name': 'TestOffset/Adjacent/Diagonal',
				'c': Vector2i(8, 8),
				'd': 16,
				'w': Vector2(8, 8),
				'want': Vector2i(1, 1),
			},
			{
				'name': 'TestInside',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(10, 10),
				'want': Vector2i(0, 0),
			},
			{
				'name': 'TestBorder',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(0, 16),
				'want': Vector2i(0, 1),
			},
			{
				'name': 'TestBorder/Diagonal',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(16, 16),
				'want': Vector2i(1, 1),
			},
		]
		var tests = []
		for t in ts:
			tests.append({
				'name': t['name'],
				'got': _libgeo.GeoPosition.new(t['c'], t['d']).to_grid(t['w']),
				'want': t['want'],
			})
		return tests
