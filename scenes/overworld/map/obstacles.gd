extends TileMap

const _libobstacle = preload('res://lib/obstacle.gd')

var _obstacles: _libobstacle.Obstacle


func query(v: Vector2i) -> bool:
	return _obstacles.query(v)


func _ready():
	var o = {}
	
	for t in get_used_cells(0):
		o[t] = true
	
	_obstacles = _libobstacle.Obstacle.new(o)
