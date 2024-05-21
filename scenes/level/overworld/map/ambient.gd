extends ColorRect

@export var mode: Mode

enum Mode { NEUTRAL, SUNLIGHT, STORM }
const _COLORS = {
	Mode.STORM: Color(0x30115930),
	Mode.NEUTRAL: Color(0xffffff00),
	Mode.SUNLIGHT: Color(0xd4b13530),
}


func _ready():
	# This spans the entire screen, not just the viewport.
	size = get_tree().get_root().size
	color = _COLORS[mode]
