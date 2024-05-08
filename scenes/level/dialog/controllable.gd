extends Node

signal input_advance_text()

func _process(_delta):
		if Input.is_action_just_pressed('ui_accept'):
			input_advance_text.emit()
