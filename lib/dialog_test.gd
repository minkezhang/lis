extends Object

const _libdialog = preload('res://lib/dialog.gd')
const _libtest = preload('res://lib/test/test.gd')


class SplitSingleLine extends _libtest.T:
	func _init():
		super('dialog_test/split_single_line', [
			{
				'name': 'Trivial',
				'input_line': '',
				'output_line_length': 0,
				'output_n_lines': 0,
				'want': [],
			},
			{
				'name': 'Simple',
				'input_line': 'hello',
				'output_line_length': 0,
				'output_n_lines': 0,
				'want': ['hello'],
			},
			{
				'name': 'Wrap',
				'input_line': 'some words are hard to say',
				'output_line_length': 11,
				'output_n_lines': 0,
				'want': [
					'some words\nare hard to\nsay',
				],
			},
		])
	
	func got(c: Dictionary) -> Variant:
		return _libdialog._split_single_line(
			c['input_line'],
			c['output_line_length'],
			c['output_n_lines'])
