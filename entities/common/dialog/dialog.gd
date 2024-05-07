extends Node2D

const _libdialog = preload('res://lib/dialog.gd')

@export var display_offset: int


func _eof_reached_handler():
	visible = false


func set_display_offset(o: int):
	display_offset = o
	position.y = display_offset * 16


func set_dialog(l: _libdialog.Line):
	set_display_offset(display_offset)
	visible = true
	$Label.set_dialog(l)


func _ready():
	visible = false
	$Label.eof_reached.connect(_eof_reached_handler)
