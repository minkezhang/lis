extends Node2D

const _libscript = preload('res://lib/script.gd')
const _libgeo = preload('res://lib/geo.gd')
const _libcontroller = preload('res://lib/controller.gd')


func _ready():
	# GBA resolution is 260 x 160, which is a 15 x 10 grid of tiles.
	DisplayServer.window_set_size(Vector2i(
		15 * _libgeo.GRID_DIMENSION * $Camera.zoom.x,
		10 * _libgeo.GRID_DIMENSION * $Camera.zoom.y,
	))
	
	# TODO(minkezhang): Set default controller config to MENU.
	SignalBus.enable_controller_mode_requested.emit(
		_libcontroller.ControllerMode.MOVE
	)
	
	
	# TODO(minkezhang): Remove test lines.
	$Dialog.set_dialog(_libscript.SCRIPT['DEBUG'])
	$Map/Characters/Chloe/Dialog.set_dialog(_libscript.SCRIPT['0'])



func _process(_delta):
	$Camera.global_position = $Map/Characters/Max.global_position
	$Dialog.position = $Camera.position
