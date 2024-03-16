extends Node2D

const _poseable_module = preload("res://entities/common/poseable/poseable.gd")

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(_GRID_SIZE, _GRID_SIZE) / 2
const _SPEED = _GRID_SIZE
const _DIRECTION_LOOKUP = {
        _poseable_module.Face.NORTH: Vector2i(0, -1),
        _poseable_module.Face.SOUTH: Vector2i(0, 1),
        _poseable_module.Face.EAST:  Vector2i(1, 0),
        _poseable_module.Face.WEST:  Vector2i(-1, 0),
    }

static func _position_to_grid(p: Vector2) -> Vector2i:
    return (Vector2i(p + _GRID_CENTER_OFFSET)) / _GRID_SIZE

static func _grid_to_position(g: Vector2i) -> Vector2:
    return Vector2(g) * _GRID_SIZE - _GRID_CENTER_OFFSET

@onready var _p = $Poseable
@onready var _tween: Tween

var _path_queue = _PathQueue.new()
class _PathQueue:
    const _CAPACITY = 1
    
    var _buf = []

    func enqueue(f: _poseable_module.Face) -> Dictionary:
        if len(_buf) < _CAPACITY:
            _buf.push_back(f)
            return {
                'face': f,
                'success': true,
            }
        return {
            'face': null,
            'success': false,
        }
    
    func dequeue() -> Dictionary:
        if len(_buf) > 0:
            return {
                'face': _buf.pop_front(),
                'success': true,
            }
        return {
            'face': null,
            'success': false,
        }

func _process(_delta):
    if _tween == null or not _tween.is_valid():
        var r = _path_queue.dequeue()
        # Only stop animation if no subsequent movement is queued. This allows for smoother animation for continuous movement in one direction.
        if not r['success']:
            _p.set_state(_p.Pose.IDLE)
        else:
            _p.set_state(_p.Pose.WALK, r['face'])
            _tween = get_tree().create_tween()
            _tween.tween_property(
                self,
                "position",
                _grid_to_position(_position_to_grid(position) + _DIRECTION_LOOKUP[r['face']]),
                0.25,
            )
            _tween.play()

func _input(event):
    if event.is_action_pressed("ui_right"):
        _path_queue.enqueue(_p.Face.EAST)

    if event.is_action_pressed("ui_left"):
        _path_queue.enqueue(_p.Face.WEST)

    if event.is_action_pressed("ui_up"):
        _path_queue.enqueue(_p.Face.NORTH)

    if event.is_action_pressed("ui_down"):
        _path_queue.enqueue(_p.Face.SOUTH)
