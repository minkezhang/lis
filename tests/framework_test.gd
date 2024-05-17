extends Object

const _libframework = preload('res://tests/framework/framework.gd')


class TestScene extends _libframework.T:
	func _init():
		super('framework/test_scene', [
			{
				'name': 'Simple',
				'want': 1,
				'got': 1,
			},
			{
				'name': 'Simple/2',
				'want': 2,
				'got': 2,
			},
		], Node.new())
	
	func _got(c: Dictionary) -> Variant:
		var t = Timer.new()
		root().add_child(t)
		t.start()
		await t.timeout
		
		return c['got']
