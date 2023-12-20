extends Node2D

@onready var _a = $AnimationLibrary
var _face = "south"
var _state = "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
    _a.play("idle_south")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("ui_right"):
        _face = "east"
        _state = "walk"
    elif Input.is_action_pressed("ui_left"):
        _face = "west"
        _state = "walk"
    elif Input.is_action_pressed("ui_up"):
        _face = "north"
        _state = "walk"
    elif Input.is_action_pressed("ui_down"):
        _face = "south"
        _state = "walk"
    elif Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
        _state = "idle"

    if _face == "east":
        _a.flip_h = true
    else:
        _a.flip_h = false
    
    var _f = _face
    if _face == "east":
        _f = "west"
    
    _a.play("%s_%s" % [_state, _f])
