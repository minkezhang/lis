extends Node2D

const _libgeo = preload("res://lib/geo.gd")
const _libpose = preload("res://lib/pose.gd")

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(_GRID_SIZE, _GRID_SIZE) / 2
const _SPEED = _GRID_SIZE


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
	func enqueue(o: _libgeo.Orientation) -> Dictionary:
		if len(_buf) < _CAPACITY:
			_buf.push_back(o)
			return {
				'orientation': o,
				'success': true,
			}
		return {
			'orientation': null,
			'success': false,
		}


	func dequeue() -> Dictionary:
		if len(_buf) > 0:
			return {
				'orientation': _buf.pop_front(),
				'success': true,
			}
		return {
			'orientation': null,
			'success': false,
		}


func _process(_delta):
	if _tween == null or not _tween.is_valid():
		var r = _path_queue.dequeue()
		
		# Only stop animation if no subsequent movement is queued. This allows for smoother animation for continuous movement in one direction.
		if not r['success']:
			_p.set_state(_libpose.Pose.IDLE)
		else:
			# Allow user to face a direction before moving.
			var is_walk_pose = _p.get_state()["orientation"] == r["orientation"]
			_p.set_state(_libpose.Pose.WALK if is_walk_pose else _libpose.Pose.IDLE, r["orientation"])
			
			if is_walk_pose:
				_tween = get_tree().create_tween()
				_tween.tween_property(
					self,
					"position",
					_grid_to_position(Vector2(_position_to_grid(position)) + _libgeo.ORIENTATION_RAY[r['orientation']]),
					0.25,
				)
				_tween.play()


func _input(event):
	if event.is_action_pressed("ui_right"):
		_path_queue.enqueue(_libgeo.Orientation.E)

	if event.is_action_pressed("ui_left"):
		_path_queue.enqueue(_libgeo.Orientation.W)

	if event.is_action_pressed("ui_up"):
		_path_queue.enqueue(_libgeo.Orientation.N)

	if event.is_action_pressed("ui_down"):
		_path_queue.enqueue(_libgeo.Orientation.S)
