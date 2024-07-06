extends Object

const _libgeo = preload('res://lib/geo.gd')

enum ControllerMode { NULL, MOVE, DIALOG, DEBUG }
enum ControllerInputType { UP, DOWN, LEFT, RIGHT, SPACE }
enum ControllerInputAction { PRESSED, RELEASED }

const CONTORLLER_CONFIG_LOOKUP = {
	ControllerMode.NULL: NullControllerConfig,
	ControllerMode.MOVE: MoveControllerConfig,
	ControllerMode.DIALOG: DialogControllerConfig,
}


class NullControllerConfig:
	func mode() -> ControllerMode:
		return ControllerMode.NULL
	func n_handler(_m: ControllerInputAction):
		pass
	func e_handler(_m: ControllerInputAction):
		pass
	func s_handler(_m: ControllerInputAction):
		pass
	func w_handler(_m: ControllerInputAction):
		pass
	func accept_handler(_m: ControllerInputAction):
		pass


class DebugControllerConfig extends NullControllerConfig:
	func mode() -> ControllerMode:
		return ControllerMode.NULL
	
	func n_handler(m: ControllerInputAction):
		SignalBus.debug_input_detected.emit(m, ControllerInputType.UP)
	
	func e_handler(m: ControllerInputAction):
		SignalBus.debug_input_detected.emit(m, ControllerInputType.RIGHT)
	
	func s_handler(m: ControllerInputAction):
		SignalBus.debug_input_detected.emit(m, ControllerInputType.DOWN)
	
	func w_handler(m: ControllerInputAction):
		SignalBus.debug_input_detected.emit(m, ControllerInputType.LEFT)
	
	func accept_handler(m: ControllerInputAction):
		SignalBus.debug_input_detected.emit(m, ControllerInputType.SPACE)


class MoveControllerConfig extends NullControllerConfig:
	func mode():
		return ControllerMode.MOVE
	
	func n_handler(m: ControllerInputAction):
		if m == ControllerInputAction.PRESSED:
			SignalBus.input_move_requested.emit(_libgeo.Orientation.N)
	
	func e_handler(m: ControllerInputAction):
		if m == ControllerInputAction.PRESSED:
			SignalBus.input_move_requested.emit(_libgeo.Orientation.E)
	
	func s_handler(m: ControllerInputAction):
		if m == ControllerInputAction.PRESSED:
			SignalBus.input_move_requested.emit(_libgeo.Orientation.S)
	
	func w_handler(m: ControllerInputAction):
		if m == ControllerInputAction.PRESSED:
			SignalBus.input_move_requested.emit(_libgeo.Orientation.W)
	
	func accept_handler(m: ControllerInputAction):
		if m == ControllerInputAction.PRESSED:
			SignalBus.input_interact_requested.emit()


class DialogControllerConfig extends NullControllerConfig:
	func mode():
		return ControllerMode.DIALOG
	
	func accept_handler(m: ControllerInputAction):
		if m == ControllerInputAction.PRESSED:
			SignalBus.input_advance_dialog_requested.emit()
