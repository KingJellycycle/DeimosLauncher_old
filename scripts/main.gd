extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var OSType = OS.get_name()

var posts = []

var settingsResource = preload("res://settings.tres")
var postScene = preload("res://post.tscn")

#var bound_directory = "/home/jelly/Documents/Bound/bound.x86_64"

var executableTypes = [
	"Bound.exe",
	"Bound.x86_64",
	"Bound.app"
]

var readyComplete = false
var updateData = false

## PATCH STUFF
onready var base_location = get_node("MarginContainer/VBoxContainer/Middle/Patch/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/MarginContainer2/VBoxContainer")
#onready var title = base_location.get_node("Title")
onready var patchContainer = get_node("MarginContainer/VBoxContainer/Middle/Patch/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/MarginContainer2")



onready var postParentNode = get_node("MarginContainer/VBoxContainer/Middle/Info/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/ScrollContainer/VBoxContainer")

var darkThemeEnabled = false
var darkTheme = preload("res://dark-theme.tres")
var lightTheme = preload("res://light-theme.tres")

var settingsInfo = preload("res://settings.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title("Deimos - " + OSType)
	# make background transparent!
	get_tree().get_root().set_transparent_background(true)
	
	applySettings()
	updateSettings()
	
	RequestUpdate.updateGame()
	
	readyComplete = true
	#requestWebData()

func _process(_delta):
	if readyComplete and updateData == false:
		DeimosData.updateAll()
		updateData = true


func applySettings():
	if settingsInfo.darkTheme:
		set_theme(darkTheme)
	else:
		set_theme(lightTheme)	
	#settingsInfo.darkTheme = !settingsInfo.darkTheme

func updateSettings():
	var settingsNode = get_node("MarginContainer/VBoxContainer/Middle/Settings/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer")
	var GeneralNode = settingsNode.get_node("GeneralSettings/MarginContainer/VBoxContainer")
	var ResourcesNode = settingsNode.get_node("Resources/MarginContainer/VBoxContainer2")
	
	# Get/Set General Node data
	var darkthemeNode = GeneralNode.get_node("ThemeToggle")
	var BGupdateNode = GeneralNode.get_node("BGUpdates")
	var fancyNode = GeneralNode.get_node("FancyPerson")
	
	darkthemeNode.pressed = settingsInfo.darkTheme
	BGupdateNode.pressed = settingsInfo.BackgroundUpdates
	fancyNode.pressed = settingsInfo.Fancy
	
	# Get/Set Resources Node data
	var game_directoryNode = ResourcesNode.get_node("HBoxContainer/bound_directory_LE")
	
	game_directoryNode.text = settingsInfo.bound_directory

	
## Launch Game
func _on_Button_pressed():
	launchBound()
	
func launchBound():
	var executeType
	
	if OSType == "X11":
		executeType = executableTypes[1]
	elif OSType == "Windows":
		executeType = executableTypes[0]
	elif OSType == "OSX":
		executeType = executableTypes[2]
	#print(settingsInfo.bound_directory + "/" + executeType)
	
	OS.execute(settingsInfo.bound_directory + "/" + executeType,[""],false)

## Window Operations
func _on_Exit_pressed():
	ResourceSaver.save("res://settings.tres", settingsInfo)
	get_tree().quit()
	
func _on_Minimize_pressed():
	OS.set_window_minimized(true)

## HTTPS Operations
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
	
	postParentNode.get_node("LoadingInfoContainer").visible = false

func _on_PATCHRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
	var title = base_location.get_node("Title")
	var description = base_location.get_node("Description")
	var patch = base_location.get_node("Patch")
	
	title.text = String("Version: " + String(json.result.version))
	description.text = json.result.description
	patch.text = json.result.patch
	
	patchContainer.get_node("VBoxContainer").visible = true
	patchContainer.get_node("LoadingInfoContainer").visible = false
	

func _on_BOUNDPATCHRequest_request_completed(result, response_code, headers, body):
	#print(body)
	var file = File.new()
	file.open("res://bound-patch.bck", File.WRITE)
	file.store_buffer(body)
	file.close()		

## Settings Operations
func _on_SettingsSave_pressed():
	var settingsNode = get_node("MarginContainer/VBoxContainer/Middle/Settings/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer")
	var GeneralNode = settingsNode.get_node("GeneralSettings/MarginContainer/VBoxContainer")
	var ResourcesNode = settingsNode.get_node("Resources/MarginContainer/VBoxContainer2")
	
	# Get/Set General Node data
	var darkthemeNode = GeneralNode.get_node("ThemeToggle")
	var BGupdateNode = GeneralNode.get_node("BGUpdates")
	var fancyNode = GeneralNode.get_node("FancyPerson")
	
	settingsInfo.darkTheme = darkthemeNode.pressed
	settingsInfo.BackgroundUpdates = BGupdateNode.pressed
	settingsInfo.Fancy = fancyNode.pressed
	
	# Get/Set Resources Node data
	var game_directoryNode = ResourcesNode.get_node("HBoxContainer/bound_directory_LE")
	
	settingsInfo.bound_directory = game_directoryNode.text
	
	applySettings()

func _on_bound_locate_pressed():
	get_node("PopupDialogs/BoundFileDialog").popup_centered()

func _on_BoundFileDialog_dir_selected(dir):
	settingsInfo.bound_directory = dir 
	updateSettings()
