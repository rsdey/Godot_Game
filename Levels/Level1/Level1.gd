extends Control

var runtime_data = {
	"Finished Shop 1"   : false,
	"Finished Shop 2"   : false,
	
	"Over Question 1" : false,
	"Over Question 2" : false,
	"Over Question 3" : false,
	"Over Question 4" : false,
	"Over Question 5" : false
}

var player_details: Dictionary
var questions: Dictionary
var responses: Dictionary
var follow_up_dialogs: Dictionary
var follow_up_question: Dictionary

var player_name: String

var thread: Thread
var sem: int

func _ready():
	sem = 0
	#Make a level data file
	var runtime_datafile = File.new()
	runtime_datafile.open("user://Level1/runtime_data.json", File.WRITE)
	
	if(!runtime_datafile.is_open()):
		print("ERROR! Cant access runtime data!")
		return
	
	$diagon_alley_branch/shop_button_1.connect("pressed", self, "focus_node", [$shop_1_branch])
	$diagon_alley_branch/shop_button_2.connect("pressed", self, "focus_node", [$shop_2_branch])
	
	player_details = UtilityFuncs.read_player_info()
	player_name = player_details["name"]
	questions = {
		1 : "Do you want to talk to your friend Ron?",
		2 : "Ron: Hello, " + player_name + ". How was your summer break?",
		3 : "Ron: Great " + player_name + ". My summer was not that good. I enjoyed the first month very much. But then, afterwards I got very bored.",
		4 : "Ron: Are you excited and ready for the school?",
		5 : "Ron: Earlier my sibling were there with me so first month was really fun. But, as soon as they left, I was alone and had nothing to do but to help mom with all house work",
		"default" : "(Choose your response.)"
	}
	responses = {
		1 : ["Yes", "No"],
		2 : ["Very Good, I visited India with my parents, played various games with friends, read some books, went on hiking trip, How was your summer?", "Actually, very good. How was your summer?"],
		3 : ["Oh, okay.", "Oh, What happened?"],
		4 : ["Yeah", "I am excited, but nervous also. Last year wasn’t very great one for me. I hope this year will be different and more fun. I am ready mentally, but there are still stuff that I need to buy before getting all set for the school."],
		5 : ["Oh, poor Ron.", "Oh, Ron. I feel sorry for you. Maybe next time we can spend our summer together, that way it would be fun for both of us."]
	}
	follow_up_dialogs = {
		1 : [[player_name + " : Hey Ron!", "Ron : Hello " + player_name + ". How was your summer break?"],["SHOPPING"]],
		2 : [["Great " + player_name + ". My summer was not that good. I enjoyed the first month very much. But then, afterwards I got very bored."]],
		3 : [[],[]],
		4 : [[],[]],
		5 : [[],[]]
	}
	follow_up_question = {
		1 : [2,-1],
		2 : [3,3],
		3 : [4,5],
		4 : [-1,-1],
		5 : [4,4]
	}
	pass
	
func focus_node(var _node):
	print("Focusing on : ", _node.get_path())
	
	var dbox: Control
	for node in get_children():
		if(node == _node):
			dbox = node.get_node("DialogBox")
			funcref(dbox, "initialize").call_func(4,7)
			node.visible = true
		else:
			node.visible = false
	
	#dbox.connect("dialog_over", self, "qna_manager")
	dbox.connect("dialog_over", self, "qna_flow")
	pass
	
func qna_flow():
	thread = Thread.new()
	thread.start(self, "ask_question", 1)
	
	pass

func ask_question(var qn: int):
	if(qn < 1):
		print("No questions left in this level..")
		return
	
	print("\nPopping up Qn:", qn)
	
	var qna_popup = UtilityFuncs.QnA.instance()
	qna_popup.connect("qna_over", self, "proceed_from_qn", [qn])
	add_child(qna_popup)
	qna_popup.popup(qn, questions[qn], responses[qn][0], responses[qn][1])
	
	var key: String = "Over Question " + str(qn)
	
	while(runtime_data[key] == false):
		OS.delay_msec(100)
	
	return

func proceed_from_qn(var qn: int):
	var key: String = "Over Question " + str(qn)
	#print('In runtime_data, setting KEY as ', key )
	runtime_data[key] = true
	var recent_answer = UtilityFuncs.read_saved_answer(qn)
	print("Answer to Qn : ", qn, " is ", recent_answer)
	
	var dialogs = follow_up_dialogs[qn]
	#print(dialogs)
	
	if (dialogs.size() > 1):
		if(recent_answer):
			for line in dialogs[0]:
				print(line)
		else:
			for line in dialogs[1]:
				print(line)
	else:
		for line in dialogs[0]:
				print(line)
	
	if (follow_up_question[qn].size() > 1):
		thread = Thread.new()
		
		if(recent_answer):
			print("Supposed to pop ", follow_up_question[qn][0])
			thread.start(self, "ask_question", follow_up_question[qn][0])
		else:
			print("Supposed to pop ", follow_up_question[qn][1])
			thread.start(self, "ask_question", follow_up_question[qn][1])
	else:
		#print(follow_up_dialogs[qn])
		print("Supposed to pop ", follow_up_question[qn][0])
		thread.start(self, "ask_question", follow_up_dialogs[qn][0])
	
	return

#func qna_manager():
#	thread = Thread.new()
#	thread.start(self, "popup_qn", 1)
#
#	thread = Thread.new()
#	thread.start(self, "popup_qn", 2)
#
#	thread = Thread.new()
#	thread.start(self, "popup_qn", 3)
#
#	thread = Thread.new()
#	thread.start(self, "popup_qn", 4)
#
#	thread = Thread.new()
#	thread.start(self, "popup_qn", 5)
#	pass
#
#func popup_qn(var qn: int):
#	print("Qn:", qn, "is waiting.")
#	while(sem < qn-1):
#		OS.delay_msec(100)
#	print("Sem = ", sem)
#
#	print("\nPopping up Qn:", qn, " because, sem=", sem)
#	var qna_popup = UtilityFuncs.QnA.instance()
#	add_child(qna_popup)
#	qna_popup.popup(qn, questions[qn], responses[qn][0], responses[qn][1])
#	qna_popup.connect("qna_over", self, "increase_qna_popup_sem")
#	pass
#
#func increase_qna_popup_sem():
#	sem += 1
#	print("Sem = ", sem)
#	pass
