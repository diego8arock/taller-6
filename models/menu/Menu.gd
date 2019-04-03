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
export var angular_speed : float = 0.03

#Local constants
const DEGREES_CIRCLE : float = 360.0
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
var rotate : float = 0.0
var is_image_shown : bool = false
var is_video_shown : bool = false
var is_model_shown : bool = false 
var is_menu_shown : bool = true
var rotateX : float = 0.0
var rotateY : float = 0.0
var rotateZ : float = 0.0

#VR variables
const vrpnClient = preload("res://bin/vrpnClient.gdns")
const vrpnClient2 = preload("res://bin/vrpnClient.gdns")
var clientGlove = null
var clientTracker = null
export var rotate_sensitiviy : float = 10.0
var fist_values = []
var is_using_tracker : bool = false
var is_using_glove : bool = false
export var threshold : float = 2.0

#Native methods
func _ready():
	$MeshInstance.hide()
	#setup_vr()
	read_files()
	draw_folders() 
	print("End ready...")

func _process(delta):
		
	if is_using_glove:
		clientGlove.mainloop()
		var is_fist = true;
		#print(clientGlove.analog.size())
		if(clientGlove.analog.size() == 14):
			for t in range(fist_values.size()):
				var value = fist_values[t] 
				var tracker = clientGlove.analog[t] * 10
				#print( tracker)
				if tracker < value + threshold and tracker > value - threshold:
					is_fist = is_fist and true
				else:
					is_fist = is_fist and false
			if is_fist:
				if is_menu_shown:
					show_selected_node()
			else:
				cancel()
				
	if is_using_tracker:
		#print(clientTracker.quat)
		clientTracker.mainloop()
		if clientTracker.quat[0] == 0 and clientTracker.quat[1] == 0 and clientTracker.quat[2] == 0:
			return
			
		#var quatx = clientTracker.quat[0]
		var quaty = clientTracker.quat[1]
		#var quatz = clientTracker.quat[2]
		print(quaty)
		rotate = quaty
		rotate_sensitiviy = 10
	if is_menu_shown:
		$PanelContainer.rotate(Vector3(0,0,1),rotate / rotate_sensitiviy)
		for panel in $PanelContainer.get_children():
			rotate_panel(panel)
	if is_model_shown:
		$Spatial.rotate(Vector3(0,1,0),rotateY)
		$Spatial.rotate(Vector3(1,0,0),rotateX)
		$Spatial.rotate(Vector3(0,0,1),rotateZ)
	
func _unhandled_key_input(event):
	if is_menu_shown:
		if event.is_action_pressed("ui_left") or event.is_action_released("ui_right"):
			rotate -= angular_speed
		if event.is_action_released("ui_left") or event.is_action_pressed("ui_right"):
			rotate += angular_speed
		if event.is_action_pressed("select_folder"):
			show_selected_node()
	else:
		if event.is_action_pressed("ui_cancel"):
			cancel()

		if is_video_shown:
			if event.is_action_pressed("start_stop_video"):
				$VideoPlayer.paused = not $VideoPlayer.paused
		if is_model_shown:
			if event.is_action_pressed("ui_left") or event.is_action_released("ui_right"):
				rotateY -= angular_speed
			if event.is_action_released("ui_left") or event.is_action_pressed("ui_right"):
				rotateY += angular_speed
			if event.is_action_pressed("ui_up") or event.is_action_released("ui_down"):
				rotateX -= angular_speed
			if event.is_action_released("ui_up") or event.is_action_pressed("ui_down"):
				rotateX += angular_speed
			if event.is_action_pressed("z_+") or event.is_action_released("z_-"):
				rotateZ -= angular_speed
			if event.is_action_released("z_+") or event.is_action_pressed("z_-"):
				rotateZ += angular_speed
			
	

#Public method
func cancel() -> void:
	if is_model_shown:
		$Spatial.hide()
	if is_image_shown:
		$TextureRect.hide()
	if is_video_shown:
		$VideoPlayer.stop()
		$VideoPlayer.hide()
	is_menu_shown = true
	is_video_shown = false
	is_model_shown = false
	is_image_shown = false
			
func setup_vr() -> void:
	if is_using_glove:
		clientGlove = vrpnClient.new()
		clientGlove.connect("Glove14Left@localhost")
		fist_values = [3.6, 4.5, 6.3, 2.5, 10.0, 7.5, 2.2, 9.4, 7.5, 3.9, 3.7, 6.6, 3.3, 6.5]
	if is_using_tracker:
		clientTracker = vrpnClient2.new()
		clientTracker.connect("Tracker0@localhost")

func draw_folders() -> void:
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
		var collision = panelNew.get_node("Collision")
		mesh.transform = mesh.transform.scaled(vector_scalar)		
		panelNew.hide_selected()
	
	var panels = $PanelContainer.get_children()
	var panel_index = 0
	for i in range(image_files.size()):
		panels[panel_index].set_panel_type(PANEL_TYPE.IMAGE, image_files[i])
		panel_index += 1
	for i in range(video_files.size()):
		panels[panel_index].set_panel_type(PANEL_TYPE.VIDEO, video_files[i])
		panel_index += 1
	for i in range(model_files.size()):
		panels[panel_index].set_panel_type(PANEL_TYPE.MODEL, model_files[i])
		panel_index += 1

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

func hide_execution_nodes() -> void:
	$VideoPlayer.hide()
	$TextureRect.hide()

func rotate_panel(panel) -> void:
	panel.look_at(Vector3(1,0,1),Vector3(0,1,0))
	
func show_selected_node() ->void:
	print("Show node...")
	var panel = $"/root/GlobalFunctions".selected_panel
	var type = panel.type
	var file = panel.file
	is_menu_shown = false
	match type:
		PANEL_TYPE.IMAGE:
			var texture = load(dir_path + dir_img + "/" + file)
			$TextureRect.show()
			$TextureRect.set_texture(texture)	
			$TextureRect.adjust_position()	
			is_image_shown = true
		PANEL_TYPE.VIDEO:
			var video = load(dir_path + dir_video + "/" + file)
			$VideoPlayer.show()
			$VideoPlayer.set_stream(video)
			$VideoPlayer.adjust_size_and_position()
			$VideoPlayer.play()
			is_video_shown = true
		PANEL_TYPE.MODEL:
			var model_resource = load(dir_path + dir_model + "/" + file)
			var model = model_resource.instance()
			$Spatial.show()
			$Spatial.add_child(model)
			is_model_shown = true
			
			
			

func _on_TimerTracker_timeout():
	clientTracker = vrpnClient2.new()
	clientTracker.connect("Tracker0@localhost")
	is_using_tracker = true;


func _on_TimerGlove_timeout():
	clientGlove = vrpnClient.new()
	clientGlove.connect("Glove14Right@localhost")
	fist_values = [3.6, 4.5, 6.3, 2.5, 10.0, 7.5, 2.2, 9.4, 7.5, 3.9, 3.7, 6.6, 3.3, 6.5]
	is_using_glove = true
