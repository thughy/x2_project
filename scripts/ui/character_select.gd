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
	
	print("角色选择界面初始化")
	print("可用角色:", game_state.CHARACTERS)
	
	# Connect button signals
	isa_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("isa"))
	erika_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("erika"))
	neil_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("neil"))
	kai_button.connect("pressed", Callable(self, "_on_character_button_pressed").bind("kai"))
	start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	
	# Start button initially disabled
	start_button.disabled = true
	
	# Set up character portraits
	_setup_character_portraits()
	
	# Clear character info
	character_info.text = "选择一个角色开始游戏"

func _setup_character_portraits():
	# 使用更可靠的方法加载角色肖像
	var characters = ["isa", "erika", "neil", "kai"]
	
	for char_id in characters:
		print("加载角色选择肖像:", char_id)
		var texture = load_character_portrait(char_id)
		
		# 如果成功加载了纹理，设置到相应的按钮
		if texture:
			match char_id:
				"isa": isa_button.icon = texture
				"erika": erika_button.icon = texture
				"neil": neil_button.icon = texture
				"kai": kai_button.icon = texture
			print("成功设置角色头像:", char_id)
		else:
			print("警告: 无法加载角色头像，将使用占位符:", char_id)
			var placeholder = create_placeholder_texture(get_character_color(char_id))
			match char_id:
				"isa": isa_button.icon = placeholder
				"erika": erika_button.icon = placeholder
				"neil": neil_button.icon = placeholder
				"kai": kai_button.icon = placeholder

# 加载角色肖像，使用与对话界面相同的逻辑
func load_character_portrait(character_id, emotion="neutral"):
	# 专门处理肖像加载逻辑
	var portrait_loaded = false
	var final_texture = null
	
	print("尝试加载角色肖像:", character_id)
	
	# 尝试加载方式1: 基本角色肖像（没有情绪后缀）
	var base_path = "res://assets/characters/" + character_id + ".png"
	print("尝试路径1:", base_path)
	
	if ResourceLoader.exists(base_path):
		var texture = load(base_path)
		if texture:
			final_texture = texture
			print("成功加载基本肖像:", base_path)
			portrait_loaded = true
		else:
			print("加载基本肖像失败:", base_path)
	else:
		print("基本肖像不存在:", base_path)
	
	# 尝试加载方式2: 中性表情
	if not portrait_loaded:
		var neutral_path = "res://assets/characters/" + character_id + "_neutral.png"
		print("尝试路径2:", neutral_path)
		
		if ResourceLoader.exists(neutral_path):
			var texture = load(neutral_path)
			if texture:
				final_texture = texture
				print("成功加载中性肖像:", neutral_path)
				portrait_loaded = true
			else:
				print("加载中性肖像失败:", neutral_path)
		else:
			print("中性肖像不存在:", neutral_path)
	
	# 尝试加载方式3: 默认肖像
	if not portrait_loaded:
		var default_path = "res://assets/characters/_neutral.png"
		print("尝试路径3:", default_path)
		
		if ResourceLoader.exists(default_path):
			var texture = load(default_path)
			if texture:
				final_texture = texture
				print("成功加载默认肖像:", default_path)
				portrait_loaded = true
			else:
				print("加载默认肖像失败:", default_path)
		else:
			print("默认肖像不存在:", default_path)
	
	return final_texture

# 根据角色ID获取颜色
func get_character_color(character_id):
	# 根据角色ID生成不同的颜色
	var color = Color(0.7, 0.7, 0.7) # 默认灰色
	
	if character_id == "erika":
		color = Color(0.8, 0.4, 0.4) # 红色调
	elif character_id == "isa":
		color = Color(0.4, 0.6, 0.8) # 蓝色调
	elif character_id == "neil":
		color = Color(0.4, 0.8, 0.4) # 绿色调
	elif character_id == "kai":
		color = Color(0.8, 0.8, 0.4) # 黄色调
	
	return color

# 创建占位符纹理
func create_placeholder_texture(color):
	# 创建一个简单的纯色纹理作为肖像占位符
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(color)
	var texture = ImageTexture.create_from_image(image)
	return texture

func _on_character_button_pressed(character_id):
	# Store selected character
	selected_character = character_id
	print("选择角色:", character_id)
	
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
		print("开始游戏，选择角色:", selected_character)
		
		# 确保所有系统重置
		emotion_system.reset_emotions()
		get_node("/root/RelationshipSystem").reset_relationships()
		
		# 设置玩家角色并验证
		game_state.set_player_character(selected_character)
		var player_char = game_state.get_player_character()
		print("玩家角色设置为:", player_char)
		
		if player_char != selected_character:
			push_error("玩家角色设置失败!")
			return
		
		# 启动游戏场景
		get_tree().change_scene_to_file("res://scenes/game_scene.tscn") 