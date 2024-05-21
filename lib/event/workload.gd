extends Object

const _libdialog = preload('res://lib/dialog.gd')


class W:
	signal done
	
	func execute():
		assert(false, 'unimplemented Function.execute() method')


class _F extends W:
	var _f: Callable
	
	func _init(f: Callable):
		_f = f
	
	func execute():
		await _f.call()
		done.emit()


static func F(f: Callable):
	return _F.new(f)


class T extends _F:
	func _init(n: Node, time_sec: float):
		super(func(): await n.get_tree().create_timer(time_sec).timeout)


class EventEmitter extends _F:
	func _init(eid: String):
		super(func(): SignalBus.event_triggered.emit(eid))


class AnimatorConfig:
	var _property: String
	var _value: Variant
	var _duration: float
	
	func _init(p: String, v: Variant, d: float):
		_property = p
		_value = v
		_duration = d


class DialogRenderer extends W:
	var _l: _libdialog.Line
	var _n: Node
	
	func _init(n: Node, l: _libdialog.Line):
		_n = n
		_l = l
	
	func execute():
		var _h = func(lid: String):
			if lid == _l.uuid():
				done.emit()
		
		SignalBus.eof_reached.connect(_h)
		
		_n.set_dialog(_l)
		await done
		
		SignalBus.eof_reached.disconnect(_h)


class Animator extends W:
	var _n: Node
	var _animations: Array
	
	func _init(n: Node, animations: Array):
		_n = n
		_animations = animations
	
	func _execute_helper(animations: Array):
		if not animations.size():
			done.emit()
			return
		
		var a = animations.pop_front()
		var t = _n.get_tree().create_tween()
		t.tween_property(_n, a._property, a._value, a._duration)
		t.tween_callback(func(): _execute_helper(animations))
	
	func execute():
		_execute_helper(_animations)
