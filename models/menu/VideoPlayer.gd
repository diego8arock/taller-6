extends VideoPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func adjust_size_and_position() -> void:
	var size_viewport = get_viewport().get_size()
	set_size(Vector2(size_viewport.x/2, size_viewport.y/2))
	set_position(Vector2(size_viewport.x/4, size_viewport.y/4))