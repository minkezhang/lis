extends Object

const _libevent = preload('res://lib/event/event.gd')
const _libdialog = preload('res://lib/dialog.gd')


static func Timer(n: Node, time_sec: float) -> Callable:
	var f = func() -> bool:
		await n.get_tree().create_timer(time_sec).timeout
		return true
	
	return f


static func EventEmitter(eid: String) -> Callable:
	var f = func() -> bool:
		SignalBus.event_triggered.emit(eid)
		return true
	
	return f


static func DialogRenderer(n: Node, l: _libdialog.Line) -> Callable:
	return func() -> bool:
		return await _DialogRenderer.new(n, l).payload()


static func Animator(n: Node, animations: Array):
	return func() -> bool:
		return await _Animator.new(n, animations).payload()


class AnimatorConfig:
	var _property: String
	var _value: Variant
	var _duration: float
	
	func _init(p: String, v: Variant, d: float):
		_property = p
		_value = v
		_duration = d


class _DialogRenderer:
	var _l: _libdialog.Line
	var _n: Node
	signal _dialog_finished
	
	func _init(n: Node, l: _libdialog.Line):
		_n = n
		_l = l
	
	func payload() -> bool:
		var h = func(lid: String):
			if lid == _l.uuid():
				_dialog_finished.emit()
	
		SignalBus.eof_reached.connect(h)
	
		_n.set_dialog(_l)
		await _dialog_finished
	
		SignalBus.eof_reached.disconnect(h)
		return true


class _Animator:
	var _n: Node
	var _animations: Array
	
	func _init(n: Node, animations: Array):
		_n = n
		_animations = animations
	
	func payload() -> bool:
		var l = _animations.duplicate()
		while l.size():
			var a = l.pop_front()
			var t = _n.get_tree().create_tween()
			t.tween_property(_n, a._property, a._value, a._duration)
			await t.finished
		return true
