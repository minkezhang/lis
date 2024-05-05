extends Node2D

const _libdialog = preload('res://lib/dialog.gd')
const _liblines = preload('res://lib/lines.gd')

const _SPRITE_LOOKUP = {
	_libdialog.C.MAX: Rect2(Vector2(0, 0), Vector2(32, 64)),
}


func set_dialog(l: _libdialog.Line):
	$Frame.set_region_rect(_SPRITE_LOOKUP[l.c()])
	$Label.text = l.ls()[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
