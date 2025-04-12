extends Node

signal dialogue_started(dialogue_id)
signal dialogue_ended(dialogue_id)
signal dialogue_choice_made(choice_id, choice_text)
signal dialogue_emotion_changed(character_id, emotion_type, old_value, new_value)

# Current dialogue state
var current_dialogue = null
var current_node = null
var dialogue_history = []
var active_choices = []
var dialogue_library = {}

func _ready():
	# Load chapter 1 dialogues
	var chapter1 = load("res://scripts/dialogue/chapter1_dialogues.gd").new()
	
	# 直接加载对话，而不是调用load_chapter1_dialogues方法
	add_dialogue("chapter1_intro", chapter1.create_intro_dialogue())
	add_dialogue("chapter1_lab_scene", chapter1.create_lab_scene_dialogue())
	add_dialogue("chapter1_crisis_scene", chapter1.create_crisis_scene_dialogue())
	add_dialogue("chapter1_resolution", chapter1.create_resolution_dialogue())

# Add a dialogue to the library
func add_dialogue(dialogue_id, dialogue_data):
	dialogue_library[dialogue_id] = dialogue_data
	return true

# Start a dialogue by ID
func start_dialogue(dialogue_id):
	if dialogue_id in dialogue_library:
		current_dialogue = dialogue_id
		dialogue_history = []
		
		# Get the first node
		var first_node = dialogue_library[dialogue_id]["start_node"]
		current_node = first_node
		
		emit_signal("dialogue_started", dialogue_id)
		
		# Process the first node
		process_current_node()
		
		return true
	
	return false

# Process the current dialogue node
func process_current_node():
	if current_dialogue == null or current_node == null:
		return false
	
	var node_data = dialogue_library[current_dialogue]["nodes"][current_node]
	
	# Add to history
	dialogue_history.append({
		"node_id": current_node,
		"speaker": node_data.get("speaker", ""),
		"text": node_data.get("text", ""),
		"emotion": node_data.get("emotion", ""),
	})
	
	# Check for emotion changes
	var emotion_changes = node_data.get("emotion_changes", {})
	for character_id in emotion_changes:
		for emotion_type in emotion_changes[character_id]:
			var change_value = emotion_changes[character_id][emotion_type]
			var emotion_system = get_node("/root/EmotionSystem")
			
			var old_value = emotion_system.get_emotion(character_id, emotion_type)
			emotion_system.change_emotion(character_id, emotion_type, change_value)
			var new_value = emotion_system.get_emotion(character_id, emotion_type)
			
			emit_signal("dialogue_emotion_changed", character_id, emotion_type, old_value, new_value)
	
	# Check for relationship changes
	var relationship_changes = node_data.get("relationship_changes", {})
	for from_char in relationship_changes:
		for to_char in relationship_changes[from_char]:
			for dimension in relationship_changes[from_char][to_char]:
				var change_value = relationship_changes[from_char][to_char][dimension]
				get_node("/root/RelationshipSystem").change_relationship(from_char, to_char, dimension, change_value)
	
	# Get choices
	active_choices = []
	var choices = node_data.get("choices", [])
	
	for choice in choices:
		# Check if this choice should be shown
		var should_show = true
		
		# Check conditions
		var conditions = choice.get("conditions", {})
		for condition_type in conditions:
			match condition_type:
				"emotion_min":
					for char_id in conditions[condition_type]:
						for emotion_type in conditions[condition_type][char_id]:
							var required_value = conditions[condition_type][char_id][emotion_type]
							var current_value = get_node("/root/EmotionSystem").get_emotion(char_id, emotion_type)
							if current_value < required_value:
								should_show = false
				
				"emotion_max":
					for char_id in conditions[condition_type]:
						for emotion_type in conditions[condition_type][char_id]:
							var required_value = conditions[condition_type][char_id][emotion_type]
							var current_value = get_node("/root/EmotionSystem").get_emotion(char_id, emotion_type)
							if current_value > required_value:
								should_show = false
				
				"relationship_min":
					for from_char in conditions[condition_type]:
						for to_char in conditions[condition_type][from_char]:
							for dimension in conditions[condition_type][from_char][to_char]:
								var required_value = conditions[condition_type][from_char][to_char][dimension]
								var current_value = get_node("/root/RelationshipSystem").get_relationship_dimension(from_char, to_char, dimension)
								if current_value < required_value:
									should_show = false
				
				"flag":
					for flag_name in conditions[condition_type]:
						var required_value = conditions[condition_type][flag_name]
						var current_value = get_node("/root/GameState").get_story_flag(flag_name)
						if current_value != required_value:
							should_show = false
		
		if should_show:
			active_choices.append(choice)
	
	# If no choices, and there's a next node, automatically progress
	if active_choices.size() == 0 and "next" in node_data:
		current_node = node_data["next"]
		return process_current_node()
	
	return true

# Make a choice in the current dialogue
func make_choice(choice_index):
	if choice_index < 0 or choice_index >= active_choices.size():
		return false
	
	var choice = active_choices[choice_index]
	
	# Add choice to history
	dialogue_history.append({
		"choice": choice.get("text", ""),
		"choice_id": choice.get("id", "")
	})
	
	emit_signal("dialogue_choice_made", choice.get("id", ""), choice.get("text", ""))
	
	# Apply choice effects
	
	# Emotion changes
	var emotion_changes = choice.get("emotion_changes", {})
	for character_id in emotion_changes:
		for emotion_type in emotion_changes[character_id]:
			var change_value = emotion_changes[character_id][emotion_type]
			var emotion_system = get_node("/root/EmotionSystem")
			
			var old_value = emotion_system.get_emotion(character_id, emotion_type)
			emotion_system.change_emotion(character_id, emotion_type, change_value)
			var new_value = emotion_system.get_emotion(character_id, emotion_type)
			
			emit_signal("dialogue_emotion_changed", character_id, emotion_type, old_value, new_value)
	
	# Relationship changes
	var relationship_changes = choice.get("relationship_changes", {})
	for from_char in relationship_changes:
		for to_char in relationship_changes[from_char]:
			for dimension in relationship_changes[from_char][to_char]:
				var change_value = relationship_changes[from_char][to_char][dimension]
				get_node("/root/RelationshipSystem").change_relationship(from_char, to_char, dimension, change_value)
	
	# Set flags
	var flags = choice.get("flags", {})
	for flag_name in flags:
		get_node("/root/GameState").set_story_flag(flag_name, flags[flag_name])
	
	# Move to the next node
	if "next" in choice:
		current_node = choice["next"]
		return process_current_node()
	else:
		# End of dialogue
		emit_signal("dialogue_ended", current_dialogue)
		current_dialogue = null
		current_node = null
		return false

# Get the current dialogue text
func get_current_text():
	if current_dialogue == null or current_node == null:
		return ""
	
	var node_data = dialogue_library[current_dialogue]["nodes"][current_node]
	return node_data.get("text", "")

# Get the current dialogue speaker
func get_current_speaker():
	if current_dialogue == null or current_node == null:
		return ""
	
	var node_data = dialogue_library[current_dialogue]["nodes"][current_node]
	return node_data.get("speaker", "")

# Get the current choices
func get_current_choices():
	return active_choices