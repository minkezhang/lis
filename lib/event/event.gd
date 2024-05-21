extends Object

const _libuuid = preload('res://lib/uuid.gd')
const _libdialog = preload('res://lib/dialog.gd')
const _libworkload = preload('res://lib/event/workload.gd')


class Event extends _libuuid.UUID:
	var _next: Event
	
	var _f: _libworkload.W
	
	var _singleton: bool
	var _executed: bool
	
	signal done
	
	func _init(f: _libworkload.W, singleton: bool = true):
		_f = f
		_singleton = singleton
	
	# In order to chain an event, the _next node must be synchronous.
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
		
		_f.execute()
		await _f.done
		
		if _next != null:
			_next.execute()
			await _next.done
		
		done.emit()


static func E(f: Callable, singleton: bool = true) -> Event:
	return Event.new(_libworkload.F(f), singleton)


class TimerEvent extends Event:
	func _init(n: Node, time_sec: float, singleton: bool = true):
		super(_libworkload.T.new(n, time_sec), singleton)


class EmitEvent extends Event:
	func _init(eid: String, singleton: bool = true):
		super(_libworkload.EventEmitter.new(eid), singleton)


class DialogEvent extends Event:
	func _init(l: _libdialog.Line, n: Node):
		super(_libworkload.DialogRenderer.new(n, l), true)
