extends Character


func _ready():
	super()
	
	SignalBus.input_move_requested.connect(
		func(o: _libgeo.Orientation): path_queue.enqueue(o)
	)
	
	SignalBus.input_interact_requested.connect(
		func(): SignalBus.interact_requested.emit(
			self,
			_global_grid_position() + Vector2i(
				_libgeo.ORIENTATION_RAY[_p.get_state().orientation]
			)
		)
	)
