extends Object

const _libgeo = preload('res://lib/geo.gd')

enum ControllerMode { NULL, MOVE, DIALOG }

const CONTORLLER_CONFIG_LOOKUP = {
	ControllerMode.NULL: NullControllerConfig,
	ControllerMode.MOVE: MoveControllerConfig,
	ControllerMode.DIALOG: DialogControllerConfig,
}


class NullControllerConfig:
	func mode() -> ControllerMode:
		return ControllerMode.NULL
	func n_handler():
		pass
	func e_handler():
		pass
	func s_handler():
		pass
	func w_handler():
		pass
	func accept_handler():
		pass


class MoveControllerConfig extends NullControllerConfig:
	func mode():
		return ControllerMode.MOVE
	func n_handler():
		SignalBus.move_requested.emit(_libgeo.Orientation.N)
	func e_handler():
		SignalBus.move_requested.emit(_libgeo.Orientation.E)
	func s_handler():
		SignalBus.move_requested.emit(_libgeo.Orientation.S)
	func w_handler():
		SignalBus.move_requested.emit(_libgeo.Orientation.W)


class DialogControllerConfig extends NullControllerConfig:
	func mode():
		return ControllerMode.DIALOG
	func accept_handler():
		SignalBus.dialog_accept_requested.emit()
