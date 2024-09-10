extends Node2D

const _libscript = preload('res://lib/script.gd')
const _libgeo = preload('res://lib/geo.gd')
const _libcontroller = preload('res://lib/controller.gd')
const _libevent = preload('res://lib/event/event.gd')
const _libworkload = preload('res://lib/event/workload.gd')

var _EVENT_TRIGGERED_HANDLER_LOOKUP = {}
var _TARGET_REACHED_HANDLER_LOOKUP = {}


func _target_reached_handler(c: Character, p: Vector2i):
	if [c, p] in _TARGET_REACHED_HANDLER_LOOKUP:
		for eid in _TARGET_REACHED_HANDLER_LOOKUP[[c, p]]:
			SignalBus.event_triggered.emit(eid)


func _event_triggered_handler(eid: String):
	if eid not in _EVENT_TRIGGERED_HANDLER_LOOKUP:
		push_warning('unhandled event ID: {eid}'.format({
			'eid': eid,
		}))
		return
	for e in _EVENT_TRIGGERED_HANDLER_LOOKUP[eid]:
		e.execute()


func _ready():
	# GBA resolution is 260 x 160, which is a 15 x 10 grid of tiles.
	DisplayServer.window_set_size(Vector2i(
		15 * _libgeo.GRID_DIMENSION * $Camera.zoom.x,
		10 * _libgeo.GRID_DIMENSION * $Camera.zoom.y,
	))
	
	_TARGET_REACHED_HANDLER_LOOKUP = {
		[$Map/Characters/Max, Vector2i(38, 27)]: [
			'START_TIMER',
		],
	}
	
	_EVENT_TRIGGERED_HANDLER_LOOKUP = {
		'LEVEL_LOADED': [
			_libevent.E.new(
				func(): SignalBus.signal_handlers_installed.emit(),
			),
		],
		'START_TIMER': [
			_libevent.E.new(_libworkload.Timer(self, 1.0), true).chain(
				_libevent.E.new(_libworkload.EventEmitter('START_DIALOG')),
			),
		],
		'START_DIALOG': [
			_libevent.E.new(_libworkload.DialogRenderer(
				$Dialog,
				_libscript.SCRIPT['FOREST:MAX:00'],
			)).chain(_libevent.E.new(
				func(): SignalBus.enable_controller_mode_requested.emit(
						_libcontroller.ControllerMode.MOVE,
				),
			)).chain(_libevent.E.new(_libworkload.Timer(self, 1.0)
			)).chain(_libevent.E.new(_libworkload.EventEmitter('EOF:FOREST:MAX:00'))
			),
		],
		'EOF:FOREST:MAX:00': [
			_libevent.E.new(_libworkload.DialogRenderer(
				$Map/Characters/Max/Dialog,
				_libscript.SCRIPT['FOREST:MAX:01'],
			)),
		],
	}
	
	$Map/Metadata/Events/Interactions.events = {
		Vector2i(38, 24): _libevent.E.new(_libworkload.DialogRenderer(
			$Dialog,
			_libscript.SCRIPT['FOREST:SIGN:00'],
		)),
		Vector2i(13, 9): null,
		Vector2i(12, 2): null,
		Vector2i(12, 3): null,
	}
	
	$Map/Characters/Max.speed = 2
	
	SignalBus.event_triggered.connect(_event_triggered_handler)
	SignalBus.target_reached.connect(_target_reached_handler)
	
	SignalBus.event_triggered.emit('LEVEL_LOADED')


func _process(_delta):
	$Camera.global_position = $Map/Characters/Max.global_position
	$Dialog.position = $Camera.position
	$Debug.position = $Camera.position + Vector2(64, -56)
	$Map/Environment/Ambient.size = DisplayServer.window_get_size()
	$Map/Environment/Ambient.position = $Camera.position - ($Map/Environment/Ambient.size / 2)
