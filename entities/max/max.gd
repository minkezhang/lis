extends Character


func _ready():
	super()
	
	$Controllable.input_move.connect(
		func(o: _libgeo.Orientation): SignalBus.request_move.emit(self, o)
	)
