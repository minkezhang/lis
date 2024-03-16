extends Node2D

const _libgeo = preload('res://lib/geo.gd')
const _libpose = preload('res://lib/pose.gd')

const _GRID_SIZE = 16
const _GRID_CENTER_OFFSET = Vector2(_GRID_SIZE, _GRID_SIZE) / 2
const _SPEED = 3.0
const _POLL_RATE_LIMIT = 15.0

@onready var _p = $Poseable

var _tween: Tween
var _path_queue: _PathQueue = _PathQueue.new()
var _delta_accum: float = 0.0


static func _position_to_grid(p: Vector2) -> Vector2i:
	return (Vector2i(p + _GRID_CENTER_OFFSET)) / _GRID_SIZE


static func _grid_to_position(g: Vector2i) -> Vector2:
	return Vector2(g) * _GRID_SIZE - _GRID_CENTER_OFFSET


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


func _handle_input(delta):
	if _delta_accum + delta < 1.0 / _POLL_RATE_LIMIT:
		_delta_accum += delta
		return
	
	_delta_accum = 0
	
	if Input.is_action_pressed('ui_right'):
		_path_queue.enqueue(_libgeo.Orientation.E)
	
	if Input.is_action_pressed('ui_left'):
		_path_queue.enqueue(_libgeo.Orientation.W)
	
	if Input.is_action_pressed('ui_up'):
		_path_queue.enqueue(_libgeo.Orientation.N)
	
	if Input.is_action_pressed('ui_down'):
		_path_queue.enqueue(_libgeo.Orientation.S)


func _process(delta):
	_handle_input(delta)

	if _tween == null or not _tween.is_valid():
		var r = _path_queue.dequeue()
		
		# Only stop animation if no subsequent movement is queued. This allows for smoother animation for continuous movement in one direction.
		if not r['success']:
			_p.set_state(_libpose.Pose.IDLE)
		elif _p.get_state()['pose'] == _libpose.Pose.IDLE and _p.get_state()['orientation'] != r['orientation']:
			_p.set_state(_libpose.Pose.IDLE, r['orientation'])
		else:
			# Allow user to face a direction before moving.
			_p.set_state(_libpose.Pose.WALK, r['orientation'])
			
			_tween = get_tree().create_tween()
			_tween.tween_property(
				self,
				'position',
				_grid_to_position(Vector2(_position_to_grid(position)) + _libgeo.ORIENTATION_RAY[r['orientation']]),
				1.0 / _SPEED,
			)
			_tween.play()
