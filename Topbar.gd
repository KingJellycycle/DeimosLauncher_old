extends MarginContainer


var follow = false
var dragging_start_pos = Vector2()

func _on_TitleBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			follow = !follow
			dragging_start_pos = get_local_mouse_position()

func _process(_delta):
	if follow:
		OS.set_window_position(OS.window_position + get_global_mouse_position() - dragging_start_pos)
