extends Node

@onready var dialogue_ui = $DialogueUI

var dialogue_manager
var game_state
var environment_system
var current_dialogue_id = ""
var auto_advance = false

func _ready():
	dialogue_manager = get_node("/root/DialogueManager")
	game_state = get_node("/root/GameState")
	environment_system = get_node("/root/EnvironmentSystem")
	
	# Connect signals
	dialogue_ui.connect("dialogue_advanced", Callable(self, "_on_dialogue_advanced"))
	dialogue_ui.connect("choice_selected", Callable(self, "_on_choice_selected"))
	
	# Update the UI with current dialogue
	update_dialogue_ui()

func start_dialogue(dialogue_id):
	current_dialogue_id = dialogue_id
	
	if dialogue_manager.start_dialogue(dialogue_id):
		update_dialogue_ui()
		return true
	
	return false

func update_dialogue_ui():
	# Get current dialogue info
	var speaker = dialogue_manager.get_current_speaker()
	
	# Special handling for player character
	if speaker == "player":
		speaker = "player"  # Keep as "player" to let the UI handle it
	
	var text = dialogue_manager.get_current_text()
	var choices = dialogue_manager.get_current_choices()
	var node_data = null
	
	if dialogue_manager.current_dialogue != null and dialogue_manager.current_node != null:
		node_data = dialogue_manager.dialogue_library[dialogue_manager.current_dialogue]["nodes"][dialogue_manager.current_node]
	
	var emotion = "neutral"
	if node_data and "emotion" in node_data:
		emotion = node_data["emotion"]
	
	# Display the dialogue
	dialogue_ui.display_dialogue(speaker, text, emotion)
	
	# If there are choices, display them
	if choices.size() > 0:
		dialogue_ui.display_choices(choices)
	else:
		# 确保清除之前的选择
		dialogue_ui.clear_choices()

func check_scene_transition():
	var flags = {}
	
	# Get flags from the last dialogue node
	if dialogue_manager.dialogue_history.size() > 0:
		var last_node = dialogue_manager.dialogue_history[dialogue_manager.dialogue_history.size() - 1]
		
		if "node_id" in last_node:
			var node_id = last_node["node_id"]
			if dialogue_manager.current_dialogue != null:
				var nodes = dialogue_manager.dialogue_library[dialogue_manager.current_dialogue]["nodes"]
				if node_id in nodes and "flags" in nodes[node_id]:
					flags = nodes[node_id]["flags"]
	
	# Check if we need to go to a new scene
	if "goto_lab_scene" in flags and flags["goto_lab_scene"]:
		start_dialogue("chapter1_lab_scene")
		return true
	
	if "goto_crisis_scene" in flags and flags["goto_crisis_scene"]:
		start_dialogue("chapter1_crisis_scene")
		return true
	
	if "goto_resolution_scene" in flags and flags["goto_resolution_scene"]:
		start_dialogue("chapter1_resolution")
		return true
	
	if "return_to_main" in flags and flags["return_to_main"]:
		# Return to main menu
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return true
	
	return false

func _on_dialogue_advanced():
	# Process flags before advancing to check for scene transitions
	if check_scene_transition():
		return
	
	# Clear choices just in case
	dialogue_ui.clear_choices()
	
	# Advance to the next node
	dialogue_manager.process_current_node()
	
	# Update the UI
	update_dialogue_ui()

func _on_choice_selected(choice_index):
	# Make the choice
	if dialogue_manager.make_choice(choice_index):
		# Update the UI
		update_dialogue_ui()
	else:
		# Check for scene transitions
		check_scene_transition() 