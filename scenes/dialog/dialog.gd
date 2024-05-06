extends Node2D

const _libdialog = preload('res://lib/dialog.gd')

const _SPRITE_LOOKUP = {
	_libdialog.C.MAX: Rect2(Vector2(0, 0), Vector2(32, 64)),
}


func _handle_eof():
	visible = false
	$Controllable.input_advance_text.disconnect(advance_dialog_text)


func set_dialog(l: _libdialog.Line):
	visible = true
	$Controllable.input_advance_text.connect(advance_dialog_text)
	
	$Frame.set_region_rect(_SPRITE_LOOKUP[l.character()])
	$Label.set_dialog(l)


func advance_dialog_text():
	$Label.advance_dialog_text()


func _ready():
	visible = false
	$Label.eof.connect(_handle_eof)
