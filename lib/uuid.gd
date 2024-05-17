extends Object
# TODO(minkezhang): Remove extraneous class_name declaration in Godot v4.3. See
# https://github.com/godotengine/godot/issues/86032 for more information.
class_name _LibID

const _librand = preload('res://lib/rand.gd')


static func uuid() -> String:
	return '-'.join([
		_librand.randstring(8),
		_librand.randstring(8),
		_librand.randstring(8),
		_librand.randstring(8),
	])


class UUID extends Object:
	var _x: String
	
	func _init():
		_x = _LibID.uuid()
	
	func uuid() -> String:
		return _x
