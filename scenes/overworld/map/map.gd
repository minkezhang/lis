extends Node2D

const _libgeo = preload('res://lib/geo.gd')


# _moves is a dict of { target: source } tuples
var _moves: Dictionary = {}

func _move_started_handler(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2i,
	target: Vector2i,
):
	var is_clear = not $Obstacles.obstacles.query(target)
	if is_clear:
		$Obstacles.obstacles.mark([source, target])
		_moves[target] = source
	c.animate_move(o, is_clear)


func _move_ended_handler(
	_c: Character,
	target: Vector2i,
):
	$Obstacles.obstacles.clear([_moves[target]])
	_moves.erase(target)


func _character_created_handler(_c: Character, p: Vector2i):
	$Obstacles.obstacles.mark([p])


func _ready():
	SignalBus.move_started.connect(_move_started_handler)
	SignalBus.move_ended.connect(_move_ended_handler)
	SignalBus.character_created.connect(_character_created_handler)
	
	# Existing children are already instantiated and have already emitted missed
	# signals.
	for c in $Characters.get_children():
		_character_created_handler(c, c._global_grid_position())
