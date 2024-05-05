extends Object

const _libdialog = preload('res://lib/dialog.gd')


static var L = {
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
}
