extends Node2D

const _libgeo = preload('res://lib/geo.gd')


func grid(n: Node2D) -> Vector2i:
	return Vector2i(to_local(n.global_position)) / _libgeo.GRID_DIMENSION

func _ready():
	# TODO: Add collision detection here.
	SignalBus.request_move.connect(
		func(c: Character, o: _libgeo.Orientation): c.path_queue.enqueue(o)
	)
	
	print("DEBUG(map.gd): Current Max grid position ", grid($Characters/Max))
