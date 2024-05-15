extends Object

const _libid = preload('res://lib/id.gd')

class Event extends _libid.ID:
	pass

class DialogEvent extends Event:
	var _dialog_id: String
	var _node: Node
	var _eid: String
	
	func _init(d: String, n: Node, e: String = ''):
		_dialog_id = d
		_node = n
		_eid = e
	
	func dialog_id() -> String:
		return _dialog_id
	
	func node() -> Node:
		return _node
	
	func eid() -> String:
		return _eid
