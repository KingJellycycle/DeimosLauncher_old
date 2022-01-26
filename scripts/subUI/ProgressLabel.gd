extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var UPDATERequest = get_tree().root.get_node("Main/HTTPRequestNodes/UPDATERequest")
onready var progressBarNode = get_parent().get_node("ProgressBar")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodySize = UPDATERequest.get_body_size()
	var downloadedBytes = UPDATERequest.get_downloaded_bytes()
	
	var amount = String(downloadedBytes) + " Bytes / " + String(bodySize) + " Bytes"
	
	var percent = int(downloadedBytes*100/bodySize)
	
	text = String(amount) + " (" + String(percent) + "%)"
	
	progressBarNode.value = percent
