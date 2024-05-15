extends Object

const _libid = preload('res://lib/id.gd')
const _libdialog = preload('res://lib/dialog.gd')


class Event extends _libid.ID:
	func is_ready() -> bool:
		assert(false, "unimplemented Event is_ready function")
		return false
	
	func execute():
		assert(false, "unimplemented Event execute function")


class DialogEvent extends Event:
	var _l: _libdialog.Line
	var _n: Node
	var _eid: String
	
	func _init(l: _libdialog.Line, n: Node, e: String = ''):
		_l = l
		_n = n
		_eid = e
	
	func is_ready() -> bool:
		return true
	
	func execute():
		_n.set_dialog(_l, _eid)
