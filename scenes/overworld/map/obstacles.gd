extends TileMap

const _libobstacle = preload('res://lib/obstacle.gd')

@export var debug: bool = false

var obstacles: _libobstacle.Obstacle


func _ready():
	visible = debug
	
	var o = {}
	
	for t in get_used_cells(0):
		o[t] = true
	
	obstacles = _libobstacle.Obstacle.new(o)
