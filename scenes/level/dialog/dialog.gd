extends Dialog

const _libcontroller = preload('res://lib/controller.gd')

const _SPRITE_LOOKUP = {
	_libdialog.C.MAX: Rect2(Vector2(0, 0), Vector2(32, 64)),
}


func _eof_reached_handler(id: String):
	eof_reached_handler_base(id)
	
	if id == $Label.line_id():
		SignalBus.advance_dialog_requested.disconnect($Label.advance_dialog_text)
		SignalBus.disable_controller_mode_requested.emit(
			_libcontroller.ControllerMode.DIALOG,
		)


func set_dialog(l: _libdialog.Line):
	super(l)

	$Frame.set_region_rect(_SPRITE_LOOKUP[l.character()])
	SignalBus.advance_dialog_requested.connect($Label.advance_dialog_text)
	SignalBus.enable_controller_mode_requested.emit(
		_libcontroller.ControllerMode.DIALOG,
	)


func _ready():
	super()
	
	SignalBus.eof_reached.connect(_eof_reached_handler)
