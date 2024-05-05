extends Node2D

const _libdialog = preload('res://lib/dialog.gd')
const _liblines = preload('res://lib/lines.gd')

const _SPRITE_LOOKUP = {
	_libdialog.C.MAX: Rect2(Vector2(0, 0), Vector2(32, 64)),
}


var _line: _libdialog.Line


func set_dialog(l: _libdialog.Line):
	_line = l
	$Frame.set_region_rect(_SPRITE_LOOKUP[l.character()])
	advance_dialog_text()


func advance_dialog_text():
	visible = not _line.eof()
	$Label.text = _line.get_next_line()


func _ready():
	visible = true
	$Controllable.input_advance_text.connect(advance_dialog_text)
