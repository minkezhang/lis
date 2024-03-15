extends Node2D

var _grid_size = 32
@onready var _p = $Poseable

var _speed = _grid_size
var _direction = Vector2(0, 0)
var _in_motion = false

var _DIRECTION_LOOKUP = {}

func _ready():
    _DIRECTION_LOOKUP = {
        _p.Face.NORTH: Vector2(0, -1),
        _p.Face.SOUTH: Vector2(0, 1),
        _p.Face.EAST:  Vector2(1, 0),
        _p.Face.WEST:  Vector2(-1, 0),
    }
    print("DEBUG(minkezhang): " + str(position))

func _input(event):
    if event.is_action_pressed("ui_right"):
        _p.set_state(_p.Pose.WALK, _p.Face.EAST)
        _direction = _DIRECTION_LOOKUP[_p.Face.EAST]

    if event.is_action_pressed("ui_left"):
        _p.set_state(_p.Pose.WALK, _p.Face.WEST)
        _direction = _DIRECTION_LOOKUP[_p.Face.WEST]

    if event.is_action_pressed("ui_up"):
        _p.set_state(_p.Pose.WALK, _p.Face.NORTH)
        _direction = _DIRECTION_LOOKUP[_p.Face.NORTH]

    if event.is_action_pressed("ui_down"):
        _p.set_state(_p.Pose.WALK, _p.Face.SOUTH)
        _direction = _DIRECTION_LOOKUP[_p.Face.SOUTH]

    if event.is_action_released("ui_right") or event.is_action_released("ui_left") or event.is_action_released("ui_up") or event.is_action_released("ui_down"):
        _p.set_state(_p.Pose.IDLE)
        _direction = Vector2(0, 0)

func _physics_process(delta):
    position += _direction * (delta * _speed)
