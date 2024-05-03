extends TileMap

const _libobstacle = preload('res://lib/obstacle.gd')

@export var debug: bool = false

var _obstacles: _libobstacle.Obstacle


func query(v: Vector2i) -> bool:
	return _obstacles.query(v)


func _ready():
	visible = debug
	
	var o = {}
	
	for t in get_used_cells(0):
		print("tile = %s, atlas_coords = %s" % [t, get_cell_atlas_coords(0, t)])
		o[t] = true
	
	_obstacles = _libobstacle.Obstacle.new(o)
