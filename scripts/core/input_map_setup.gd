extends Node

func _ready():
	print("Setting up input mappings...")
	
	# Add custom input actions if they don't exist
	if not InputMap.has_action("ui_save"):
		InputMap.add_action("ui_save")
		var event = InputEventKey.new()
		event.keycode = KEY_F5
		InputMap.action_add_event("ui_save", event)
		print("Added ui_save input action")
	
	if not InputMap.has_action("ui_load"):
		InputMap.add_action("ui_load")
		var event = InputEventKey.new()
		event.keycode = KEY_F8
		InputMap.action_add_event("ui_load", event)
		print("Added ui_load input action")
		
	# Add ui_continue action for advancing dialogue
	if not InputMap.has_action("ui_continue"):
		InputMap.add_action("ui_continue")
		
		# Add left mouse button
		var mouse_event = InputEventMouseButton.new()
		mouse_event.button_index = MOUSE_BUTTON_LEFT
		mouse_event.pressed = true
		InputMap.action_add_event("ui_continue", mouse_event)
		
		# Add space key
		var key_event = InputEventKey.new()
		key_event.keycode = KEY_SPACE
		InputMap.action_add_event("ui_continue", key_event)
		print("Added ui_continue input action")
	else:
		print("ui_continue already exists in InputMap")
	
	# 验证所有输入映射
	print("Input mapping setup complete")
	print("ui_continue actions:", InputMap.action_get_events("ui_continue").size())
	print("ui_save actions:", InputMap.action_get_events("ui_save").size())
	print("ui_load actions:", InputMap.action_get_events("ui_load").size()) 