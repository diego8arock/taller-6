extends Area

enum PANEL_TYPE {
		IMAGE,
		VIDEO,
		MODEL
	}

var type
var image_material = preload("res://models/panel/ImageMaterial.tres")
var video_material = preload("res://models/panel/VideoMaterial.tres")
var model_material = preload("res://models/panel/ModelMaterial.tres")

func _ready():
	pass

func set_panel_type(panel_type):
	type = panel_type	
	var mesh = $Mesh
	match type:
		PANEL_TYPE.IMAGE:
			mesh.material_override = image_material
		PANEL_TYPE.VIDEO:
			mesh.material_override = video_material
		PANEL_TYPE.MODEL:
			mesh.material_override = model_material
	
