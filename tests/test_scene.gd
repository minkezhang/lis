extends Object

const _libtest = preload('res://lib/test/test.gd')

class TestScene extends _libtest.T:
	func _init():
		super('test/test_scene', [
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
	
	func got(c: Dictionary) -> Variant:
		var t = Timer.new()
		root().add_child(t)
		t.start()
		await t.timeout
		
		return c['got']
