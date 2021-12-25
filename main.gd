extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var game_thread

onready var base_location = get_node("MarginContainer/VBoxContainer/Middle/Patch/HBoxContainer/MarginContainer/VBoxContainer/")
onready var title = base_location.get_node("Title")
onready var description = base_location.get_node("Description")
onready var patch = base_location.get_node("Patch")

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title("Launcher")
	# make background transparent!
	get_tree().get_root().set_transparent_background(true)

	# onstart request data!
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("https://www.kingjellycycle.com/Bound_Test.json")

func _on_Button_pressed():
	OS.execute("/home/jelly/Documents/Bound/bound.x86_64",[],false)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):	
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
	#title.text = json.result.title
	description.text = json.result.description
	patch.text = json.result.patch


func _on_Exit_pressed():
	get_tree().quit()


func _on_Minimize_pressed():
	OS.set_window_minimized(true) 
	pass # Replace with function body.
