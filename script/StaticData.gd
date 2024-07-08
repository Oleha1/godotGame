extends Node

var particles = []
var staticBox = []
var pushBox = []
var pushBoxPosition = []
var portals = []
var items = {}

func _ready():
	pass

func loadData(level):
	var path = "res://levels/level_"+str(level)+".json"
	clearAll()
	items = load_json_file(path)

func load_json_file(path:String):
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path,FileAccess.READ)
		var result = JSON.parse_string(dataFile.get_as_text())
		if result is Dictionary:
			return result
		else:
			print("Error reading file")
	else:
		print("File doesn`t exist!")
		

func getCamera():
	return items["camera"]

func getPlayer():
	return items["player"]
	
func getBoxes():
	return items["boxes"]

func getEndPortalPos(pos):
	var portals = []
	var box = getBoxes()
	if box.size() != 0:
		for a in len(box):
			var boxInfo = box["box_"+str(a+1)]
			var type = boxInfo["type"]
			if type in "portal":
				var positions = boxInfo["portalPosition"]
				var startPosition = positions.get("startPosition")
				var startPos = Vector3(startPosition["x"],startPosition["y"],startPosition["z"])
				var endPosition = positions.get("endPosition")
				if endPosition != null:
					var endPos = Vector3(endPosition["x"],endPosition["y"],endPosition["z"])
					if pos == startPos or pos == endPos:
						return endPos

func clearAll():
	particles.clear()
	staticBox.clear()
	pushBox.clear()
	pushBoxPosition.clear()
	portals.clear()
	items.clear()

func getPushBox():
	return pushBox

func getPushBoxPosition():
	return pushBoxPosition

func getStaticBox():
	return staticBox

func getParticles():
	return particles

func getPortal():
	return portals

func addPushBox(box):
	pushBox.append(box)

func addPushBoxPosition(box):
	pushBoxPosition.append(box)

func addStaticBox(box):
	staticBox.append(box)

func addParticl(particle):
	particles.append(particle)

func addPortal(portal):
	portals.append(portal)
