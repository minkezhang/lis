extends Label

const _libdialog = preload('res://lib/dialog.gd')
const _librand = preload('res://lib/rand.gd')

@export var line_length: int = 0
@export var n_lines: int = 0
@export var auto_advance_ms: float = 0

var _line: _libdialog.LineReader
var _line_key: String
var _t: Timer

const _KEY_LENGTH: int = 16

func line_id() -> String:
	if not _line:
		return ""
	return _line_key if _line_key else _line.id()


func _ready():
	if auto_advance_ms > 0:
		_t = Timer.new()
		add_child(_t)


# set_dialog queues up a script block for display in the Label.text field. The
# key arg here is passed along to the SignalBus.eof_reached signal to indicate
# which line has been completed. This key is decoupled from Line.id() as
# multiple dialog boxes may (for whatever reason) queue the same script block.
func set_dialog(l: _libdialog.Line, key: String = ''):
	_line_key = key if key else _librand.randstring(_KEY_LENGTH)
	_line = _libdialog.LineReader.new(l, line_length, n_lines)
	if _t != null:
		_t.timeout.connect(advance_dialog_text)  # _t.one_shot is false by default
		_t.start(auto_advance_ms / 1000)
	advance_dialog_text()


func advance_dialog_text():

	if _line.eof():
		SignalBus.eof_reached.emit(line_id())
		if _t != null:
			_t.stop()
			_t.timeout.disconnect(advance_dialog_text)
		return
	text = _line.get_next_line()
