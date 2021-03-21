extends Control

export var question: String  = "//No Qn//"
export var agree_text: String = "??"
export var disagree_text: String = "??"
export var question_number: int = 0

var data = {}
signal qna_over

func _ready():
	#self.visible = false
	$RichTextLabel.bbcode_text = "[center]" + question + "[/center]"
	$button_agree.get_node("button_text").text = agree_text
	$button_disagree.get_node("button_text").text = disagree_text
	
	$button_agree.get_node("button").connect("pressed", self, "save_ans", ["agree"])
	$button_disagree.get_node("button").connect("pressed", self, "save_ans", ["disagree"])
	pass # Replace with function body.

func popup(q_no, q, a_t, d_t):
	question = q
	question_number = q_no
	$RichTextLabel.bbcode_text = "[center]" + question + "[/center]"
	
	var agree_button = $button_agree #.text = a_t
	var disagree_button = $button_disagree #.text = d_t
	
	agree_button.get_node("button_text").bbcode_text = "[center]" + a_t + "[/center]"	
	disagree_button.get_node("button_text").bbcode_text = "[center]" + d_t + "[/center]"
	
	self.visible = true	
	pass

func save_ans(ans: String):
	var data_file = File.new()
	
	if data_file.file_exists("user://QnA_data.json"):
		data_file.open("user://QnA_data.json", File.READ)
		var file_data = parse_json(data_file.get_line())
		if(file_data): data = file_data
		#print("Data read : ", to_json(data))
		data_file.close()
	
	data_file.open("user://QnA_data.json", File.WRITE)
	
	if(data_file.is_open()):
		#data["lol"] = "hihhi"
		var key = str(question_number)
		var value = ans
		
		data[key] = value
	else:
		print("Error: File not open")
	
	data_file.store_line(to_json(data))
	#print("Data written : ", to_json(data))
	
	data_file.close()
	emit_signal("qna_over")
	self.queue_free()
	pass
