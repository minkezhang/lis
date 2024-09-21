extends Node2D

const _libgeo = preload('res://lib/geo.gd')
const _libscript = preload('res://lib/script.gd')


# _moves is a dict of { target: source } tuples
var _moves: Dictionary = {}


func _interact_requested_handler(
	_c: Character,
	target: Vector2i,
):
	# Process static (i.e. tooltip / pop-up) events.
	if $Metadata/Events/Interactions.events.has(target):
		$Metadata/Events/Interactions.events[target].execute()
	# TODO(minkezhang): dynamic event handler (e.g. character dialog trees)


func _target_requested_handler(
	c: Character,
	o: _libgeo.Orientation,
	source: Vector2i,
	target: Vector2i,
):
	var d = (source - target).abs()
	assert(d.x + d.y == 1, "source must be adjacent to target")
	
	var is_free = not $Metadata/Obstacles.lookup.query(target)
	if is_free:
		# Reserve target space.
		$Metadata/Obstacles.lookup.mark([source, target])
		_moves[target] = source
	c.animate_move(o, is_free)


func _target_reached_handler(
	c: Character,
	target: Vector2i,
):
	$Metadata/Obstacles.lookup.mark([target])
	if target in _moves:
		$Metadata/Obstacles.lookup.clear([_moves[target]])
		_moves.erase(target)
	
	if c == $Characters/Max and $Metadata/Events/LocationTriggers.events.has(target):
		$Metadata/Events/LocationTriggers.events[target].execute()


func _character_created_handler(c: Character, p: Vector2i):
	SignalBus.target_reached.emit(c, p)


func _ready():
	SignalBus.target_requested.connect(_target_requested_handler)
	SignalBus.target_reached.connect(_target_reached_handler)
	SignalBus.interact_requested.connect(_interact_requested_handler)
