extends Character


func _ready():
	super()
	
	SignalBus.move_requested.connect(
		func(o: _libgeo.Orientation): path_queue.enqueue(o)
	)
