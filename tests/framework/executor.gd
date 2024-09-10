extends Node2D

const _libframework = preload('res://tests/framework/framework.gd')

const _libgeotest = preload('res://tests/geo_test.gd')
const _libdialogtest = preload('res://tests/dialog_test.gd')
const _libframeworktest = preload('res://tests/framework_test.gd')
const _libeventtest = preload('res://tests/event_test.gd')

@export var debug: bool = false


var _DEBUG_TESTS = [
		_libframeworktest.TestScene.new(),
]


func _ready():
	var tests = [
		_libdialogtest.SplitSingleLine.new(),
		_libgeotest.ToGrid.new(),
		_libgeotest.ToWorld.new(),
		_libeventtest.Simple.new(),
		_libeventtest.EventTimer.new(),
		_libeventtest.Chain.new(),
		_libeventtest.Serialized.new(),
	]
	
	var s = _libframework.S.new()
	add_child(s)
	await s.run(
		(
			_DEBUG_TESTS if debug else []
		) + tests
	)
	
	# Allow test suite to finish reporting.
	await get_tree().create_timer(2.0).timeout
	
	get_tree().quit()
