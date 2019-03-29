extends KinematicBody

const vrpnClient = preload("res://bin/vrpnClient.gdns")
var clientGlove = null
var clientTracker = null

var motion = Vector3()
const UP = Vector3(0,1,0)

func _ready():
	print(vrpnClient)
	#clientGlove = vrpnClient.new()
	#clientGlove.connect("Glove14Right@localhost")
	clientTracker = vrpnClient.new()
	clientTracker.connect("Tracker0@localhost")

func _process(delta):
	
	clientTracker.mainloop()
	process_quat()
	process_pos()


func process_pos():
	if clientTracker.pos[0] == 0 and clientTracker.pos[1] == 0 and clientTracker.pos[2] == 0:
		return
	
	var posx = clientTracker.pos[0]
	var posy = clientTracker.pos[1]
	var posz = clientTracker.pos[2]
	#print("x: " +str(posx)+ " y: " +str(posy)+ " z:" + str(posz))
	#var position = Vector3(0,posy / 10,0)
	#var position = Vector3(posx / 10,0,0)
	var position = Vector3(0,0,posy / 10)
	
	translate(position)
	#print(transform.origin)

func process_quat():
	if clientTracker.quat[0] == 0 and clientTracker.quat[1] == 0 and clientTracker.quat[2] == 0:
		return
		
	var quatx = clientTracker.quat[0]
	var quaty = clientTracker.quat[1]
	var quatz = clientTracker.quat[2]
	#print("x: " +str(quatx)+ " y: " +str(quaty)+ " z:" + str(quatz))
	#rotate(Vector3(1,0,0), quatx / 10)
	#rotate(Vector3(0,1,0), quaty / 10)
	rotate(Vector3(0,0,1), quaty / 10)
