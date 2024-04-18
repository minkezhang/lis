extends Node2D

const _libgeotest = preload('res://lib/geo_test.gd')


var _TEST_SUITES = [{
	'name': 'geo.GeoPosition.to_grid',
	'test_suite': func(): return _libgeotest.Test.new().to_grid(),
}]

func _ready():
	for s in _TEST_SUITES:
		print('==== RUN\t{name}'.format({
			'name': s['name'],
		}))
		print('---- {result}'.format({
			'result': 'PASS' if s['test_suite'].call() else 'FAIL',
		}))
