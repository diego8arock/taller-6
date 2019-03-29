extends Spatial

export  (PackedScene) var panels


# Called when the node enters the scene tree for the first time.
func _ready():
	var panel = panels.instance()
	panel.transform.origin[0] = -1
	$PanelContainer.add_child(panel)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
