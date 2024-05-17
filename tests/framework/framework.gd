extends Object


class R:
	var _message: String
	var _success: bool
	
	func _init(n: String, ok: bool, w: Variant = null, g: Variant = null):
		if not ok:
			_message = '     {name}: got = {got}, want = {want}'.format({
					'name': n,
					'got': g,
					'want': w,
				})
		_success = ok
	
	func success() -> bool:
		return _success
	
	func message() -> String:
		return  _message


class SingletonT:
	var _root: Node
	var _name: String
	
	func _init(n: String, r: Node = Node.new()):
		_name = n
		_root = r
	
	func root() -> Node:
		return _root
	
	func name() -> String:
		return _name
	
	func run() -> Array:
		assert(false, 'unimplemented run method')
		return []


class T extends SingletonT:
	var _configs: Array
	
	func _init(n: String, cs: Array, r: Node = Node.new()):
		super(n, r)
		
		_configs = cs
	
	func _got(_c: Dictionary) -> Variant:
		assert(false, 'unimplemented got method')
		return R.new('', false)
	
	func _cmp(a, b: Variant) -> bool:
		return a == b
	
	func _test(c: Dictionary) -> R:
		var g = await _got(c)
		return R.new(c['name'], _cmp(c['want'], g), c['want'], g)
	
	func run() -> Array:
		var results = []
		for c in _configs:
			results.append(await _test(c))
		
		return results


class S extends Node:
	var _fp: FileAccess
	func _init():
		var time_start = Time.get_datetime_dict_from_system()
		var path = 'res://tests/logs/results_{human}_{timestamp}.txt'.format({
			'human': '%d%02d%02d' % [
				time_start.year,
				time_start.month,
				time_start.day
			],
			'timestamp': floor(Time.get_unix_time_from_datetime_dict(time_start)),
		})
		_fp = FileAccess.open(path, FileAccess.WRITE)
	
	func _print(s: String):
		print(s)
		if _fp != null:
			_fp.store_line(s)
		
	func run(ts: Array):
		for t in ts:
			add_child(t.root())
		
		var success = true
		for t in ts:
			_print('==== RUN\t{name}'.format({
				'name': t.name()
			}))
			var s = true
			var time_start = Time.get_ticks_msec()
			var results = await t.run()
			for r in results:
				s = s and r.success()
				if not r.success():
					_print(r.message())
			var time_delta = Time.get_ticks_msec() - time_start
			
			_print('---- {result}\t{name} ({delta}s)'.format({
				'result': 'PASS' if s else 'FAIL',
				'name': t.name(),
				'delta': '%0.02f' % (time_delta / 1e3),
			}))
			
			success = success and s
		
		_print('PASS' if success else 'FAIL')
		if _fp != null:
			_fp.close()
