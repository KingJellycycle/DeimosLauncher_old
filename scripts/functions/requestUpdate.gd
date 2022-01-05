extends Node

onready var PATCH
onready var UpdateRequest = get_node("/root/Main/HTTPRequestNodes/UPDATERequest")


func requestUpdate():
	
	var current_version = CheckGameVersion.checkGameVersion()
	pass


func updateGame():
	# Request Patch File, NEED to move this into game update stuff, instead of requesting it right away! + Doesn't check version yet!
	UpdateRequest.request("http://192.168.0.196/bound/patches/0.0.1/bound-patched.pck")
