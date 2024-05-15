extends Node2D

const _libscript = preload('res://lib/script.gd')
const _libgeo = preload('res://lib/geo.gd')
const _libcontroller = preload('res://lib/controller.gd')
const _libevent = preload('res://lib/event.gd')


# Dialog lines that will fire due to the event signal being triggered.
@onready var _EVENT_TRIGGERS = {}


func _eof_reached_handler(lid: String):
	SignalBus.event_triggered.emit(lid)


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
			_libevent.DialogEvent.new(_libscript.SCRIPT['0'], $Map/Characters/Max/Dialog, 'EOF_0'),
		],
		'EOF_0': [
			_libevent.DialogEvent.new(_libscript.SCRIPT['1'], $Map/Characters/Max/Dialog, 'EOF_1'),
		],
		'EOF_1': [
			_libevent.DialogEvent.new(_libscript.SCRIPT['DEBUG'], $Dialog),
		],
	}
	
	# TODO(minkezhang): Set default controller config to MENU.
	SignalBus.enable_controller_mode_requested.emit(
		_libcontroller.ControllerMode.MOVE
	)
	
	SignalBus.eof_reached.connect(_eof_reached_handler)
	SignalBus.event_triggered.connect(_event_triggered_handler)
	
	SignalBus.event_triggered.emit('SCENE_START')


func _process(_delta):
	$Camera.global_position = $Map/Characters/Max.global_position
	$Dialog.position = $Camera.position
