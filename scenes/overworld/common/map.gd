extends Node2D

const _libgeo = preload('res://lib/geo.gd')


func grid(n: Node2D) -> Vector2i:
	return Vector2i(to_local(n.global_position)) / _libgeo.GRID_DIMENSION

func _ready():
	print("DEBUG(map.gd): ", grid($Characters/Max))
