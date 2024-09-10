extends Node

const _libframework = preload('res://tests/framework/framework.gd')
const _libworkload = preload('res://lib/event/workload.gd')
const _libevent = preload('res://lib/event/event.gd')


class _E extends _libevent.E:
	var _name: String
	func _init(name: String):
		_name = name
		super(func(): return)


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


class Filter extends _libframework.SingletonT:
	func _init():
		super('event/filter')
	
	func run() -> Array:
		var x = {'pre': false, 'post': false}
		var pre = func() -> bool:
			x['pre'] = true
			return true
		var post = func() -> bool:
			x['post'] = true
			return true
		var f = func() -> bool:
			return false
		
		var e = _libevent.E.new(pre).chain(
			_libevent.E.new(f).chain(
			_libevent.E.new(post)))
		
		await e.execute()
		
		return [
			_libframework.R.new('pre', x['pre'] == true, true, x['pre']),
			_libframework.R.new('post', x['post'] == false, false, x['post']),
		]


class Singleton extends _libframework.SingletonT:
	func _init():
		super('event/singleton')
	
	func run() -> Array:
		var x = {'e': 0, 'd': 0}
		
		var f = func() -> bool:
			x['e'] += 1
			return true
		
		var g = func() -> bool:
			x['d'] += 1
			return true
		
		var e = _libevent.E.new(_libworkload.Singleton()).chain(_libevent.E.new(f))
		var d = _libevent.E.new(_libworkload.Singleton()).chain(_libevent.E.new(g))

		await e.execute()
		await e.execute()
		await d.execute()
		
		return [
			_libframework.R.new('e.execute()', x['e'] == 1, 1, x['e']),
			_libframework.R.new('d.execute()', x['d'] == 1, 1, x['d']),
		]

class Serialized extends _libframework.SingletonT:
	func _init():
		super('event/serialized')
	
	func run() -> Array:
		var x = {'val': 0}
		var f = func() -> bool:
			await root().get_tree().create_timer(1.0).timeout
			x['val'] += 1
			return true
		var e = _libevent.E.new(f, true)
		
		e.execute()
		e.execute()
		
		await root().get_tree().create_timer(2.0).timeout
		
		return [
			_libframework.R.new('E.execute()', x['val'] == 1, 1, x['val'])
		]


class Simple extends _libframework.SingletonT:
	func _init():
		super('event/simple')
	
	func run() -> Array:
		var x = {'val': false}
		var f = func() -> bool:
			x['val'] = true
			return true
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
		
		var fa = func() -> bool:
			# Ensure we can tell if _bf is executing concurrently and therefore
			# returning early.
			await root().get_tree().create_timer(1.0).timeout
			ts[0] = Time.get_ticks_usec()
			return true
		var fb = func() -> bool:
			await root().get_tree().create_timer(0.5).timeout
			ts[1] = Time.get_ticks_usec()
			return true
		
		var e = _libevent.E.new(fa).chain(
			_libevent.E.new(fb),
		)
		
		# Wait until fb actually returns to write the time of
		# execution.
		await e.execute()
		
		return [
			_libframework.R.new('E.execute()', ts[1] > ts[0], true, false),
		]
