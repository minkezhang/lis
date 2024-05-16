extends Object

const _libid = preload('res://lib/id.gd')
const _libdialog = preload('res://lib/dialog.gd')


class Event:
	var _next: Event
	
	func chain(e: Event):
		if _next == null:
			_next = e
		else:
			_next.chain(e)
		return self
	
	func execute():
		if _next != null:
			_next.execute()

class EmitEvent extends Event:
	var _eid: String
	
	func _init(eid: String):
		_eid = eid
	
	func execute():
		SignalBus.event_triggered.emit(_eid)
		
		super()


class TimerEvent extends Event:
	var _n: Node
	var _time_sec: float
	
	func _init(n: Node, time_sec: float):
		_n = n
		_time_sec = time_sec
	
	func execute():
		var _t = Timer.new()
		
		_n.add_child(_t)
		_t.start(_time_sec)
		
		await _t.timeout
		
		_t.queue_free()
		
		super()

class CustomEvent extends Event:
	var _f: Callable
	func _init(f: Callable):
		_f = f
	
	func execute():
		self._f.call()
		
		super()


class DialogEvent extends Event:
	var _l: _libdialog.Line
	var _n: Node
	var _eid: String
	var _executed: bool  # dialog is a singleton event
	signal _eof
	
	func _init(l: _libdialog.Line, n: Node, eid: String = ''):
		_l = l
		_n = n
		_eid = eid
		_executed = false
	
	func execute():
		if _executed:
			return
		_executed = true
		
		var _h = func(l: String):
			if l == _eid:
				_eof.emit()
				print("handled: {l}".format({'l': l}))
		SignalBus.eof_reached.connect(_h)
		
		_n.set_dialog(_l, _eid)
		
		await _eof
		SignalBus.eof_reached.disconnect(_h)
		print("exited: {l}".format({'l': _eid}))
		super()
