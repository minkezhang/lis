extends Object
# TODO(minkezhang): Remove extraneous class_name declaration in Godot v4.3. See
# https://github.com/godotengine/godot/issues/86032 for more information.
class_name _LibDialog

enum C {
	NONE,
	MAX,
	JEFFERSON,
}

static func _split_single_line(
	input_line: String,
	output_line_length: int,
	output_n_lines: int,
) -> Array:
	if not output_line_length:
		if input_line:
			return [input_line]
		else:
			return []
	
	var r = RegEx.new()
	r.compile("[^\\s]+")
	
	var output_lines = []
	var current_line = []
	
	for tok in r.search_all(input_line):
		var word = tok.get_string()
		if (
			current_line.size() == 0
		) or (
			' '.join(current_line).length() + word.length() + 1 <= output_line_length
		):
			current_line.append(word)
		else:
			output_lines.append(' '.join(current_line))
			current_line = [word]
	if current_line.size() > 0:
		output_lines.append(' '.join(current_line))
	
	var output_blocks = []
	var current_block = []
	
	if not output_n_lines:
		return [
			'\n'.join(output_lines),
		]
	
	for l in output_lines:
		if current_block.size() + 1 <= output_n_lines:
			current_block.append(l)
		else:
			output_blocks.append('\n'.join(current_block))
			current_block = [l]
	if current_block.size() > 0:
		output_blocks.append('\n'.join(current_block))
	
	return output_blocks

static func _split_lines(
	input_lines: Array,
	output_line_length: int,
	output_n_lines: int,
) -> Array:
	var output_lines = []
	for l in input_lines:
		output_lines += _LibDialog._split_single_line(
			l,
			output_line_length,
			output_n_lines,
		)
	return output_lines


class LineReader:
	var _ls: Array
	var _id: String
	var _index: int
	
	func _init(line: Line, output_line_length: int = 0, output_n_lines: int = 0):
		_index = 0
		_id = line.id()
		_ls = _LibDialog._split_lines(line._ls, output_line_length, output_n_lines)
	
	func seek(i: int):
		_index = i
	
	func eof():
		return _index >= len(_ls)
	
	func get_next_line() -> String:
		if eof():
			return ''
		
		var s = _ls[_index]
		_index += 1
		return s
		
	func id() -> String:
		return _id


class Line:
	var _c: C
	var _id: String
	var _ls: Array
	var _index: int
	
	func _init(i: String, c: C, lines: Array):
		_c = c
		_id = i
		_ls = lines.duplicate()
		_index = 0
	
	func character() -> C:
		return _c
	
	func id() -> String:
		return _id
