extends Node2D

@export var display_offset: int


func set_display_offset(o: int):
	display_offset = o
	position.y = display_offset * 16


func _ready():
	set_display_offset(display_offset)
