extends Node2D

const _libgeo = preload('res://lib/geo.gd')
const _libscript = preload('res://lib/script.gd')


# _moves is a dict of { target: source } tuples
var _moves: Dictionary = {}

func _target_requested_handler(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2i,
	target: Vector2i,
):
	var d = (source - target).abs()
	assert(d.x + d.y == 1, "source must be adjacent to target")
	
	var is_free = not $Obstacles.obstacles.query(target)
	if is_free:
		# Reserve target space.
		$Obstacles.obstacles.mark([source, target])
		_moves[target] = source
	c.animate_move(o, is_free)


func _target_reached_handler(
	_c: Character,
	target: Vector2i,
):
	$Obstacles.obstacles.mark([target])
	if target in _moves:
		$Obstacles.obstacles.clear([_moves[target]])
		_moves.erase(target)


func _character_created_handler(c: Character, p: Vector2i):
	SignalBus.target_reached.emit(c, p)


func _ready():
	SignalBus.target_requested.connect(_target_requested_handler)
	SignalBus.target_reached.connect(_target_reached_handler)
