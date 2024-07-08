extends CharacterBody3D

const SPEED = 4
const JUMP_VELOCITY = 4.5
const DECELERATION_RATE = 5.0
var oldPos
var time = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	print(time)
	if time > 0:
		time-=1
	else:
		time = 0
	var portals = StaticData.getPortal()
	if portals.size() != 0:
		for i in len(portals):
			var portal = portals[i] as MeshInstance3D
			if position == round(portal.global_position):
				var result = StaticData.getEndPortalPos(position)
				if result != null:
					position = StaticData.getEndPortalPos(position)
				else:
					get_tree().change_scene_to_file("res://gui/menu.tscn")
	processMovementInput()

func processMovementInput():
	var dir = Vector3()
	if position.y < -2:
		restart_level()
	if Input.is_action_just_pressed("ui_down"):
		dir.z = 2
	elif Input.is_action_just_pressed("ui_up"):
		dir.z = -2
	if Input.is_action_just_pressed("ui_left"):
		dir.x = -2
	elif Input.is_action_just_pressed("ui_right"):
		dir.x = 2
	if Input.is_action_just_pressed("R"):
		if time == 0:
			restart_level()
			time = 30
	if Input.is_action_just_pressed("Q"):
		get_tree().change_scene_to_file("res://gui/menu.tscn")
	if dir.x != 0 and dir.z != 0:
		if abs(dir.x) > abs(dir.z):
			dir.z = 0
		else:
			dir.x = 0
	if !isAirBox(position - Vector3(0,1,0)):
		translate(Vector3(0,-1,0))
	if dir.length_squared() > 0:
		oldPos = position
		dir = dir.normalized() * 2
		if isStaticBox(position + dir / 2) == null and (isAirBox(position + dir / 2) == null or isAirBox(position + dir) == null):
			translate(dir)

func restart_level():
	var psuhBox = StaticData.getPushBox();
	var pushBoxPosition = StaticData.getPushBoxPosition()
	if psuhBox.size() != 0:
		for i in len(psuhBox):
			var box = psuhBox[i] as RigidBody3D
			box.linear_velocity = Vector3(0,0,0)
			box.angular_velocity = Vector3(0,0,0)
			box.rotation = Vector3(0,0,0)
			box.position = pushBoxPosition[i]
	var player = StaticData.getPlayer()
	var pos = player["position"]
	var x = pos["x"]
	var y = pos["y"]
	var z = pos["z"]
	position = Vector3(x,y,z)

func isAirBox(pos):
	var staticBox = StaticData.getStaticBox();
	if staticBox.size() != 0:
		for i in len(staticBox):
			var box = staticBox[i] as MeshInstance3D
			if	box.global_position == pos:
				return true
	var psuhBox = StaticData.getPushBox();
	if psuhBox.size() != 0:
		for i in len(psuhBox):
			var box = psuhBox[i] as RigidBody3D
			if	round(box.global_position) == pos:
				return true

func isStaticBox(pos):
	var staticBox = StaticData.getStaticBox();
	if staticBox.size() != 0:
		for i in len(staticBox):
			var box = staticBox[i] as MeshInstance3D
			if	box.global_position == pos:
				return true

func isPushBox(pos):
	var psuhBox = StaticData.getPushBox();
	if psuhBox.size() != 0:
		for i in len(psuhBox):
			var box = psuhBox[i] as RigidBody3D
			if	round(box.global_position) == pos:
				return true

func translatePushBox(x,z):
	var psuhBox = StaticData.getPushBox();
	if psuhBox.size() != 0:
		for i in len(psuhBox):
			var box = psuhBox[i] as RigidBody3D
			if x == round(box.position.x) and z == round(box.position.z):
				if round(box.position.y) != round(position.y) and round(box.position.y) >= round(position.y):
					var pos = round(box.position - oldPos) - Vector3(0,1,0)
					pos.y +=0.0125
					box.translate(pos)

func _on_ready():
	var player = StaticData.getPlayer()
	var pos = player["position"]
	var x = pos["x"]
	var y = pos["y"]
	var z = pos["z"]
	position = Vector3(x,y,z)

func _on_area_3d_body_entered(body:Node3D):
	if	body.name in "player":
		return
	if body is RigidBody3D:
		var box = body as RigidBody3D
		if round(box.position.y) == round(position.y):
			var pos = round(box.position - oldPos)
			translatePushBox(round(box.position.x),round(box.position.z))
			pos.y +=0.0125
			box.translate(pos)
	else:
		position = oldPos
