extends MarginContainer

## GET NODES
onready var baseNode = get_node("PanelContainer/MarginContainer/VBoxContainer/")
onready var titleNode = baseNode.get_node("Title")
onready var descriptionNode = baseNode.get_node("Description")

var link = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func updatePost(title, desc, url):
	titleNode.text = title
	descriptionNode.text = desc
	link = url


func _on_Button_pressed():
	## OPEN LINK
	OS.shell_open(link)
	pass # Replace with function body.
