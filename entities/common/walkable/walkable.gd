extends Node2D

signal state_idle

const Poseable = preload('res://entities/common/poseable/poseable.tscn')
const _libpathqueue = preload('res://lib/pathqueue.gd')
const _libpose = preload('res://lib/pose.gd')
const _libgeo = preload('res://lib/geo.gd')

var _tween: Tween

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(_GRID_SIZE, _GRID_SIZE) / 2
const _SPEED = 3.0
const _POLL_RATE_LIMIT = 15.0

@export var poseable: Node2D
@export var x: int

var path_queue: _libpathqueue.PathQueue
var _gp: _libgeo.GeoPosition = _libgeo.GeoPosition.new(_GRID_CENTER_OFFSET, _GRID_SIZE)


func _ready():
	path_queue = _libpathqueue.PathQueue.new(1)


func _process(delta):
	if _tween == null or not _tween.is_valid():
		var r = path_queue.dequeue()
		
		# Only stop animation if no subsequent movement is queued. This allows for
		# smoother animation for continuous movement in one direction.
		if not r.success:
			poseable.set_state(_libpose.Pose.IDLE)
		elif poseable.get_state().pose == _libpose.Pose.IDLE and poseable.get_state().orientation != r.orientation:
			poseable.set_state(_libpose.Pose.IDLE, r.orientation)
		else:
			# Allow user to face a direction before moving.
			poseable.set_state(_libpose.Pose.WALK, r.orientation)
			
			_tween = get_tree().create_tween()
			_tween.tween_property(
				self,
				'position',
				_gp.to_world(Vector2(_gp.to_grid(position)) + _libgeo.ORIENTATION_RAY[r.orientation]),
				1.0 / _SPEED,
			)
			_tween.play()
