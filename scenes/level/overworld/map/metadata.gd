extends TileMapLayer

const _libinteractionmap = preload('res://lib/interaction_map.gd')

@export var debug: bool = false

var map: _libinteractionmap.InteractionMap


func _ready():
	visible = debug
	
	var o = {}
	
	for t in get_used_cells():
		o[t] = true
	
	map = _libinteractionmap.InteractionMap.new(o)
