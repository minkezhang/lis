extends Node2D

const _libgeotest = preload('res://lib/geo_test.gd')
const _libdialogtest = preload('res://lib/dialog_test.gd')
const _libtest = preload('res://lib/test/test.gd')
const _libtestscene = preload('res://tests/test_scene.gd')

@export var debug: bool = false


var _DEBUG_TESTS = [
		_libtestscene.TestScene.new(),
]


func _ready():
	var tests = [
		_libdialogtest.SplitSingleLine.new(),
		_libgeotest.ToGrid.new(),
		_libgeotest.ToWorld.new(),
	]
	
	var s = _libtest.S.new()
	add_child(s)
	s.run(tests + (
		_DEBUG_TESTS if debug else []
	))
