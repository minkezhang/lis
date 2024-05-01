extends TileMap

const _libobstacle = preload('res://lib/obstacle.gd')

const _OBSTACLE_METADATA_LAYER_NAME: String = "IsObstacle"

var _obstacles: _libobstacle.Obstacle


func query(v: Vector2i) -> bool:
	return _obstacles.query(v)


func _ready():
	var o = {}
	
	$Obstacles.clear()
	for l in range(get_layers_count()):
		for t in get_used_cells(l):
			if get_cell_tile_data(l, t).get_custom_data(_OBSTACLE_METADATA_LAYER_NAME):
				o[t] = true
				$Obstacles.set_cell(0, t, 0, Vector2i(1, 0))
	
	_obstacles = _libobstacle.Obstacle.new(o)
