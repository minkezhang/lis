extends TileMapLayer

class_name Obstacles

const _liblookupmap = preload('res://lib/lookup_map.gd')

@export var debug: bool = false

var lookup: _liblookupmap.LookupMap


func _ready():
	visible = debug
	
	var o = []
	
	for t in get_used_cells():
		o.append(t)
	
	lookup = _liblookupmap.LookupMap.new(o)
