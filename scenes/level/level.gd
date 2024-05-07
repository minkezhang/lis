extends Node2D

const _liblines = preload('res://lib/lines.gd')
const _libgeo = preload('res://lib/geo.gd')


func _ready():
	# GBA resolution is 260 x 160, which is a 15 x 10 grid of tiles.
	DisplayServer.window_set_size(Vector2i(
		15 * _libgeo.GRID_DIMENSION * $Camera.zoom.x,
		10 * _libgeo.GRID_DIMENSION * $Camera.zoom.y,
	))
	
# 	TODO(minkezhang): Remove test lines.
	$Dialog.set_dialog(_liblines.L['0'])
	$Map/Characters/Max/Dialog/Label.set_dialog(_liblines.L['1'])


func _process(_delta):
	$Camera.global_position = $Map/Characters/Max.global_position
	$Dialog.position = $Camera.position
