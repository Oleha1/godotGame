extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var camera = StaticData.getCamera()
	var pos = camera["position"]
	var rot = camera["rotate"]
	var posX = pos["x"]
	var posY = pos["y"]
	var posZ = pos["z"]
	var rotateX = rot["x"]
	var rotateY = rot["y"]
	var rotateZ = rot["z"]
	position = Vector3(posX,posY,posZ)
	rotation = Vector3(rotateX,rotateY,rotateZ)
	#rotate_x(rotateX)
	#rotate_y(rotateY)
	#rotate_z(rotateZ)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
