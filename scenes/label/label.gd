extends Label

const _libdialog = preload('res://lib/dialog.gd')

@export var line_length: int = 0
@export var n_lines: int = 0
@export var auto_advance_ms: float = 0

var _line: _libdialog.LineReader
var _lid: String
var _t: Timer


func _ready():
	if auto_advance_ms > 0:
		_t = Timer.new()
		_t.timeout.connect(advance_dialog_text)  # _t.one_shot is false by default
		_t.wait_time = auto_advance_ms / 1000
		add_child(_t)



# set_dialog queues up a script block for display in the Label.text field. The
# Line.uuid() is passed along to the SignalBus.eof_reached signal to indicate
# which line has been completed.
func set_dialog(l: _libdialog.Line):
	_lid = l.uuid()
	_line = _libdialog.LineReader.new(l, line_length, n_lines)
	
	if _t != null:
		_t.start()
	advance_dialog_text()


func advance_dialog_text():
	if _line == null:
		if _t != null:
			_t.stop()
	elif _line.eof():
		if _t != null:
			_t.stop()
		SignalBus.eof_reached.emit(_lid)
	else:
		text = _line.get_next_line()
