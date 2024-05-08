extends Label

const _libdialog = preload('res://lib/dialog.gd')

@export var line_length: int = 0
@export var n_lines: int = 0
@export var auto_advance_ms: float = 0

var _line: _libdialog.LineReader
var _t: Timer


func line_id() -> String:
	return _line.id()


func _ready():
	if auto_advance_ms > 0:
		_t = Timer.new()
		add_child(_t)


func set_dialog(l: _libdialog.Line):
	_line = _libdialog.LineReader.new(l, line_length, n_lines)
	advance_dialog_text()
	if _t != null:
		_t.timeout.connect(advance_dialog_text)  # _t.one_shot is false by default
		_t.start(auto_advance_ms / 1000)


func advance_dialog_text():
	if _line.eof():
		SignalBus.eof_reached.emit(_line.id())
		if _t != null:
			_t.stop()
			_t.timeout.disconnect(advance_dialog_text)
		return
	text = _line.get_next_line()
