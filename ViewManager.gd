extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var InfoPanel = get_node("Info")
onready var PatchPanel = get_node("Patch")
onready var SettingsPanel = get_node("Settings")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Info_pressed():
	InfoPanel.visible = true
	PatchPanel.visible = false
	SettingsPanel.visible = false


func _on_Patch_pressed():
	InfoPanel.visible = false
	PatchPanel.visible = true
	SettingsPanel.visible = false


func _on_Settings_pressed():
	InfoPanel.visible = false
	PatchPanel.visible = false
	SettingsPanel.visible = true
