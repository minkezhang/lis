extends Dialog

const _libcontroller = preload('res://lib/controller.gd')

const _SPRITE_LOOKUP = {
	_libdialog.C.MAX: Rect2(Vector2(0, 0), Vector2(32, 64)),
}


func _eof_reached_handler(lid: String):
	super(lid)
	
	if lid == _lid:
		SignalBus.disable_controller_mode_requested.emit(
			_libcontroller.ControllerMode.DIALOG,
		)


func set_dialog(l: _libdialog.Line):
	super(l)
	
	$Frame.set_region_rect(_SPRITE_LOOKUP[l.character()])
	SignalBus.enable_controller_mode_requested.emit(
		_libcontroller.ControllerMode.DIALOG,
	)


func _ready():
	super()
	
	SignalBus.input_advance_dialog_requested.connect($Label.advance_dialog_text)
	SignalBus.eof_reached.connect(_eof_reached_handler)
