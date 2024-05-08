extends Node2D
class_name Dialog

const _libdialog = preload('res://lib/dialog.gd')

@export var label: Label


# Implementations of the Dialog class will need to connect to this handler.
func eof_reached_handler_base(id: String):
	if id == label.line_id():
		visible = false


func set_dialog(l: _libdialog.Line):
	visible = true
	$Label.set_dialog(l)


func _ready():
	assert(label != null, 'Property label must be non-null')
	visible = false
