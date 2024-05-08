extends Dialog

const _SPRITE_LOOKUP = {
	_libdialog.C.MAX: Rect2(Vector2(0, 0), Vector2(32, 64)),
}


func _eof_reached_handler(id: String):
	eof_reached_handler_base(id)
	if id == $Label.line_id():
		$Controllable.input_advance_text.disconnect($Label.advance_dialog_text)


func set_dialog(l: _libdialog.Line):
	super(l)
	
	$Controllable.input_advance_text.connect($Label.advance_dialog_text)
	$Frame.set_region_rect(_SPRITE_LOOKUP[l.character()])


func _ready():
	super()
	
	SignalBus.eof_reached.connect(_eof_reached_handler)
