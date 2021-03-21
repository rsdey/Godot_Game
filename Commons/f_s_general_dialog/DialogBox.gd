extends Control

export var dialog_file_path: String
export var dialog_index_begin: int
export var dialog_index_end: int	#exclusive

signal dialog_over

var dialog = [
	'bleppity',
	'boopity',
	'Dialogs were not loaded..'
]

var dialog_index = 0
var finished = false

func _ready():
	dialog = UtilityFuncs.read_dialogs(dialog_file_path)
	#print("\nLoaded by : ", self.name, " ", dialog.size(), " ", dialog_index_begin, " ", dialog_index_end)
	$"next-indicator/next_button".connect("pressed", self, "_on_next_button_pressed")
	initialize()
	pass	

func initialize(index_begin = dialog_index_begin, index_end = dialog_index_end):
	dialog_index = index_begin
	dialog_index_begin = index_begin
	dialog_index_end = index_end
	
	if(index_begin < 0 or index_begin >= index_end):
		#$RichTextLabel.text = "Dialog Index Error"
		print("Dialog Index Error")
		return
	if(index_end > dialog.size()):
		#$RichTextLabel.text = "Dialog Index Error"
		print("Dialog Index Error")
		return
	
	load_dialog()
	pass

func _process(_delta):
	$"next-indicator".visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()

func load_dialog():
	if dialog_index < dialog_index_end:
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, dialog[dialog_index].length()/30,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
		if dialog_index == dialog_index_end-1:
			emit_signal("dialog_over")
#	else:
#		queue_free()
	dialog_index += 1

func _on_Tween_tween_completed(_object, _key):
	finished = true

func _on_next_button_pressed():
	load_dialog()
	pass
