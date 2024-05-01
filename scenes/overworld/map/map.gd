extends Node2D

const _libgeo = preload('res://lib/geo.gd')


func _request_move_handler(c: Character, o: _libgeo.Orientation):
	print("request_move_handler from %s to %s" % [grid(c), grid(c) + Vector2i(_libgeo.ORIENTATION_RAY[o])])
	if not $World.query(grid(c) + Vector2i(_libgeo.ORIENTATION_RAY[o])):
		c.path_queue.enqueue(o)


func grid(n: Character) -> Vector2i:
	return Vector2i(to_local(n.animation_sprite.global_position)) / _libgeo.GRID_DIMENSION

func _ready():
	SignalBus.request_move.connect(_request_move_handler)
