extends Node2D
class_name Dialog

const _libdialog = preload('res://lib/dialog.gd')

@export var label: Label

var _lid: String


# Implementations of the Dialog class will need to connect to this handler.
func _eof_reached_handler(lid: String):
	if lid == _lid:
		visible = false


func set_dialog(l: _libdialog.Line):
	visible = true
	_lid = l.uuid()
	$Label.set_dialog(l)


func _ready():
	assert(label != null, 'Property label must be non-null')
	visible = false
