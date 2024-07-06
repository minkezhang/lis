extends ColorRect

const _libevent = preload('res://lib/event/event.gd')
const _libworkload = preload('res://lib/event/workload.gd')

@export var mode: Mode

enum Mode { NEUTRAL, SUNLIGHT, STORM }
const _COLORS = {
	Mode.STORM: Color(0x30115930),
	Mode.NEUTRAL: Color(0xffffff00),
	Mode.SUNLIGHT: Color(0xd4b13530),
}


const _FREQUENCY = 0.5
const _DOUBLE_STRIKE_PERCENTAGE = 0.2


class _Lightning:
	var _n: Node
	
	func _init(n: Node):
		_n = n
	
	func _single_strike():
		await _libworkload.Animator(
			_n, [
				_libworkload.AnimatorConfig.new('color', Color(0xfffffffaa), 0.05),
				_libworkload.AnimatorConfig.new('color', Color(0xfffffff44), 0.15),
				_libworkload.AnimatorConfig.new(
					'color',
					_COLORS[_n.mode],
					0.2,
				),
			],
		).call()
	
	func _double_strike():
		await _libworkload.Animator(
			_n, [
				_libworkload.AnimatorConfig.new('color', Color(0xfffffffaa), 0.05),
				_libworkload.AnimatorConfig.new('color', Color(0x0000000aa), 0.05),
				_libworkload.AnimatorConfig.new('color', Color(0xfffffff88), 0.05),
				_libworkload.AnimatorConfig.new('color', Color(0x000000088), 0.15),
				_libworkload.AnimatorConfig.new(
					'color',
					_COLORS[_n.mode],
					0.2,
				),
			],
		).call()
	
	func payload():
		var t = Timer.new()
		t.one_shot = true
		
		_n.add_child(t)
		
		
		var f = func():
			if randf() < _DOUBLE_STRIKE_PERCENTAGE:
				await _double_strike()
			else:
				await _single_strike()
			t.start(randf_range(1, 5) / _FREQUENCY)
		
		t.timeout.connect(f)
		t.start(1.0 / _FREQUENCY)


func _ready():
	color = _COLORS[mode]
	
	_libevent.E.new(func(): _Lightning.new(self).payload()).execute()
