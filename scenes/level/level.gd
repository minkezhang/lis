extends Node2D

const _libscript = preload('res://lib/script.gd')
const _libgeo = preload('res://lib/geo.gd')
const _libcontroller = preload('res://lib/controller.gd')
const _libevent = preload('res://lib/event.gd')


var _EVENT_TRIGGERED_HANDLER_LOOKUP = {}
var _TARGET_REACHED_HANDLER_LOOKUP = {}


func _target_reached_handler(c: Character, p: Vector2i):
	if [c, p] in _TARGET_REACHED_HANDLER_LOOKUP:
		for eid in _TARGET_REACHED_HANDLER_LOOKUP[[c, p]]:
			SignalBus.event_triggered.emit(eid)


func _event_triggered_handler(eid: String):
	print("DEBUG(level.gd): _event_triggered_handler(eid: {eid})".format({'eid': eid}))
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
			_libevent.Event.new(func(): SignalBus.signal_handlers_installed.emit()),
		],
		'START_TIMER': [
			_libevent.TimerEvent.new(self, 5.0).chain(
				_libevent.EmitEvent.new('START_DIALOG'),
			),
		],
		'START_DIALOG': [
			_libevent.DialogEvent.new(
				_libscript.SCRIPT['FOREST:MAX:00'],
				$Dialog,
			).chain(
				# TODO(minkezhang): Set default controller config to MENU.
				_libevent.Event.new(
					func(): SignalBus.enable_controller_mode_requested.emit(
						_libcontroller.ControllerMode.MOVE
					)
				),
			).chain(
				_libevent.EmitEvent.new('EOF:FOREST:MAX:00'),
			),
		],
		'EOF:FOREST:MAX:00': [
			_libevent.DialogEvent.new(
				_libscript.SCRIPT['FOREST:MAX:01'],
				$Map/Characters/Max/Dialog,
			),
		],
	}
	
	$Map/Characters/Max.speed = 10
	
	SignalBus.event_triggered.connect(_event_triggered_handler)
	SignalBus.target_reached.connect(_target_reached_handler)
	
	SignalBus.event_triggered.emit('LEVEL_LOADED')


func _process(_delta):
	$Camera.global_position = $Map/Characters/Max.global_position
	$Dialog.position = $Camera.position
	$Debug.position = $Camera.position + Vector2(64, -56)
