extends Character


func _ready():
	super()
	
	$Controllable.input_move.connect(
		func(o: _libgeo.Orientation): path_queue.enqueue(o)
	)
