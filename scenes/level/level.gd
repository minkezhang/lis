extends Node2D

const _libscript = preload('res://lib/script.gd')
const _libgeo = preload('res://lib/geo.gd')
const _libcontroller = preload('res://lib/controller.gd')
const _libevent = preload('res://lib/event.gd')


# Dialog lines that will fire due to the event signal being triggered.
@onready var _EVENT_TRIGGERS = {}


func _target_reached_handler(c: Character, p: Vector2i):
	if c == $Map/Characters/Max:
		if p == Vector2i(38, 27):
			SignalBus.event_triggered.emit('TARGET:{c}:{p}')


func _eof_reached_handler(lid: String):
	SignalBus.event_triggered.emit('EOF:{l}'.format({'l': lid}))


func _event_triggered_handler(eid: String):
	if eid in _EVENT_TRIGGERS:
		for e in _EVENT_TRIGGERS[eid]:
			if e.is_ready():
				e.execute()


func _ready():
	# GBA resolution is 260 x 160, which is a 15 x 10 grid of tiles.
	DisplayServer.window_set_size(Vector2i(
		15 * _libgeo.GRID_DIMENSION * $Camera.zoom.x,
		10 * _libgeo.GRID_DIMENSION * $Camera.zoom.y,
	))
	
	_EVENT_TRIGGERS = {
		'SCENE_START': [
			_libevent.DialogEvent.new(_libscript.SCRIPT['FOREST:MAX:00'], $Dialog, 'FOREST:MAX:00'),
		],
		'EOF:FOREST:MAX:00': [
			_libevent.DialogEvent.new(_libscript.SCRIPT['FOREST:MAX:01'], $Dialog, 'FOREST:MAX:01'),
		],
		'EOF:FOREST:MAX:01': [
			_libevent.DialogEvent.new(_libscript.SCRIPT['NULL:MAX:LOREMIPSUM'], $Map/Characters/Max/Dialog),
		],
	}
	
	# TODO(minkezhang): Set default controller config to MENU.
	SignalBus.enable_controller_mode_requested.emit(
		_libcontroller.ControllerMode.MOVE
	)
	
	SignalBus.eof_reached.connect(_eof_reached_handler)
	SignalBus.event_triggered.connect(_event_triggered_handler)
	SignalBus.target_reached.connect(_target_reached_handler)
	
	SignalBus.event_triggered.emit('SCENE_START')


func _process(_delta):
	$Camera.global_position = $Map/Characters/Max.global_position
	$Dialog.position = $Camera.position
