extends Node2D

const _libgeo = preload('res://lib/geo.gd')


func _move_pushed_handler(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2,
	target: Vector2,
):
	c.animate_move(o, not $Obstacles.query(target))


func _ready():
	SignalBus.move_started.connect(_move_pushed_handler)
	SignalBus.move_ended.connect(func(c: Character): null)
