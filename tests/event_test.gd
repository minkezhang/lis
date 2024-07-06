extends Node

const _libframework = preload('res://tests/framework/framework.gd')
const _libevent = preload('res://lib/event/event.gd')


class _E extends _libevent.E:
	func _init(name: String):
		super(func(): return, name)


class Chain extends _libframework.T:
	func _init():
		super('event/chain', [
			{
				'name': 'Trivial',
				'want': ['a', 'b'],
				'e': _E.new('a').chain(_E.new('b')),
			},
			{
				'name': 'ChainInvariance',
				'want': ['a', 'b', 'c'],
				'e': _E.new('a').chain(_E.new('b').chain(_E.new('c'))),
			}
		])
	
	func _got(_c: Dictionary) -> Array:
		var r = _c['e']
		var g = []
		while r != null:
			g = g + [r._name]
			r = r._next
		
		return g
	

class Simple extends _libframework.SingletonT:
	func _init():
		super('event/simple')
	
	func run() -> Array:
		var x = {'val': false}
		var f = func():
			x['val'] = true
		await _libevent.E.new(f).execute()
		
		return [
			_libframework.R.new('E.execute()', x['val'], true, false),
		]

class EventTimer extends _libframework.SingletonT:
	func _init():
		super('event/event_timer', Node.new())
	
	func run() -> Array:
		var ts = [
			'-INF',
			'-INF',
		]
		
		var fa = func():
			# Ensure we can tell if _bf is executing concurrently and therefore
			# returning early.
			await root().get_tree().create_timer(1.0).timeout
			ts[0] = Time.get_ticks_usec()
		var fb = func():
			await root().get_tree().create_timer(0.5).timeout
			ts[1] = Time.get_ticks_usec()
		
		var e = _libevent.E.new(fa).chain(
			_libevent.E.new(fb),
		)
		
		# Wait until fb actually returns to write the time of
		# execution.
		await e.execute()
		
		return [
			_libframework.R.new('E.execute()', ts[1] > ts[0], true, false),
		]
