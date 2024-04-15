extends Node2D
class_name Poseable

const _libpose = preload('res://lib/pose.gd')
const _libgeo = preload('res://lib/geo.gd')

@export var animation_sprite: AnimatedSprite2D

var _ANIMATION_STRING = [
	'idle_north',
	'idle_south',
	'idle_west',
	'walk_north',
	'walk_south',
	'walk_west',
]

var _orientation: _libgeo.Orientation = _libgeo.Orientation.S
var _pose: _libpose.Pose = _libpose.Pose.IDLE
var _loop: String  = 'idle_south'
var _is_dirty = false


func _ready():
	assert(animation_sprite != null, 'Property animation_sprite must be non-null')
	for l in _ANIMATION_STRING:
		assert(animation_sprite.sprite_frames.has_animation(l), 'Property animation_sprite does not contain the expected animation loops: {}'.format([l]))


func _process(_delta):
	if not _is_dirty:
		return

	animation_sprite.play(_loop)


func set_state(p: _libpose.Pose = _pose, o: _libgeo.Orientation = _orientation):
	_is_dirty = true

	animation_sprite.flip_h = (o == _libgeo.Orientation.E)

	_orientation = o
	_pose = p
	_loop = '{p}_{o}'.format({
		'p': _libpose.POSE_STRING[p],
		'o': _libpose.POSE_ORIENTATION_STRING[o],
	})


func get_state() -> _PoseState:
	return _PoseState.new(_orientation, _pose)


class _PoseState:
	var orientation: _libgeo.Orientation
	var pose: _libpose.Pose
	
	func _init(o: _libgeo.Orientation, p: _libpose.Pose):
		orientation = o
		pose = p
