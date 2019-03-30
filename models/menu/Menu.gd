extends Spatial

export var panel : PackedScene = null
export var partition : int = 3
export var radius : int = 3
export var scalar : float = 1.0
var proportion : float = 0.03
const DEGREES_CIRCLE : float = 360.0

const dir_path = "res://assets/menu/"
const dir_img = "images"
const dir_video = "videos"
const dir_model = "models"
var total_files : int = 0

var image_files = []
var video_files = []
var model_files = []

# Called when the node enters the scene tree for the first time.
func _ready():
	read_files()
	partition = total_files
	
	for x in range(partition - 1):
		scalar -= proportion
	var vector_scalar = Vector3(scalar, scalar, scalar)
	
	var partition_angles : float = DEGREES_CIRCLE / partition	
	var angle = 0
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
		
	pass 

func to_radian(angle) -> float:
	return angle * PI / 180
	
func read_files():
	var dir = Directory.new()
	if dir.open(dir_path + dir_img) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while (file != ""):
			if file.ends_with("jpeg") or file.ends_with("jpg"):
				total_files += 1
				image_files.append(file)
			file = dir.get_next()
			
	dir = Directory.new()
	if dir.open(dir_path + dir_video) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while (file != ""):
			if file.ends_with("webm"):
				total_files += 1
				video_files.append(file)
			file = dir.get_next()
			
	dir = Directory.new()
	if dir.open(dir_path + dir_model) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while (file != ""):
			if file.ends_with("tscn"):
				total_files += 1
				model_files.append(file)
			file = dir.get_next()
