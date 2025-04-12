extends Node

@onready var dialogue_scene_controller = $DialogueSceneController
@onready var environment_display = $EnvironmentDisplay
@onready var menu_button = $MenuButton
@onready var background = $Background

var game_state
var environment_system
var current_scene_type = null
var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
var pause_menu = null
var background_manager = load("res://scripts/core/background_manager.gd").new()
var resource_validator = load("res://scripts/utils/resource_validator.gd").new()

func _ready():
	game_state = get_node("/root/GameState")
	environment_system = get_node("/root/EnvironmentSystem")
	
	print("游戏场景初始化开始")
	
	# 强制确保玩家角色已设置（即使没有角色选择过程）
	var player_char = game_state.get_player_character()
	if player_char == null:
		print("游戏场景中检测到玩家角色未设置，将使用默认角色")
		# 设置默认角色以确保游戏能运行
		game_state.set_player_character("erika")
		player_char = "erika"
	
	print("游戏场景使用玩家角色:", player_char)
	
	# Connect signals
	menu_button.connect("pressed", Callable(self, "_on_menu_button_pressed"))
	environment_system.connect("environment_changed", Callable(self, "_on_environment_changed"))
	
	# Set initial environment based on first scene
	set_initial_environment()
	
	# 强制初始化所有系统
	_force_init_systems()
	
	# Start the first dialogue based on player character
	dialogue_scene_controller.start_dialogue("chapter1_intro")
	
	# Update environment display
	update_environment_display()
	
	print("游戏场景初始化完成")

func _force_init_systems():
	# 强制初始化所有游戏系统，确保即使没有正确加载也能工作
	print("强制初始化游戏系统...")
	
	# 验证资源加载
	validate_resources()
	
	# 尝试预加载关键资源
	preload_key_resources()
	
	var player_char = game_state.get_player_character()
	if player_char == null:
		push_error("严重错误：玩家角色为null，游戏无法正常运行")
		return
		
	# 初始化情感系统
	var emotion_system = get_node("/root/EmotionSystem")
	if not emotion_system.character_emotions.has(player_char):
		print("情感系统中未找到角色数据，强制重置...")
		emotion_system.reset_emotions()
	
	# 确认情感系统正确初始化
	if emotion_system.character_emotions.has(player_char):
		print("情感系统正常，玩家角色情感数据可用")
	else:
		push_error("情感系统初始化失败，游戏将无法显示情感数据")
	
	# 初始化关系系统
	var relationship_system = get_node("/root/RelationshipSystem")
	if not relationship_system.relationships.has(player_char):
		print("关系系统中未找到角色数据，强制重置...")
		relationship_system.reset_relationships()
	
	# 确认关系系统正确初始化
	if relationship_system.relationships.has(player_char):
		print("关系系统正常，玩家角色关系数据可用")
	else:
		push_error("关系系统初始化失败，游戏将无法显示关系数据")
	
	# 验证资源文件
	print("验证基本资源文件...")
	var default_portrait = "res://assets/characters/_neutral.png"
	var narrator_icon = "res://assets/ui/narrator_icon.png"
	var system_icon = "res://assets/ui/system_icon.png"
	
	var missing_files = []
	if not ResourceLoader.exists(default_portrait):
		missing_files.append(default_portrait)
	if not ResourceLoader.exists(narrator_icon):
		missing_files.append(narrator_icon)
	if not ResourceLoader.exists(system_icon):
		missing_files.append(system_icon)
	
	if missing_files.size() > 0:
		push_warning("警告：以下资源文件缺失，界面可能无法正常显示:")
		for file in missing_files:
			push_warning("- " + file)
	else:
		print("所有必需资源文件可用")

func set_initial_environment():
	# Set initial environment based on first scene in chapter 1
	environment_system.change_environment(
		environment_system.SceneType.RESEARCH,
		environment_system.Weather.CLEAR,
		environment_system.TimeOfDay.MORNING,
		environment_system.Temperature.MILD
	)
	
	# Set initial background
	update_background(environment_system.SceneType.RESEARCH)

