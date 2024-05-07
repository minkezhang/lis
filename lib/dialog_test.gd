extends Object

const _libdialog = preload('res://lib/dialog.gd')

class Test:
	func split_single_line() -> Array:
		var cs = [
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
		]
		var tests = []
		for config in cs:
			tests.append({
				'name': config['name'],
				'got': _libdialog._split_single_line(
					config['input_line'],
					config['output_line_length'],
					config['output_n_lines']),
				'want': config['want'],
			})
		return tests
