extends Character


func _ready():
	super()

	$Controllable.input_north.connect(func(): path_queue.enqueue(_libgeo.Orientation.N))
	$Controllable.input_south.connect(func(): path_queue.enqueue(_libgeo.Orientation.S))
	$Controllable.input_east.connect(func(): path_queue.enqueue(_libgeo.Orientation.E))
	$Controllable.input_west.connect(func(): path_queue.enqueue(_libgeo.Orientation.W))

func _process(_delta):
	super(_delta)
