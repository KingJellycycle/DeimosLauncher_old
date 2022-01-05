extends Node

onready var BlogRequest = get_node("/root/Main/HTTPRequestNodes/BLOGRequest")
onready var PatchRequest = get_node("/root/Main/HTTPRequestNodes/PATCHRequest")

func updateAll():
	print(BlogRequest)
	updateNews()
	updatePatches()
	
func updateNews():
	# Request Blog Feed!
	BlogRequest.request("https://www.kingjellycycle.com/feed.xml")

func updatePatches():
	# Request Bound Patch Notes!
	PatchRequest.request("http://192.168.0.196/bound/patches/latest.json")