func update_environment_display():
	# Update the environment display UI
	var env_desc = environment_system.get_environment_description()
	environment_display.text = env_desc

func _on_environment_changed(old_env, new_env):
	# Update environment display when environment changes
	update_environment_display()
	
	# Update background image if scene type changed
	if old_env["scene_type"] != new_env["scene_type"]:
		update_background(new_env["scene_type"])
	
	# Apply environmental effects to all characters
	for character_id in game_state.CHARACTERS:
		environment_system.apply_environment_effects(character_id)
		
func update_background(scene_type):
	# Load and set background texture based on scene type
	print("尝试更新背景，场景类型:", scene_type)
	
	# 首先尝试直接从assets/background目录加载
	var bg_path = "res://assets/background/background_"
	var scene_name = ""
	
	# 确定场景名称
	match scene_type:
		environment_system.SceneType.RESEARCH:
			scene_name = "research"
		environment_system.SceneType.PRIVATE:
			scene_name = "private"
		environment_system.SceneType.PUBLIC:
			scene_name = "public"
		environment_system.SceneType.BOUNDARY:
			scene_name = "boundary"
		environment_system.SceneType.CRISIS:
			scene_name = "crisis"
		_:
			scene_name = "research" # 默认使用研究场景
	
	# 完整路径
	bg_path = bg_path + scene_name + ".png"
	print("尝试加载背景:", bg_path)
	
	# 直接尝试加载
	var texture = null
	
	if ResourceLoader.exists(bg_path):
		texture = load(bg_path)
		if texture:
			print("成功加载背景:", bg_path)
		else:
			print("加载背景失败:", bg_path)
	else:
		print("背景资源不存在:", bg_path)
	
	# 如果第一次尝试失败，尝试从backgrounds目录加载
	if not texture:
		bg_path = "res://assets/backgrounds/background_" + scene_name + ".png"
		print("尝试加载备用背景:", bg_path)
		
		if ResourceLoader.exists(bg_path):
			texture = load(bg_path)
			if texture:
				print("成功加载备用背景:", bg_path)
			else:
				print("加载备用背景失败:", bg_path)
		else:
			print("备用背景资源不存在:", bg_path)
	
	# 如果仍然失败，使用背景管理器尝试加载
	if not texture:
		print("尝试使用背景管理器加载背景")
		texture = background_manager.load_background(scene_type)
	
	# 如果有纹理，设置背景
	if texture:
		print("成功获取背景纹理，设置到背景节点")
		background.texture = texture
		print("背景已更新为:", scene_type)
	else:
		print("警告: 无法加载任何背景纹理，将使用纯色背景")
		# 创建一个纯色纹理作为背景
		var color = Color(0.2, 0.2, 0.2) # 深灰色
		
		# 根据场景类型调整颜色
		match scene_type:
			environment_system.SceneType.RESEARCH:
				color = Color(0.2, 0.3, 0.4) # 蓝灰色
			environment_system.SceneType.PRIVATE:
				color = Color(0.4, 0.3, 0.2) # 暖棕色
			environment_system.SceneType.PUBLIC:
				color = Color(0.3, 0.3, 0.3) # 灰色
			environment_system.SceneType.BOUNDARY:
				color = Color(0.2, 0.2, 0.3) # 深紫灰色
			environment_system.SceneType.CRISIS:
				color = Color(0.4, 0.2, 0.2) # 深红色
		
		var color_texture = create_color_texture(color)
		background.texture = color_texture
		print("使用生成的纯色背景替代")

func _on_menu_button_pressed():
	# Show pause menu
	if pause_menu == null:
		pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)
		pause_menu.connect("resumed", Callable(self, "_on_game_resumed"))
		pause_menu.connect("quit_to_main", Callable(self, "_on_quit_to_main"))
		get_tree().paused = true
	else:
		remove_child(pause_menu)
		pause_menu = null
		get_tree().paused = false

