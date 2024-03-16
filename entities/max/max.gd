extends Node2D

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(_GRID_SIZE / 2, _GRID_SIZE / 2)
const _SPEED = _GRID_SIZE

static func _position_to_grid(p: Vector2) -> Vector2i:
    return (Vector2i(p + _GRID_CENTER_OFFSET)) / _GRID_SIZE

static func _grid_to_position(g: Vector2i) -> Vector2:
    return Vector2(g) * _GRID_SIZE - _GRID_CENTER_OFFSET

@onready var _p = $Poseable
@onready var _DIRECTION_LOOKUP = {
        _p.Face.NORTH: Vector2i(0, -1),
        _p.Face.SOUTH: Vector2i(0, 1),
        _p.Face.EAST:  Vector2i(1, 0),
        _p.Face.WEST:  Vector2i(-1, 0),
    }

@onready var _grid = _position_to_grid(position)
@onready var _target = _grid
@onready var _tween = Tween.new()
var _direction = Vector2i(0, 0)

func _ready():
    print("DEBUG(minkezhang): " + str(position) + ", " + str(_grid))

func _input(event):
    if _tween.is_valid():
        return

    _tween = create_tween()

    if event.is_action_pressed("ui_right"):
        _p.set_state(_p.Pose.WALK, _p.Face.EAST)
        _direction = _DIRECTION_LOOKUP[_p.Face.EAST]
        _tween.tween_property(self, "position", _grid_to_position(_position_to_grid(position) + _direction), 1)
        _tween.tween_callback(_tween.kill)
        _tween.play()

    if event.is_action_pressed("ui_left"):
        _p.set_state(_p.Pose.WALK, _p.Face.WEST)
        _direction = _DIRECTION_LOOKUP[_p.Face.WEST]
        _tween.tween_property(self, "position", _grid_to_position(_position_to_grid(position) + _direction), 1)
        _tween.tween_callback(_tween.kill)
        _tween.play()

    if event.is_action_pressed("ui_up"):
        _p.set_state(_p.Pose.WALK, _p.Face.NORTH)
        _direction = _DIRECTION_LOOKUP[_p.Face.NORTH]
        _tween.tween_property(self, "position", _grid_to_position(_position_to_grid(position) + _direction), 1)
        _tween.tween_callback(_tween.kill)
        _tween.play()

    if event.is_action_pressed("ui_down"):
        _p.set_state(_p.Pose.WALK, _p.Face.SOUTH)
        _direction = _DIRECTION_LOOKUP[_p.Face.SOUTH]
        _tween.tween_property(self, "position", _grid_to_position(_position_to_grid(position) + _direction), 1)
        _tween.tween_callback(_tween.kill)
        _tween.play()

    # if event.is_action_released("ui_right") or event.is_action_released("ui_left") or event.is_action_released("ui_up") or event.is_action_released("ui_down"):
    #     _p.set_state(_p.Pose.IDLE)
    #     _direction = Vector2(0, 0)

# func _physics_process(delta):
    # position += _direction * (delta * _SPEED)
