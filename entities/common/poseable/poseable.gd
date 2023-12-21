extends Node2D

enum Pose { IDLE, WALK }
enum Face { NORTH, SOUTH, EAST, WEST }

var _POSE_LOOKUP = {
    Pose.IDLE: "idle",
    Pose.WALK: "walk",
}

var _FACE_LOOKUP = {
    Face.NORTH: "north",
    Face.SOUTH: "south",
    Face.EAST: "west",  # AnimationLibrary will be flipped
    Face.WEST: "west",
}

var _ANIMATION_LOOPS = [
    "idle_north",
    "idle_south",
    "idle_west",
    "walk_north",
    "walk_south",
    "walk_west",
]

var _face: Face = Face.SOUTH
var _pose: Pose = Pose.IDLE
var _loop: String  = "idle_south"
var _is_dirty = false

@export var animation_sprite: AnimatedSprite2D


func set_state(pose: Pose = _pose, face: Face = _face):
    _is_dirty = true
    
    animation_sprite.flip_h = (face == Face.EAST)

    _face = face
    _pose = pose
    _loop = "{pose}_{face}".format({
        "pose": _POSE_LOOKUP[pose],
        "face": _FACE_LOOKUP[face],
    })


func _ready():
    
    assert(animation_sprite != null, "Property animation_sprite must be non-null")
    
    for l in _ANIMATION_LOOPS:
        assert(animation_sprite.sprite_frames.has_animation(l), "Property animation_sprite does not contain the expected animation loops: {}".format([l]))


func _process(_delta):
    if not _is_dirty:
        return

    animation_sprite.play(_loop)
