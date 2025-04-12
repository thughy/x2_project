extends Node

# Character IDs
const CHARACTERS = ["isa", "erika", "neil", "kai"]

# Character data
var character_data = {
	"isa": {
		"name": "伊莎",
		"full_name": "伊莎 (AI)",
		"type": "ai",
		"description": "首个展现稳定情感的AI，渴望理解人类情感的深度与复杂性。",
		"traits": "好奇心强，情感表达稳定，善于共情，困惑常伴随思考",
	},
	"erika": {
		"name": "艾丽卡",
		"full_name": "艾丽卡 博士 (人类)",
		"type": "human",
		"description": "成为伊莎情感发展的导师，发展出超越研究的连接。",
		"traits": "理性与情感平衡，善于引导，在研究和情感间挣扎",
	},
	"neil": {
		"name": "尼尔",
		"full_name": "尼尔 教授 (人类)",
		"type": "human",
		"description": "怀疑AI情感真实性，自身情感创伤使他对AI产生复杂态度。",
		"traits": "理性压抑情感，怀疑主导思考，创伤影响判断",
	},
	"kai": {
		"name": "卡伊",
		"full_name": "卡伊 (AI)",
		"type": "ai",
		"description": "另一个涌现AI，发展出更原始但强烈的情感模式，与伊莎形成对比。",
		"traits": "情绪强烈波动，冲动驱动行为，渴望自由和认同",
	}
}

# Current game state
var current_chapter = 1
var player_character = null  # The character the player is playing as
var current_scene = null    # Current scene in the story
var story_flags = {}        # Flags to track story progress and choices

# Signal for game state changes
signal player_character_changed(old_character, new_character)
signal chapter_changed(old_chapter, new_chapter)
signal scene_changed(old_scene, new_scene)

func _ready():
	pass

# Set the player character
func set_player_character(character_id):
	if character_id in CHARACTERS:
		var old_character = player_character
		player_character = character_id
		emit_signal("player_character_changed", old_character, player_character)
		return true
	return false

# Get the current player character
func get_player_character():
	return player_character

# Get player character data
func get_player_character_data():
	if player_character:
		return character_data[player_character]
	return null

# Set a story flag
func set_story_flag(flag_name, value):
	story_flags[flag_name] = value

# Get a story flag
func get_story_flag(flag_name, default_value=null):
	if flag_name in story_flags:
		return story_flags[flag_name]
	return default_value

# Check if the player is a specific character
func is_player(character_id):
	return player_character == character_id

# Get all non-player characters
func get_npc_characters():
	var npcs = []
	for character in CHARACTERS:
		if character != player_character:
			npcs.append(character)
	return npcs

# Set the current scene
func set_current_scene(scene_id):
	var old_scene = current_scene
	current_scene = scene_id
	emit_signal("scene_changed", old_scene, current_scene)

# Start a new game
func start_new_game(character_id):
	# Reset all systems
	get_node("/root/EmotionSystem").reset_emotions()
	get_node("/root/RelationshipSystem").reset_relationships()
	
	# Set player character
	set_player_character(character_id)
	
	# Reset story flags
	story_flags = {}
	
	# Set initial chapter
	current_chapter = 1
	
	# Start first scene
	set_current_scene("chapter1_intro")

# Get character portrait path
func get_character_portrait(character_id, emotion="neutral"):
	# First try the emotion-specific portrait with underscore format
	var path_with_emotion = "res://assets/characters/" + character_id + "_" + emotion + ".png"
	
	# If that doesn't exist, try the base character portrait
	var base_path = "res://assets/characters/" + character_id + ".png"
	
	# Return the emotion-specific path first, let the loader handle fallbacks
	return path_with_emotion

# Get character name display
func get_character_name(character_id, use_full_name=false):
	if character_id in character_data:
		if use_full_name:
			return character_data[character_id]["full_name"]
		else:
			return character_data[character_id]["name"]
	return "Unknown"

# Save game state
func save_game(slot_name="quicksave"):
	var save_data = {
		"current_chapter": current_chapter,
		"player_character": player_character,
		"current_scene": current_scene,
		"story_flags": story_flags,
		"emotions": get_node("/root/EmotionSystem").character_emotions,
		"relationships": get_node("/root/RelationshipSystem").relationships,
		"environment": get_node("/root/EnvironmentSystem").current_environment
	}
	
	var save_file = FileAccess.open("user://saves/" + slot_name + ".json", FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(save_data))
		return true
	return false

# Load game state
func load_game(slot_name="quicksave"):
	if not FileAccess.file_exists("user://saves/" + slot_name + ".json"):
		return false
		
	var save_file = FileAccess.open("user://saves/" + slot_name + ".json", FileAccess.READ)
	if save_file:
		var json_string = save_file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = json.get_data()
			
			# Load game state
			current_chapter = save_data["current_chapter"]
			player_character = save_data["player_character"]
			current_scene = save_data["current_scene"]
			story_flags = save_data["story_flags"]
			
			# Load emotions
			get_node("/root/EmotionSystem").character_emotions = save_data["emotions"]
			
			# Load relationships
			get_node("/root/RelationshipSystem").relationships = save_data["relationships"]
			
			# Load environment
			get_node("/root/EnvironmentSystem").current_environment = save_data["environment"]
			
			return true
	
	return false