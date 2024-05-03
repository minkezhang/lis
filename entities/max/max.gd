extends Character


func _ready():
	super()
	
	$Controllable.input_move.connect(
		func(o: _libgeo.Orientation): SignalBus.move_requested.emit(self, o)
	)
