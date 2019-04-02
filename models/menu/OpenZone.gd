extends Area

func _ready():
	pass 

func _on_OpenZone_area_entered(area):
	area.show_selected()
	$"/root/GlobalFunctions".selected_panel = area
	 


func _on_OpenZone_area_exited(area):
	area.hide_selected()
	
