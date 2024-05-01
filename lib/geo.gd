extends Object

enum Orientation { N, S, E, W }

# Global constant representing the tile dimension. Notably, all sprites must be
# scaled to this dimension.
const GRID_DIMENSION = 16

const ORIENTATION_RAY = {
	Orientation.N: Vector2.UP,
	Orientation.S: Vector2.DOWN,
	Orientation.E: Vector2.RIGHT,
	Orientation.W: Vector2.LEFT,
}

class GeoPosition:
	var _grid_center_offset: Vector2
	var _grid_dimension: int
	
	func _init(c: Vector2i, d: int):
		_grid_center_offset = c
		_grid_dimension = d
	
	func to_grid(w: Vector2) -> Vector2i:
		return (Vector2i(w + _grid_center_offset)) / _grid_dimension
		
	func to_world(g: Vector2i) -> Vector2:
		return Vector2(g) * _grid_dimension - _grid_center_offset
