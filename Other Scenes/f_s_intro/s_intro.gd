extends Control

func _ready():
	$skip_intro_button.connect("pressed", self, "_skip_intro")
	$clear_progress_button.connect("pressed", self, "_clear_progress")
	$PlayerInfoBox.connect("time_for_story_intro", self, "story_intro")
	
	pass # Replace with function body.

func _clear_progress():
	var paths = UtilityFuncs.traverse_dir("user://")
	print(paths)
	
	var deleter = Directory.new()
	for path in paths:
		if (path[-1] != "."):
			print("Deleting ", path)
			deleter.remove(path)
	pass
	
func check_player_info():
	var file = File.new()
	file.open("user://player_info.json", File.READ)
	
	if(file.is_open()):
		var player_info = parse_json(file.get_line())
		if(player_info['name'] == "null" or player_info['age'] == "-1"):
			file.close()
			return false		
		file.close()
		return true
	else:
		file.close()
		return false
	pass
	
func _skip_intro():
	#Prepare user:// Directory Tree
	var dir_manager = Directory.new()
	dir_manager.open("user://")
	for i in range(1, 9, 1):
		if( dir_manager.dir_exists("Level" + str(i)) ) : continue
		dir_manager.make_dir("Level" + str(i))
	
	if check_player_info():
		print("Player info is ok, Changing scene to Level1.")
		get_tree().change_scene("res://Levels/Level1/Level1.tscn")	#Level 1
	pass

func story_intro():
	if check_player_info():
		$PlayerInfoBox.visible = false
		$DialogBox.dialog_index = $DialogBox.dialog.size() + 1
		print("<Write code/scene for introduction of story here")
		
		_skip_intro()
		pass # Replace with function body.
