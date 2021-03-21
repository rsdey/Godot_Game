extends Node

var QnA = preload("res://Commons/f_s_qna/QnA.tscn")
var ans_filepath = "user://QnA_data.json"

func read_player_info() -> Dictionary:
	var player_information: Dictionary
	var file = File.new()
	file.open("user://player_info.json", File.READ)
	
	if(file.is_open()):
		player_information = parse_json(file.get_line())
	else:
		print("Could not load player_info\n")
	
	print(player_information)
	file.close()
	return player_information
	pass

func read_saved_answer(qn: int) -> bool:
	var ans: bool
	var ans_file = File.new()
	ans_file.open(ans_filepath, File.READ)
	
	if(ans_file.is_open()):
		#print('Reading Ans of Qn : ', qn)
		var answers = parse_json(ans_file.get_line())
		ans_file.close()
		#print("bruh? ", answers[str(qn)])
		
		if (answers[str(qn)] == 'agree'):
			ans = true
		elif (answers[str(qn)] == 'disagree'):
			ans = false

		#print("Ans is : ", ans)
	else:
		print("Could not load player_info\n")
		OS.exit()
		
	return ans

static func traverse_dir(path: String, recursive := false):
	var paths = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				paths.append(path + file_name)
				if(recursive):
					if (file_name != "." and file_name != ".."):
						traverse_dir(path + file_name + "/")
			else:
				print("Found file: " + file_name)
				paths.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	return paths
	pass

func read_dialogs(filepath: String):
	var dialog_file = File.new()
	dialog_file.open(filepath, File.READ)
	
	var content = []
	if dialog_file:
		while(!dialog_file.eof_reached()):
			content.append(dialog_file.get_line())
	else:
		print("Dialogs file not found..")
		
	#print(content)
	return content
	pass
