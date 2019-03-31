extends Spatial

#Enums
enum PANEL_TYPE {
		IMAGE,
		VIDEO,
		MODEL
	}

#Local export 
export var panel : PackedScene = null
export var radius : int = 3
export var scalar : float = 1.0
export var proportion : float = 0.03
const DEGREES_CIRCLE : float = 360.0

#Local constants
const dir_path = "res://assets/menu/"
const dir_img = "images"
const dir_video = "videos"
const dir_model = "models"

#Local varibales
var total_files : int = 0
var partition : int
var image_files = []
var video_files = []
var model_files = []

func _ready():
	read_files()
	partition = total_files
	
	for x in range(partition - 1):
		scalar -= proportion
	var vector_scalar = Vector3(scalar, scalar, scalar)
	
	var partition_angles : float = DEGREES_CIRCLE / partition	
	var angle = 0
	var index_for_files = 0
	var panel_type = PANEL_TYPE.IMAGE
	for x in range(partition):
		var posx = radius * sin(to_radian(angle))
		var posy = radius * cos(to_radian(angle))
		angle += partition_angles
		var panelNew = panel.instance()
		$PanelContainer.add_child(panelNew)
		panelNew.transform.origin[0] = posx
		panelNew.transform.origin[1] = posy
		var mesh = panelNew.get_node("Mesh")
		mesh.transform = mesh.transform.scaled(vector_scalar)
		
		index_for_files += 1	
		match panel_type:
			PANEL_TYPE.IMAGE:
				if index_for_files > image_files.size():
					panel_type = PANEL_TYPE.VIDEO
					index_for_files = 1
			PANEL_TYPE.VIDEO:
				if index_for_files > video_files.size():
					panel_type = PANEL_TYPE.MODEL
					index_for_files = 1
			PANEL_TYPE.MODEL:
				if index_for_files > model_files.size():
					panel_type = PANEL_TYPE.IMAGE
					index_for_files = 1		
		panelNew.set_panel_type(panel_type)
	pass 

func to_radian(angle) -> float:
	return angle * PI / 180
	
func read_files() -> void:
	image_files = read_directory(dir_img, "jpg")
	video_files = read_directory(dir_video, "webm")
	model_files = read_directory(dir_model, "tscn")

func read_directory(file_path, file_extension) -> Array:
	var file_list = []
	var dir = Directory.new()
	if dir.open(dir_path + file_path) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while (file != ""):
			if file.ends_with(file_extension):
				total_files += 1
				file_list.append(file)
			file = dir.get_next()
	return file_list
	
	