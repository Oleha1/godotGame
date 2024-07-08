extends StaticBody3D

var boxes = []

func _ready():
	createBox()
	for box in boxes:
		add_child(box)

func createBox():
	var items = StaticData.getBoxes()
	for i in len(items):
		var boxInfo = items["box_"+str(i+1)]
		var type = boxInfo["type"]
		if	type in "box":
			var fill = bool(boxInfo["fill"])
			var push = bool(boxInfo["push"])
			if	!fill:
				var boxPosition = boxInfo.get("position")
				if boxPosition != null:
					if push:
						var color = Color(1,1,1,1)
						var colors = boxInfo.get("color")
						if color != null:
							var r = colors["r"]
							var g = colors["g"]
							var b = colors["b"]
							var a = colors["a"]
							color = Color(float(r)/255,float(g)/255,float(b)/255,float(a)/255)
						var rigidBody3D = createRigidBody3D(color)
						rigidBody3D.position = Vector3(boxPosition["x"],boxPosition["y"],boxPosition["z"])
						addPushBoxPosition(rigidBody3D.position)
						addPushBox(rigidBody3D)
					else:
						var color = Color(1,1,1,1)
						var colors = boxInfo.get("color")
						if color != null:
							var r = colors["r"]
							var g = colors["g"]
							var b = colors["b"]
							var a = colors["a"]
							color = Color(float(r)/255,float(g)/255,float(b)/255,float(a)/255)
						var staticBody3D = StaticBody3D.new()
						var meshInstance3D = createMeshInstance3D(color)
						meshInstance3D.position = Vector3(boxPosition["x"],boxPosition["y"],boxPosition["z"])
						meshInstance3D.create_convex_collision(true,false)
						staticBody3D.add_child(meshInstance3D)
						StaticData.addStaticBox(meshInstance3D)
						boxes.append(staticBody3D)
			else:
				var fillPosition = boxInfo.get("fillPosition")
				var start = fillPosition.get("startPosition")
				var end = fillPosition.get("endPosition")
				if fillPosition != null and start != null and end != null:
					for x in range(start["x"],end["x"] + 1):
						for z in range(start["z"],end["z"] + 1):
							for y in range(start["y"],end["y"] + 1):
								if push:
									var color = Color(1,1,1,1)
									var colors = boxInfo.get("color")
									if color != null:
										var r = colors["r"]
										var g = colors["g"]
										var b = colors["b"]
										var a = colors["a"]
										color = Color(float(r)/255,float(g)/255,float(b)/255,float(a)/255)
									var rigidBody3D = createRigidBody3D(color)
									rigidBody3D.position = Vector3(x,y,z)
									addPushBoxPosition(rigidBody3D.position)
									addPushBox(rigidBody3D)
								else:
									var staticBody3D = StaticBody3D.new()
									var color = Color(1,1,1,1)
									var colors = boxInfo.get("color")
									if color != null:
										var r = colors["r"]
										var g = colors["g"]
										var b = colors["b"]
										var a = colors["a"]
										color = Color(float(r)/255,float(g)/255,float(b)/255,float(a)/255)
									var meshInstance3D = createMeshInstance3D(color)
									meshInstance3D.position = Vector3(x,y,z)
									meshInstance3D.create_convex_collision(true,false)
									staticBody3D.add_child(meshInstance3D)
									StaticData.addStaticBox(meshInstance3D)
									boxes.append(staticBody3D)
		else:
			var positions = boxInfo["portalPosition"]
			var startPosition = positions.get("startPosition")
			var endPosition = positions.get("endPosition")
			var color = Color(1,1,1,1)
			var colors = boxInfo.get("color")
			if color != null:
				var r = colors["r"]
				var g = colors["g"]
				var b = colors["b"]
				var a = colors["a"]
				color = Color(float(r)/255,float(g)/255,float(b)/255,float(a)/255)
			if startPosition != null:
				var meshInstance3DStart = createStartPortal(color)
				var gpuParticles3D = createPortalParticle(color)
				meshInstance3DStart.position = Vector3(startPosition["x"],startPosition["y"] - 0.45,startPosition["z"])
				gpuParticles3D.position = Vector3(startPosition["x"],startPosition["y"] - 0.45,startPosition["z"])
				addPortal(meshInstance3DStart)
				addPortalParticle(gpuParticles3D)
				if endPosition != null:
					var meshInstance3DEnd = createEndPortal(color)
					meshInstance3DEnd.position = Vector3(endPosition["x"],endPosition["y"] - 0.45,endPosition["z"])
					addPortal(meshInstance3DEnd)

func createMeshInstance3D(color):
	var meshInstance3D = MeshInstance3D.new()
	meshInstance3D.mesh = BoxMesh.new()
	var standardMaterial3D = StandardMaterial3D.new()
	standardMaterial3D.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	standardMaterial3D.albedo_color = color
	meshInstance3D.material_override = standardMaterial3D
	return meshInstance3D

func createCollisionShape3D():
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = BoxShape3D.new()
	collision_shape.scale = Vector3(0.95,0.95,0.95)
	return collision_shape

func createRigidBody3D(color):
	var rigidBody3D = RigidBody3D.new()
	var collision_shape = createCollisionShape3D()
	rigidBody3D.add_child(collision_shape)
	var meshInstance = createMeshInstance3D(color)
	rigidBody3D.add_child(meshInstance)
	return rigidBody3D

func createPortalParticle(color):
	var gpuParticles3D = GPUParticles3D.new()
	gpuParticles3D.amount = 1
	gpuParticles3D.speed_scale = 0.5
	var standardMaterial3D = StandardMaterial3D.new()
	standardMaterial3D.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	standardMaterial3D.vertex_color_use_as_albedo = true
	gpuParticles3D.material_override = standardMaterial3D
	var particleProcessMaterial = ParticleProcessMaterial.new()
	var gradientTexture1D = GradientTexture1D.new()
	var gradient = Gradient.new()
	var packedColorArray = PackedColorArray()
	packedColorArray.append(color)
	color.a = 0
	packedColorArray.append(color)
	gradient.colors = packedColorArray
	gradientTexture1D.gradient = gradient
	particleProcessMaterial.color_ramp = gradientTexture1D
	particleProcessMaterial.gravity = Vector3(0,3,0)
	particleProcessMaterial.scale_max = 0.325
	gpuParticles3D.process_material = particleProcessMaterial
	gpuParticles3D.draw_pass_1 = preload("res://models/portal.obj")
	return gpuParticles3D

func createStartPortal(color):
	var meshInstance3D = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	meshInstance3D.mesh = preload("res://models/portal.obj")
	meshInstance3D.material_override = material
	meshInstance3D.scale = Vector3(0.325,0.325,0.325)
	return meshInstance3D

func createEndPortal(color):
	var meshInstance3D = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = color
	meshInstance3D.mesh = PlaneMesh.new()
	meshInstance3D.material_override = material
	meshInstance3D.scale = Vector3(0.325,0.325,0.325)
	return meshInstance3D

func addPortalParticle(particle):
	StaticData.addParticl(particle)
	boxes.append(particle)

func addPortal(portal):
	StaticData.addPortal(portal)
	boxes.append(portal)

func addPushBox(box):
	StaticData.addPushBox(box)
	boxes.append(box)

func addPushBoxPosition(box):
	StaticData.addPushBoxPosition(box)

func _process(delta):
	pass
