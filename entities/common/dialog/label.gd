extends Label

const _libdialog = preload('res://lib/dialog.gd')

signal eof

@export var LINE_LENGTH: int = 0

var _line: _libdialog.LineReader


func set_dialog(l: _libdialog.Line):
	_line = _libdialog.LineReader.new(l, LINE_LENGTH)
	advance_dialog_text()


func advance_dialog_text():
	if _line.eof():
		eof.emit()
		return
	text = _line.get_next_line()
	print(text)
