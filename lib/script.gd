# TODO(minkezhang): Remove extraneous class_name declaration in Godot v4.3. See
# https://github.com/godotengine/godot/issues/86032 for more information.
class_name _LibScript
extends Object
## Script for the LIS demo.
##
## Pulled from https://life-is-strange.fandom.com/wiki/Episode_1:_Chrysalis_-_Script.

const _libdialog = preload('res://lib/dialog.gd')


static var _L = [
	_libdialog.Line.new(
		'NULL:MAX:LOREMIPSUM',
		_libdialog.C.MAX,
		[
			'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do ' +
			'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ' +
			'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ' +
			'aliquip ex ea commodo consequat. Duis aute irure dolor in ' +
			'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla ' +
			'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in ' +
			'culpa qui officia deserunt mollit anim id est laborum.',
		],
	),
	
	# Forest
	_libdialog.Line.new('FOREST:MAX:00', _libdialog.C.MAX, [
		'Where am I? What\'s happening?',
		'I\'m trapped in a storm? How did I get here? ...And where is "here"?',
	]),
	_libdialog.Line.new('FOREST:MAX:01', _libdialog.C.MAX, [
		'Wait...',
		'There\'s the lighthouse...',
		'I\'ll be safe if I can make it there...',
		'I hope...',
		'Please let me make it there...',
	]),
	_libdialog.Line.new('FOREST:MAX:02', _libdialog.C.MAX, [
		'Holy shit.',
	]),
	_libdialog.Line.new('FOREST:MAX:03', _libdialog.C.MAX, [
		'Whoa! No!',
	]),
	
	# Classroom
	_libdialog.Line.new('CLASSROOM:MAX:00', _libdialog.C.MAX, [
		'Whoa! That was so surreal.',
	]),
	_libdialog.Line.new('CLASSROOM:MAX:01', _libdialog.C.JEFFERSON, [
		'Alfred Hitchcock famously called film, "little pieces of time",
		 but he could be talking about photography, as he likely was.'
	]),
	_libdialog.Line.new('CLASSROOM:MAX:02', _libdialog.C.MAX, [
		'Everything\'s cool... I\'m okay...',
	]),
	
	# Hallway
	# Bathroom
]

static var SCRIPT = _LibScript.generate_script(_L)


static func generate_script(ls):
	var s = {}
	for l in ls:
		s[l.id()] = l
	return s
