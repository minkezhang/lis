extends Object

const _libevent = preload('res://lib/event/event.gd')
const _libdialog = preload('res://lib/dialog.gd')
const _libsplash = preload('res://lib/splash.gd')


static func Singleton() -> Callable:
	var s = _Singleton.new()
	var f = func() -> bool:
		return s.payload()
	return f


class _Singleton:
	var _has_run: bool
	
	func _init():
		_has_run = false
	
	func payload() -> bool:
		var succ = true
		if _has_run:
			succ = false
		_has_run = true

		return succ


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


static func SplashRender(n: Node, s: _libsplash.Splash) -> Callable:
	return func() -> bool:
		return await _SplashRenderer.new(n, s).payload()


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


class _SplashRenderer:
	var _s: _libsplash.Splash
	var _n: Node
	signal _splash_finished
	
	func _init(n: Node, s: _libsplash.Splash):
		_n = n
		_s = s
	
	func payload() -> bool:
		var h = func(tid: String):
			if tid == _s.uuid():
				_splash_finished.emit()
	
		SignalBus.eof_reached.connect(h)
		
		_n.set_splash(_s)
		await _splash_finished
		
		SignalBus.eof_reached.disconnect(h)
		return true


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
