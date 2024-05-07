extends Node2D

const _libgeotest = preload('res://lib/geo_test.gd')
const _libdialogtest = preload('res://lib/dialog_test.gd')


var _TEST_SUITES = [
	{
		'name': 'geo.GeoPosition.to_grid',
		'test_suite': func(): return _libgeotest.Test.new().to_grid(),
	},
	{
		'name': 'geo.GeoPosition.to_world',
		'test_suite': func(): return _libgeotest.Test.new().to_world(),
	},
	{
		'name': 'dialog.LineReader._split_single_line',
		'test_suite': func(): return _libdialogtest.Test.new().split_single_line(),
	},
]

func _ready():
	for s in _TEST_SUITES:
		print('==== RUN\t{name}'.format({
			'name': s['name'],
		}))
		var success = true
		var time_start = Time.get_ticks_msec()
		for t in s['test_suite'].call():
			var _s = t['got'] == t['want']
			if not _s:
				print('     {name}: got = {got}, want = {want}'.format({
					'name': t['name'],
					'got': t['got'],
					'want': t['want'],
				}))
			success = success and _s
		var time_delta = Time.get_ticks_msec() - time_start
		print('---- {result}\t{name} ({delta}s)'.format({
			'result': 'PASS' if success else 'FAIL',
			'name': s['name'],
			'delta': '%0.2f' % (time_delta / 1e3),
		}))
