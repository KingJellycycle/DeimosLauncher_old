extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var OSType = OS.get_name()

var posts = []

var settingsResource = preload("res://settings.tres")
var postScene = preload("res://post.tscn")

var bound_directory = "/home/jelly/Documents/Bound/bound.x86_64"

onready var base_location = get_node("MarginContainer/VBoxContainer/Middle/Patch/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/MarginContainer2/VBoxContainer")
#onready var title = base_location.get_node("Title")
onready var description = base_location.get_node("Description")
onready var patch = base_location.get_node("Patch")

onready var postParentNode = get_node("MarginContainer/VBoxContainer/Middle/Info/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/ScrollContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title("Launcher - " + OSType)
	# make background transparent!
	get_tree().get_root().set_transparent_background(true)
	
	applySettings()
	# onstart request data!
	$BLOGRequest.connect("request_completed", self, "_on_request_completed")
	$PATCHRequest.request("https://www.kingjellycycle.com/Bound_Test.json")
	# request Blog Feed!
	$BLOGRequest.request("https://www.kingjellycycle.com/feed.xml")

func applySettings():
	pass


## Launch Game
func _on_Button_pressed():
	launchBound(OSType)
	
func launchBound(OSsystem): 
	OS.execute(bound_directory,[""],false)

## Window Operations
func _on_Exit_pressed():
	get_tree().quit()
	
func _on_Minimize_pressed():
	OS.set_window_minimized(true)


func _on_BLOGRequest_request_completed(result, response_code, headers, body):
	var in_entry_node = false
	var in_title_node = false
	var in_summary_node = false
	var in_id_node = false
	#var in_category_node = false
	
	var item = ["","",""]
	
	var parser = XMLParser.new()
	var feedData
	
	var error = parser.open_buffer(body)
	
	if error != OK:
		print("Error opening XML file (https://www.kingjellycycle.com/feed.xml) - ", error)
		return
	
	# seperate feed.xml into title, description and link!
	while parser.read() == OK:
		
		var node_name = parser.get_node_name()
		var node_data = parser.get_node_data()
		var node_type = parser.get_node_type()
		
		#print("node_name: " + node_name)
		#print("node_data: " + node_data)
		#print("node_type: " + node_data)
		
		if(node_name == "entry"):   
			in_entry_node = !in_entry_node
		if (node_name == "title") and (in_entry_node == true):     
			in_title_node = !in_title_node   
			continue    
		if(node_name == "summary") and (in_entry_node == true):     
			in_summary_node = !in_summary_node   
			continue     
		if(node_name == "id") and (in_entry_node == true):   
			in_id_node = !in_id_node   
			continue
			
		#if(node_name == "category") and (in_entry_node == true):   
		#	in_category_node   = !in_category_node  
		#	continue
			
		if in_title_node:
			#print("title-data: " + node_data)
			item[0] = node_data
		if in_summary_node:
			#print("summary-data: " + node_data)
			item[1] = node_data
		if in_id_node:
			#print("id-data: " + node_data)
			item[2] = node_data
		
		if item[0] != "" and item[1] != "" and item[2] != "":
			posts.append(item)
			item = ["","",""]	
		
	# Instance Post nodes into the info section! and update the post to the required information!
	for i in posts:
		var instance = postScene.instance()
		var node = postParentNode.add_child(instance)
		instance.updatePost(i[0],i[1],i[2])
		#if in_category_node:
		#	print("category-data: " + node_data)


func _on_PATCHRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
	#title.text = json.result.title
	description.text = json.result.description
	patch.text = json.result.patch
