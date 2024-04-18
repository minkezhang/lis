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
var _gp: _libgeo.GeoPosition = _libgeo.GeoPosition.new(_GRID_CENTER_OFFSET, _GRID_SIZE)

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(0, _GRID_SIZE) / 2
const _SPEED = 3.0
const _POLL_RATE_LIMIT = 15.0

var _p: Poseable

var path_queue: _libpathqueue.PathQueue


func _ready():
	_p = _libposeable.instantiate()
	_p.animation_sprite = animation_sprite
	add_child(_p)
	path_queue = _libpathqueue.PathQueue.new(1)


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
			_tween = get_tree().create_tween()
			_tween.tween_property(
				animation_sprite,
				'position',
				_gp.to_world(Vector2(_gp.to_grid(animation_sprite.position)) + _libgeo.ORIENTATION_RAY[r.orientation]),
				1.0 / _SPEED,
			)
			_tween.play()
