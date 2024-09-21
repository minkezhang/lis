extends Node2D

const _libsplash = preload('res://lib/splash.gd')
const _libcontroller = preload('res://lib/controller.gd')


var _tid: String
var _splash: _libsplash.Splash

# Implementations of the Dialog class will need to connect to this handler.
func _eof_reached_handler(tid: String):
	if _tid == tid:
		visible = false
	
	SignalBus.disable_controller_mode_requested.emit(
			_libcontroller.ControllerMode.DIALOG,
	)


func set_splash(s: _libsplash.Splash):
	_tid = s.uuid()
	_splash = s
	$Label.set_texture(_splash.texture())
	SignalBus.enable_controller_mode_requested.emit(
		_libcontroller.ControllerMode.DIALOG,
	)
	visible = true


func advance_splash():
	if _splash == null:
		return
	
	if _splash.eof():
		_tid = ""
		_splash = null
		
		visible = false
		SignalBus.eof_reached.emit(_tid)


func _ready():
	visible = false
	$Label.centered = true
	
	SignalBus.input_advance_dialog_requested.connect(advance_splash)
	SignalBus.eof_reached.connect(_eof_reached_handler)
