extends Dialog

@export var display_offset: int


func _eof_reached_handler(id: String):
	return eof_reached_handler_base(id)


func set_display_offset(o: int):
	display_offset = o
	position.y = display_offset * 16


func set_dialog(l: _libdialog.Line):
	set_display_offset(display_offset)
	super(l)


func _ready():
	super()
	SignalBus.eof_reached.connect(_eof_reached_handler)
