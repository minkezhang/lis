extends Object

const _libgeo = preload('res://lib/geo.gd')

class Test:
	func to_grid() -> Array:
		var cs = [
			{
				'name': 'TestTrivial',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(0, 0),
				'want': Vector2i(0, 0),
			},
			{
				'name': 'TestTrivial/Negative',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(-8, 0),
				'want': Vector2i(-1, 0),
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
				'w': Vector2(15, 15),
				'want': Vector2i(0, 0),
			},
			{
				'name': 'TestOffset/Adjacent/X',
				'c': Vector2i(8, 8),
				'd': 16,
				'w': Vector2(16, 0),
				'want': Vector2i(1, 0),
			},
			{
				'name': 'TestOffset/Adjacent/Diagonal',
				'c': Vector2i(8, 8),
				'd': 16,
				'w': Vector2(16, 16),
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
		for config in cs:
			tests.append({
				'name': config['name'],
				'got': _libgeo.GeoPosition.new(config['c'], config['d']).to_grid(config['w']),
				'want': config['want'],
			})
		return tests
	func to_world() -> Array:
		var cs = [
			{
				'name': 'TestTrivial',
				'c': Vector2(0, 0),
				'd': 16,
				'g': Vector2i(0, 0),
				'want': Vector2(0, 0),
			},
			{
				'name': 'TestDiagonal',
				'c': Vector2(0, 0),
				'd': 16,
				'g': Vector2i(1, 1),
				'want': Vector2(16, 16),
			},
			{
				'name': 'TestOffset',
				'c': Vector2(8, 8),
				'd': 16,
				'g': Vector2i(0, 0),
				'want': Vector2(8, 8),
			},
		]
		var tests = []
		for config in cs:
			tests.append({
				'name': config['name'],
				'got': _libgeo.GeoPosition.new(config['c'], config['d']).to_world(config['g']),
				'want': config['want'],
			})
		return tests
