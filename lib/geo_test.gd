extends Object

const _libgeo = preload('res://lib/geo.gd')

class Test:
	func to_grid() -> bool:
		var ts = [
			{
				'name': 'TestTrivial',
				'c': Vector2i(0, 0),
				'd': 16,
				'w': Vector2(0, 0),
				'want': Vector2i(0, 1)},
		]
		var success = true
		for t in ts:
			var got = _libgeo.GeoPosition.new(t['c'], t['d']).to_grid(t['w'])
			var _s = t['want'] == got
			if not _s:
				print('     {name}: to_grid() = {got}, want = {want}'.format({
					'name': t['name'],
					'got': got,
					'want': t['want'],
				}))
			success = success and _s
		return success
