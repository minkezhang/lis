extends Node2D

const _libgeotest = preload('res://tests/geo_test.gd')
const _libdialogtest = preload('res://tests/dialog_test.gd')
const _libframework = preload('res://tests/framework/framework.gd')
const _libframeworktest = preload('res://tests/framework_test.gd')

@export var debug: bool = false


var _DEBUG_TESTS = [
		_libframeworktest.TestScene.new(),
]


func _ready():
	var tests = [
		_libdialogtest.SplitSingleLine.new(),
		_libgeotest.ToGrid.new(),
		_libgeotest.ToWorld.new(),
	]
	
	var s = _libframework.S.new()
	add_child(s)
	await s.run((
	_DEBUG_TESTS if debug else []
	) + tests)
	
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
