extends Object

const _libgeo = preload('res://lib/geo.gd')
const _libtest = preload('res://lib/test/test.gd')


class ToGrid extends _libtest.T:
	func _init():
		super('geo_test/to_grid', [
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
		],
	)
	func got(c: Dictionary) -> Variant:
		return _libgeo.GeoPosition.new(c['c'], c['d']).to_grid(c['w'])

class ToWorld extends _libtest.T:
	func _init():
		super('geo_test/to_world', [
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
		],
	)
	
	func got(c: Dictionary) -> Variant:
		return _libgeo.GeoPosition.new(c['c'], c['d']).to_world(c['g'])
