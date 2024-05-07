extends Object

const _libdialog = preload('res://lib/dialog.gd')

static var L = {
	'DEBUG': _libdialog.Line.new(_libdialog.C.MAX, [
		'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
	]),
	
	# Forest
	'0': _libdialog.Line.new(_libdialog.C.MAX, [
		'Where am I? What\'s happening?',
		'I\'m trapped in a storm? How did I get here? ...And where is "here"?'
	]),
	'1': _libdialog.Line.new(_libdialog.C.MAX, [
		'Holy shit.',
	]),
	'2': _libdialog.Line.new(_libdialog.C.MAX, [
		'Whoa! No!',
	]),
	
	# Classroom
	'3': _libdialog.Line.new(_libdialog.C.MAX, [
		'Whoa! That was so surreal.',
	]),
	'4': _libdialog.Line.new(_libdialog.C.JEFFERSON, [
		'Alfred Hitchcock famously called film, "little pieces of time",
		 but he could be talking about photography, as he likely was.'
	]),
	'5': _libdialog.Line.new(_libdialog.C.MAX, [
		'Everything\'s cool... I\'m okay...',
	]),
}
