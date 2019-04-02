extends TextureRect

func _ready():
	var size = get_viewport().get_size()
	set_position(Vector2(size.x/2,size.y/2))

func adjust_position() -> void:
	var texture_size = get_texture().get_size()
	var width = texture_size.x / 2
	var height = texture_size.y / 2
	var position = get_position()
	set_position(Vector2(position.x - width, position.y - height))
	