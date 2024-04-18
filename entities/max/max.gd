extends Node2D

const _libgeo = preload('res://lib/geo.gd')


func _ready():
	$Controllable.input_north.connect(func(): $Character.path_queue.enqueue(_libgeo.Orientation.N))
	$Controllable.input_south.connect(func(): $Character.path_queue.enqueue(_libgeo.Orientation.S))
	$Controllable.input_east.connect(func(): $Character.path_queue.enqueue(_libgeo.Orientation.E))
	$Controllable.input_west.connect(func(): $Character.path_queue.enqueue(_libgeo.Orientation.W))
