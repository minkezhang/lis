extends Obstacles

var events: Dictionary = {}

func _ready():
	super()
	
	await SignalBus.signal_handlers_installed
	
	for t in get_used_cells():
		assert(events.has(t), 'event set in Scene object but does not exist in lookup: %s' % [t])