# 验证资源加载
func validate_resources():
	print("开始验证游戏资源...")
	
	# 验证角色肖像
	validate_character_portraits()
	
	# 验证背景图像
	validate_backgrounds()
	
	print("资源验证完成")

# 验证角色肖像
func validate_character_portraits():
	print("验证角色肖像资源...")
	var characters = ["erika", "isa", "neil", "kai"]
	
	for character in characters:
		# 检查基本肖像
		var base_path = "res://assets/characters/" + character + ".png"
		var neutral_path = "res://assets/characters/" + character + "_neutral.png"
		
		var base_exists = ResourceLoader.exists(base_path)
		var neutral_exists = ResourceLoader.exists(neutral_path)
		
		print(character + " 基本肖像: " + ("存在" if base_exists else "不存在"))
		print(character + " 中性肖像: " + ("存在" if neutral_exists else "不存在"))

# 验证背景图像
func validate_backgrounds():
	print("验证背景图像资源...")
	var scene_types = ["research", "private", "public", "boundary", "crisis"]
	
	for scene_type in scene_types:
		# 检查background目录
		var bg_path = "res://assets/background/background_" + scene_type + ".png"
		var bg_exists = ResourceLoader.exists(bg_path)
		
		# 检查backgrounds目录
		var bgs_path = "res://assets/backgrounds/background_" + scene_type + ".png"
		var bgs_exists = ResourceLoader.exists(bgs_path)
		
		print(scene_type + " 背景(无s): " + ("存在" if bg_exists else "不存在"))
		print(scene_type + " 背景(有s): " + ("存在" if bgs_exists else "不存在"))

# 预加载关键资源
func preload_key_resources():
	print("预加载关键资源...")
	
	# 预加载一些关键背景
	var preloaded_resources = []
	
	# 尝试预加载研究场景背景
	var research_bg_path = "res://assets/background/background_research.png"
	if ResourceLoader.exists(research_bg_path):
		var research_bg = load(research_bg_path)
		if research_bg:
			preloaded_resources.append("研究场景背景")
		else:
			print("加载研究场景背景失败")
	else:
		print("无法预加载研究场景背景")
	
	# 尝试预加载角色肖像
	var erika_portrait_path = "res://assets/characters/erika.png"
	if ResourceLoader.exists(erika_portrait_path):
		var erika_portrait = load(erika_portrait_path)
		if erika_portrait:
			preloaded_resources.append("Erika肖像")
		else:
			print("加载Erika肖像失败")
	else:
		print("无法预加载Erika肖像")
	
	print("成功预加载资源: " + str(preloaded_resources))

# 创建纯色纹理作为背景
func create_color_texture(color = Color(0.2, 0.3, 0.7)):
	print("创建纯色纹理作为背景替代")
	var image = Image.create(1280, 720, false, Image.FORMAT_RGBA8)
	image.fill(color)
	var texture = ImageTexture.create_from_image(image)
	return texture

func _on_game_resumed():
	# Resume game
	remove_child(pause_menu)
	pause_menu = null
	get_tree().paused = false

func _on_quit_to_main():
	# Save game before quitting
	game_state.save_game("quicksave")
	
	# Unpause and return to main menu
	get_tree().paused = false
	
	# 使用更安全的方式切换到主菜单场景
	var main_menu_scene = load("res://scenes/main_menu.tscn")
	if main_menu_scene:
		# 先实例化场景确保它有效
		var instance = main_menu_scene.instantiate()
		# 通过替换当前场景的方式加载
		get_tree().root.add_child(instance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = instance
	else:
		# 备用方案
		push_warning("无法加载主菜单场景，尝试直接切换")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	# Quick save with F5
	if event.is_action_pressed("ui_save"):
		game_state.save_game("quicksave")
		print("Game saved")
		
	# Quick load with F8
	if event.is_action_pressed("ui_load"):
		if game_state.load_game("quicksave"):
			print("Game loaded")
			# Restart current dialogue
			if game_state.current_scene:
				dialogue_scene_controller.start_dialogue(game_state.current_scene) 