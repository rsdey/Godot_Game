extends ColorRect

signal time_for_story_intro

var player_info = {
	"name" : "null",
	"age" : -1
}

func _ready():
	$Button.connect("pressed", self, "_on_Button_pressed")
	$"Name Set/LineEdit".connect("text_changed", self, "_on_Name_LineEdit_text_changed")
	$"Age Set/LineEdit".connect("text_changed", self, "_on_Age_LineEdit_text_changed")
	$"Age Set/VScrollBar".connect("value_changed", self, "_on_Age_VScrollBar_value_changed")
	pass # Replace with function body.

func _on_Button_pressed(): #Code to save player info to a file
	print("Button is pressed!")
	var file = File.new()
	file.open("user://player_info.json", File.WRITE)
	
	if(file.is_open()):
		file.store_line(to_json(player_info))
		print("Written ", to_json(player_info), " to user://player_info.json")

	file.close()
	emit_signal("time_for_story_intro")
	pass # Replace with function body.

func _on_Name_LineEdit_text_changed(new_text):
	player_info['name'] = new_text
	pass # Replace with function body.
	
func _on_Age_LineEdit_text_changed(new_text):
	print(typeof(new_text) == TYPE_INT)
	player_info['age'] = new_text
	pass # Replace with function body.

func _on_Age_VScrollBar_value_changed(value):
	$"Age Set/LineEdit".text = str(value)
	player_info['age'] = str(value)
	pass # Replace with function body.
