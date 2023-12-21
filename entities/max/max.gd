extends Node2D

@onready var _p = $Poseable

func _input(event):
    if event.is_action_pressed("ui_right"):
        _p.set_state(_p.Pose.WALK, _p.Face.EAST)
    if event.is_action_pressed("ui_left"):
        _p.set_state(_p.Pose.WALK, _p.Face.WEST)
    if event.is_action_pressed("ui_up"):
        _p.set_state(_p.Pose.WALK, _p.Face.NORTH)
    if event.is_action_pressed("ui_down"):
        _p.set_state(_p.Pose.WALK, _p.Face.SOUTH)
    if event.is_action_released("ui_right") or event.is_action_released("ui_left") or event.is_action_released("ui_up") or event.is_action_released("ui_down"):
        _p.set_state(_p.Pose.IDLE)
