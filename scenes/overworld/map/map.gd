extends Node2D

const _libgeo = preload('res://lib/geo.gd')

 
func grid(n: Character) -> Vector2i:
	return Vector2i(to_local(n.animation_sprite.global_position)) / _libgeo.GRID_DIMENSION


func _move_pushed_handler(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2,
	target: Vector2,
):
	c.animate_move(o, not $Obstacles.query(target))


func _ready():
	SignalBus.move_requested.connect(func(c: Character, o: _libgeo.Orientation): c.path_queue.enqueue(o))
	SignalBus.move_started.connect(_move_pushed_handler)
	SignalBus.move_ended.connect(func(c: Character): null)
