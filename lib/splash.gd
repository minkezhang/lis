extends Object

const _libuuid = preload('res://lib/uuid.gd')
	
	
class Splash extends _libuuid.UUID:
	var _texture: ImageTexture
	
	func _init(fn: String):
		super()
		
		_texture = ImageTexture.create_from_image(Image.load_from_file(fn))
		
	func texture() -> ImageTexture:
		return _texture
		
	func eof() -> bool:
		return true
