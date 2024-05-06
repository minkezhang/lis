extends Node2D

const _libdialog = preload('res://lib/dialog.gd')
const _liblines = preload('res://lib/lines.gd')

@export var display_offset: int

const _LINE_LENGTH: int = 20

var _line: _libdialog.LineReader


func set_display_offset(o: int):
	display_offset = o
	position.y = display_offset * 16


func set_dialog(l: _libdialog.Line):
	_line = _libdialog.LineReader.new(l, _LINE_LENGTH)
	advance_dialog_text()


func advance_dialog_text():
	visible = not _line.eof()
	$Label.text = _line.get_next_line()


func _ready():
	set_display_offset(display_offset)
