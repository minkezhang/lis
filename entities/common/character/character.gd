extends Node2D
class_name Character
## Base character class.
##
## N.B.: z-index for instantiated scenes needs to be set between the z-indices
## of the World Decoration and DecorationOverlay layers, as the
## DecorationOverlay layer contains e.g. treetop tiles.

const _libposeable = preload('res://entities/common/poseable/poseable.tscn')
const _libpathqueue = preload('res://lib/pathqueue.gd')
const _libpose = preload('res://lib/pose.gd')
const _libgeo = preload('res://lib/geo.gd')

@export var animation_sprite: AnimatedSprite2D

var _tween: Tween
var _gp: _libgeo.GeoPosition = _libgeo.GeoPosition.new(_GRID_CENTER_OFFSET, _libgeo.GRID_DIMENSION)

const _GRID_CENTER_OFFSET = Vector2(_libgeo.GRID_DIMENSION, _libgeo.GRID_DIMENSION) / 2
const _SPEED = 3.0
const _POLL_RATE_LIMIT = 15.0

var _p: Poseable

var path_queue: _libpathqueue.PathQueue


func _ready():
	_p = _libposeable.instantiate()
	_p.animation_sprite = animation_sprite
	add_child(_p)
	path_queue = _libpathqueue.PathQueue.new(1)


func animate_move(o: _libgeo.Orientation, is_clear: bool):
	var source = _gp.to_grid(position)
	var target = source + Vector2i(_libgeo.ORIENTATION_RAY[o]) if is_clear else source
	print("DEBUG(character.gd): animate_move: source = %s, target = %s" % [source, target])
	print("DEBUG(character.gd): animate_move: source = %s, target = %s" % [_gp.to_world(source), _gp.to_world(target)])
	var duration = (1.0 if is_clear else 0.5) / _SPEED
	_p.set_state(_libpose.Pose.WALK, o)
	_tween = get_tree().create_tween()
	_tween.tween_property(
		self,
		'position',
		_gp.to_world(target),
		duration,
	)
	_tween.tween_callback(func(): SignalBus.move_ended.emit(self))
	_tween.play()


func _process(_delta):
	if _tween == null or not _tween.is_valid():
		var r = path_queue.dequeue()
		
		# Only stop animation if no subsequent movement is queued. This allows for
		# smoother animation for continuous movement in one direction.
		if not r.success:
			_p.set_state(_libpose.Pose.IDLE)
		elif _p.get_state().pose == _libpose.Pose.IDLE and _p.get_state().orientation != r.orientation:
			_p.set_state(_libpose.Pose.IDLE, r.orientation)
		else:
			# Allow user to face a direction before moving.
			_p.set_state(_libpose.Pose.WALK, r.orientation)
			
			var source = _gp.to_grid(global_position)
			var target = source + Vector2i(_libgeo.ORIENTATION_RAY[r.orientation])
			print("DEBUG(character.gd): _process: source = %s, target = %s" % [source, target])
			SignalBus.move_started.emit(self, r.orientation, source, target)
