extends Object
# TODO(minkezhang): Remove extraneous class_name declaration in Godot v4.3. See
# https://github.com/godotengine/godot/issues/86032 for more information.
class_name _EventTest

const _libevent = preload('res://lib/event.gd')
const _libframework = preload('res://tests/framework/framework.gd')

class E extends _libevent.Event:
	var _eid: String
	
	func _init(eid: String):
		super(func(): return)
		_eid = eid
	func _cmp(other: E) -> bool:
		if other == null:
			return false
		
		if _eid != other._eid:
			return false
		
		if (self._next == null) and (other._next == null):
			return true
		
		return _next._cmp(other._next)


class Chain extends _libframework.SingletonT:
	func _init():
		super('event/chain')
	
	func run() -> Array:
		var want = E.new('a')
		want._next = E.new('b')
		want._next._next = E.new('c')
		
		var ga = E.new('a').chain(
			E.new('b')
		).chain(
			E.new('c')
		)
		
		var gb = E.new('a').chain(
			E.new('b').chain(
			E.new('c')
		))
		return [
			_libframework.R.new('Nested', ga._cmp(want), want, ga),
			_libframework.R.new('Nested/Alt', gb._cmp(want), want, gb),
		]


# Check that in the case of chained events, all events preceding the last
# event in the chain are fully executed.
class ExecuteAwait extends _libframework.SingletonT:
	signal _done
	
	func _init():
		super('event/execute_wait', Node.new())
	
	func run() -> Array:
		# Must pass-by-reference for locally-scoped variables. See
		# https://github.com/godotengine/godot/issues/69014.
		var _timer = {
			'a': -INF,
			'b': -INF,
		}
		var _af = func():
			# Ensure we can tell if _bf is executing concurrently and therefore
			# returning early.
			await root().get_tree().create_timer(1.0).timeout
			_timer['a'] = Time.get_ticks_usec()
		var _bf = func():
			await root().get_tree().create_timer(0.5).timeout
			_timer['b'] = Time.get_ticks_usec()
			_done.emit()
		
		var a = _libevent.Event.new(_af).chain(
			_libevent.Event.new(_bf),
		)
		
		a.execute()
		
		# Wait until _bf actually returns to write the time of
		# execution.
		await _done
		
		return [
			_libframework.R.new('Timer', _timer['b'] > _timer['a'], true, false),
		]
