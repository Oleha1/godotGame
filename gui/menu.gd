extends Control

var levelsCounter = 0
var counter = 1

func _ready():
	for a in range(1,10000):
		var path = "res://levels/level_"+str(a)+".json"
		if FileAccess.file_exists(path):
			levelsCounter+=1
		else:
			break
	for a in range(1,levelsCounter+1):
		var Hbox = get_node("MarginContainer/VBoxContainer/VBoxContainer2/MarginContainer"+str(counter)+"/HBoxContainer")
		var control = Control.new()
		if a % 4 != 0:
			control.size_flags_horizontal = control.SIZE_EXPAND_FILL
		else:
			counter+=1
		Hbox.add_child(getButton(a))
		Hbox.add_child(control)

func getButton(level):
	var button = Button.new()
	button.text = "Уровень " + str(level)
	button.add_theme_font_override("font",preload("res://resources/Oswald-VariableFont_wght.ttf"))
	button.add_theme_font_size_override("font_size",28)
	var normal = StyleBoxTexture.new()
	normal.texture = preload("res://resources/button.svg")
	normal.texture_margin_left = 45
	normal.texture_margin_top = 7
	normal.texture_margin_right = 45
	normal.texture_margin_bottom = 7
	var hover = StyleBoxTexture.new()
	hover.texture = preload("res://resources/buttonHover.svg")
	hover.texture_margin_left = 45
	hover.texture_margin_top = 7
	hover.texture_margin_right = 45
	hover.texture_margin_bottom = 7
	var focus = StyleBoxTexture.new()
	button.add_theme_stylebox_override("normal",normal)
	button.add_theme_stylebox_override("pressed",normal)
	button.add_theme_stylebox_override("focus",focus)
	button.add_theme_stylebox_override("hover",hover)
	button.pressed.connect(func test():
		var levelID = button.text.replace("Уровень ","")
		StaticData.loadData(int(levelID))
		get_tree().change_scene_to_file("res://script/main.tscn")
	)
	return button

func _process(delta):
	pass
