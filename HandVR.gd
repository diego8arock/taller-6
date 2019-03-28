extends Spatial

const vrpnClient = preload("res://bin/vrpnClient.gdns")
var clientGlove = null
var clientTracker = null

func _ready():
	print(vrpnClient)
	clientGlove = vrpnClient.new()
	clientGlove.connect("Glove14Right@localhost")
	clientTracker = vrpnClient.new()
	clientTracker.connect("Tracker0@localhost")

func _process(delta):
	clientGlove.mainloop()
	clientTracker.mainloop()
	#print(str(clientGlove.analog))
	#print(str(clientTracker.pos))
