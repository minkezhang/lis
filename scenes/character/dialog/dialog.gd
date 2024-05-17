extends Dialog

@export var display_offset: int


func set_display_offset(o: int):
	display_offset = o
	position.y = display_offset * 16


func set_dialog(l: _libdialog.Line):
	super(l)
	
	set_display_offset(display_offset)


func _ready():
	super()
	
	SignalBus.eof_reached.connect(_eof_reached_handler)
