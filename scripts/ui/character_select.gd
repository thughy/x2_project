extends Control

var game_state
var emotion_system
var selected_character = null

# Character buttons
@onready var isa_button = $CharacterGrid/IsaButton
@onready var erika_button = $CharacterGrid/ErikaButton
@onready var neil_button = $CharacterGrid/NeilButton
@onready var kai_button = $CharacterGrid/KaiButton
@onready var character_info = $CharacterInfo
@onready var start_button = $StartButton

# Character selection
signal character_selected(character_id)

func _ready():
	game_state = get_node("/root/GameState")
	emotion_system = get_node("/root/EmotionSystem")
	
	# Connect button signals
	isa_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("isa"))
	erika_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("erika"))
	neil_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("neil"))
	kai_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("kai"))
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	
	# Start button initially disabled
	start_button.disabled = true
	
	# Set up character portraits
	isa_button.icon = load("res://assets/characters/isa_neutral.png")
	erika_button.icon = load("res://assets/characters/erika_neutral.png")
	neil_button.icon = load("res://assets/characters/neil_neutral.png")
	kai_button.icon = load("res://assets/characters/kai_neutral.png")
	
	# Clear character info
	character_info.text = "选择一个角色开始游戏"

func _on_character_button_pressed(character_id):
	# Store selected character
	selected_character = character_id
	
	# Update UI to show selection
	update_selection_ui(character_id)
	
	# Enable start button
	start_button.disabled = false
	
	# Show character info
	display_character_info(character_id)

func update_selection_ui(character_id):
	# Reset all buttons
	isa_button.modulate = Color(0.7, 0.7, 0.7)
	erika_button.modulate = Color(0.7, 0.7, 0.7)
	neil_button.modulate = Color(0.7, 0.7, 0.7)
	kai_button.modulate = Color(0.7, 0.7, 0.7)
	
	# Highlight selected character
	match character_id:
		"isa":
			isa_button.modulate = Color(1, 1, 1)
		"erika":
			erika_button.modulate = Color(1, 1, 1)
		"neil":
			neil_button.modulate = Color(1, 1, 1)
		"kai":
			kai_button.modulate = Color(1, 1, 1)

func display_character_info(character_id):
	var character_data = game_state.character_data[character_id]
	var info_text = character_data["full_name"] + "\n\n"
	info_text += character_data["description"] + "\n\n"
	info_text += "特点: " + character_data["traits"] + "\n\n"
	
	# Add base emotion info
	info_text += "基础情绪:\n"
	for emotion_type in emotion_system.character_emotions[character_id]["base"]:
		var value = emotion_system.character_emotions[character_id]["base"][emotion_type]
		var emotion_name = emotion_system.emotion_names[emotion_type]
		info_text += emotion_name + ": " + str(value) + "\n"
	
	# Add active compound emotions
	var has_active_compound = false
	for compound_emotion in emotion_system.character_emotions[character_id]["compound"]:
		if emotion_system.character_emotions[character_id]["compound"][compound_emotion]["active"]:
			if not has_active_compound:
				info_text += "\n复合情绪:\n"
				has_active_compound = true
			
			var compound_name = emotion_system.compound_emotion_names[compound_emotion]
			var value = emotion_system.character_emotions[character_id]["compound"][compound_emotion]["value"]
			info_text += compound_name + ": " + str(int(value)) + "\n"
	
	character_info.text = info_text

func _on_start_button_pressed():
	if selected_character != null:
		emit_signal("character_selected", selected_character)
		game_state.start_new_game(selected_character)
		get_tree().change_scene_to_file("res://scenes/game_scene.tscn") 