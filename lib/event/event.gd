extends Object

const _libuuid = preload('res://lib/uuid.gd')

## E describes an event model for the game.
##
## The event accepts a payload function with takes a signal as its only input,
## which the payload write to after completion. This signal is not directly
## accessible by the event caller. Instead, the event itself writes to a
## separate signal E.done.
##
## Events may be chained together to run synchronously, e.g.
##   E.chain(F).chain(G)
## which is identical to
##   E.chain(F.chain(G))
##
## For either of the above invocations, calling
##   E.execute()
## will execute the events in E -> F -> G order.
##
## Example:
##   await E(func(): return).execute()
class E extends _libuuid.UUID:
	var _next: E
	var _f: Callable  # func(done: Signal) -> bool
	
	var _is_singleton: bool
	var _is_valid: bool
	
	var _is_running: bool
	var _is_serialized: bool
	
	func _init(f: Callable, singleton: bool = false, serialized: bool = false):
		_f = f
		
		_is_singleton = singleton
		_is_valid = true
		
		_is_serialized = serialized
		_is_running = false
	
	# In order to chain an event, the _next node must be synchronous.
	func chain(e: E) -> E:
		if _next == null:
			_next = e
		else:
			_next.chain(e)
		return self
	
	func execute() -> bool:
		if not _is_valid:
			return false
		
		if _is_serialized and _is_running:
			return false
		
		_is_running = true
		
		if _is_singleton:
			_is_valid = false
		
		var succ = await _f.call()
		
		if succ and _next != null:
			succ = await _next.execute()
		
		_is_running = false
		return succ
