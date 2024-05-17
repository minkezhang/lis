extends Object

const _libuuid = preload('res://lib/uuid.gd')
const _libdialog = preload('res://lib/dialog.gd')


class Event extends _libuuid.UUID:
	var _next: Event
	
	var _f: Callable
	
	var _singleton: bool
	var _executed: bool
	
	func _init(f: Callable, singleton: bool = true):
		_f = f
		_singleton = singleton
	
	func chain(e: Event) -> Event:
		if _next == null:
			_next = e
		else:
			_next.chain(e)
		return self
	
	func execute():
		if _singleton and _executed:
			return
		
		_executed = true
		
		if _next == null:
			_f.call()
			return
		
		await _f.call()
		_next.execute()


class TimerEvent extends Event:
	func _init(n: Node, time_sec: float, singleton: bool = true):
		super(func(): await n.get_tree().create_timer(time_sec).timeout, singleton)


class EmitEvent extends Event:
	func _init(eid: String, singleton: bool = true):
		super(func(): SignalBus.event_triggered.emit(eid), singleton)


class _DialogHelper:
	var _l: _libdialog.Line
	var _n: Node
	signal _eof
	
	func _init(l: _libdialog.Line, n: Node):
		_l = l
		_n = n
	
	func run():
		var _h = func(lid: String):
			if lid == _l.uuid():
				_eof.emit()
		SignalBus.eof_reached.connect(_h)
		
		_n.set_dialog(_l)
		
		await _eof
		
		SignalBus.eof_reached.disconnect(_h)


class DialogEvent extends Event:
	func _init(l: _libdialog.Line, n: Node):
		super(func(): await _DialogHelper.new(l, n).run(), true)
