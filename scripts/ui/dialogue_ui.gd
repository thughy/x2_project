extends Control

# UI Components
@onready var name_label = $DialoguePanel/NameLabel
@onready var text_label = $DialoguePanel/TextLabel
@onready var portrait = $PortraitPanel/Portrait
@onready var choices_container = $ChoicesPanel/VBoxContainer
@onready var emotion_display = $EmotionPanel
@onready var relationship_display = $RelationshipPanel

var choice_button_scene = preload("res://scenes/ui/choice_button.tscn")
var dialogue_manager
var game_state
var emotion_system
var relationship_system
var current_speaker_id = ""
var is_player_speaking = false

signal dialogue_advanced
signal choice_selected(choice_index)

func _ready():
	dialogue_manager = get_node("/root/DialogueManager")
	game_state = get_node("/root/GameState")
	emotion_system = get_node("/root/EmotionSystem")
	relationship_system = get_node("/root/RelationshipSystem")
	
	# Connect signals
	dialogue_manager.connect("dialogue_started", Callable(self, "_on_dialogue_started"))
	dialogue_manager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	
	# Hide UI initially
	hide()
	$ChoicesPanel.visible = false
	$EmotionPanel.visible = false
	$RelationshipPanel.visible = false

func _input(event):
	# 如果对话UI可见，且没有选择项显示，则允许通过点击或空格键前进对话
	if visible and choices_container.get_child_count() == 0:
		if event.is_action_pressed("ui_continue"):
			emit_signal("dialogue_advanced")
			
	# 调试信息
	if event.is_action_pressed("ui_continue"):
		print("UI continue action pressed. UI visible: ", visible, ", Choices count: ", choices_container.get_child_count())

func display_dialogue(speaker_id, text, emotion="neutral"):
	# Replace [player_character] with the actual character name
	var player_char_id = game_state.get_player_character()
	var player_name = game_state.get_character_name(player_char_id)
	text = text.replace("[player_character]", player_name)
	
	is_player_speaking = (speaker_id == "player")
	current_speaker_id = speaker_id
	
	# Handle special speakers
	if speaker_id == "player":
		name_label.text = player_name
		speaker_id = player_char_id
	elif speaker_id == "narrator" or speaker_id == "system":
		name_label.text = speaker_id.capitalize()
		# Use a placeholder image for narrator - handle missing resource
		var icon_path = "res://assets/ui/narrator_icon.png"
		if ResourceLoader.exists(icon_path):
			portrait.texture = load(icon_path)
		else:
			# Reset texture if resource doesn't exist
			portrait.texture = null
		text_label.text = text
		show()
		return
	else:
		name_label.text = game_state.get_character_name(speaker_id)
	
	# Set portrait with fallback to null if not found
	var portrait_path = game_state.get_character_portrait(speaker_id, emotion)
	if ResourceLoader.exists(portrait_path):
		portrait.texture = load(portrait_path)
	else:
		# Try neutral portrait
		portrait_path = game_state.get_character_portrait(speaker_id, "neutral")
		if ResourceLoader.exists(portrait_path):
			portrait.texture = load(portrait_path)
		else:
			# If still not found, clear texture
			portrait.texture = null
	
	# Set text
	text_label.text = text
	
	# Update emotion display
	update_emotion_display(speaker_id)
	
	# Update relationship display if applicable
	if speaker_id != "narrator" and speaker_id != "system" and player_char_id != "" and player_char_id != speaker_id:
		update_relationship_display(player_char_id, speaker_id)
	
	show()

func display_choices(choices):
	# Clear previous choices
	for child in choices_container.get_children():
		child.queue_free()
	
	# Create buttons for each choice
	for i in range(choices.size()):
		var choice = choices[i]
		var button = choice_button_scene.instantiate()
		choices_container.add_child(button)
		
		# Replace [player_character] with the actual character name
		var choice_text = choice.text
		var player_char_id = game_state.get_player_character()
		var player_name = game_state.get_character_name(player_char_id)
		choice_text = choice_text.replace("[player_character]", player_name)
		
		button.text = choice_text
		button.choice_index = i
		button.connect("pressed", Callable(self, "_on_choice_button_pressed").bind(i))
	
	# 显示选择面板
	$ChoicesPanel.visible = true

func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()
	
	# 隐藏选择面板
	$ChoicesPanel.visible = false

func update_emotion_display(character_id):
	# This function will update the emotion display UI
	# Implement based on your specific UI design
	
	if character_id == "narrator" or character_id == "system":
		emotion_display.hide()
		return
	
	# Check if character exists in emotion system
	if not emotion_system.character_emotions.has(character_id):
		emotion_display.hide()
		return
		
	var emotions_text = ""
	
	# Display base emotions
	for emotion_type in emotion_system.character_emotions[character_id]["base"]:
		var value = emotion_system.character_emotions[character_id]["base"][emotion_type]
		if value > 25:  # Only show significant emotions
			emotions_text += emotion_system.emotion_names[emotion_type] + ": " + str(value) + "\n"
	
	# Display active compound emotions
	var compound_emotions_text = ""
	for compound_emotion in emotion_system.character_emotions[character_id]["compound"]:
		if emotion_system.character_emotions[character_id]["compound"][compound_emotion]["active"]:
			var value = emotion_system.character_emotions[character_id]["compound"][compound_emotion]["value"]
			compound_emotions_text += emotion_system.compound_emotion_names[compound_emotion] + ": " + str(int(value)) + "\n"
	
	if compound_emotions_text != "":
		emotions_text += "\n复合情绪:\n" + compound_emotions_text
	
	emotion_display.get_node("EmotionText").text = emotions_text
	emotion_display.show()

func update_relationship_display(from_character, to_character):
	# Check if relationship exists
	if not relationship_system.relationships.has(from_character) or not relationship_system.relationships[from_character].has(to_character):
		relationship_display.hide()
		return
	
	var relationship_text = ""
	var dimensions = relationship_system.relationships[from_character][to_character]
	
	relationship_text = "关系状态: " + relationship_system.get_relationship_description(from_character, to_character) + "\n\n"
	
	for dimension in dimensions:
		var dimension_name = relationship_system.dimension_names[dimension]
		var value = dimensions[dimension]
		relationship_text += dimension_name + ": " + str(value) + "\n"
	
	relationship_display.get_node("RelationshipText").text = relationship_text
	relationship_display.show()

func _on_dialogue_started(dialogue_id):
	show()

func _on_dialogue_ended(dialogue_id):
	hide()

func _on_choice_button_pressed(choice_index):
	emit_signal("choice_selected", choice_index)
	clear_choices() 