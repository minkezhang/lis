extends Node2D
class_name Character
## Base character class.
##
## N.B.: z-index for instantiated scenes needs to be set between the z-indices
## of the World Decoration and DecorationOverlay layers, as the
## DecorationOverlay layer contains e.g. treetop tiles.

const _libposeable = preload('res://scenes/character/poseable/poseable.tscn')
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
	SignalBus.character_created.emit(self, _global_grid_position())


func _global_grid_position():
	return _gp.to_grid(global_position)


func animate_move(o: _libgeo.Orientation, is_valid: bool):
	var source = _global_grid_position()
	var target = source + Vector2i(_libgeo.ORIENTATION_RAY[o]) if is_valid else source
	var duration = (1.0 if is_valid else 0.5) / _SPEED
	
	_p.set_state(_libpose.Pose.WALK, o)
	_tween = get_tree().create_tween()
	
	# The global camera node follows Max (a subclass of this Character class) and
	# therefore also is subjected to Tween interpolation behavior.
	#
	# If the camera is synced to Max via
	#   1. _process,
	#   2. _physics_process, or
	#   3. added as a child of the Max node,
	# the camera is subjected to jitter due to some interaction between a desync
	# of setting the positions.
	#
	# Potentially related issues:
	#   * https://github.com/godotengine/godot/issues/74203
	#   * https://github.com/godotengine/godot/issues/71074
	#   * https://www.reddit.com/r/godot/comments/108g2l0/
	#   * https://www.reddit.com/r/godot/comments/tu4wl7/
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	_tween.tween_property(
		self,
		'position',
		_gp.to_world(target),
		duration,
	)
	if is_valid:
		_tween.tween_callback(func(): SignalBus.target_reached.emit(self, target))
	# Tween jitter also seems to be due in part to the Tween animating the sprite
	# in two different places for a single frame for each time the Tween starts.
	# This forces the tween to skip a bit of the initial Tween frame.
	#
	# N.B.: The delta here seems to be partially tied to the camera zoom level --
	# this may indicate that the problem actually lies in the sub-pixel rendering
	# capabilities of a moving Godot Camera2D node.
	#
	# Potentially related issues:
	#   * https://godotforums.org/d/35793
	#   * https://github.com/godotengine/godot-proposals/issues/6389
	#   * https://github.com/godotengine/godot-proposals/discussions/9256
	#
	# TODO(minkezhang): Investigate the GitHub discussion above re. v4.3dev4
	# workaround.
	_tween.custom_step(1.0 / (
		5 * Engine.physics_ticks_per_second * Engine.max_physics_steps_per_frame
	))
	_tween.play()


func _process(_delta):
	if _tween != null and _tween.is_valid():
		return
	
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
		
		var source = _global_grid_position()
		var target = source + Vector2i(_libgeo.ORIENTATION_RAY[r.orientation])
		
		SignalBus.target_requested.emit(self, r.orientation, source, target)
