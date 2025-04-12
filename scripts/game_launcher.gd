extends Node

# 游戏启动器：确保正确初始化所有系统和资源
# 放置在Global Autoload中，优先于其他系统

func _ready():
	print("游戏启动器初始化...")
	
	# 确保基本资源存在
	_ensure_basic_resources()
	
	# 初始化系统
	_init_game_systems()
	
	# 启动合适的场景
	_launch_appropriate_scene()

func _ensure_basic_resources():
	print("检查基本资源...")
	var default_portrait_path = "res://assets/characters/_neutral.png"
	var narrator_icon_path = "res://assets/ui/narrator_icon.png"
	var system_icon_path = "res://assets/ui/system_icon.png"
	
	var missing_resources = []
	
	if not FileAccess.file_exists(default_portrait_path):
		missing_resources.append(default_portrait_path)
	
	if not FileAccess.file_exists(narrator_icon_path):
		missing_resources.append(narrator_icon_path)
	
	if not FileAccess.file_exists(system_icon_path):
		missing_resources.append(system_icon_path)
	
	if missing_resources.size() > 0:
		print("警告：缺少关键资源文件:")
		for path in missing_resources:
			print("  - ", path)
		
		print("尝试创建必要的资源文件...")
		_create_default_resources(missing_resources)
	else:
		print("所有基本资源文件已存在")

func _create_default_resources(missing_paths):
	for path in missing_paths:
		if path.ends_with("_neutral.png"):
			_create_image(path, Color(0.5, 0.5, 0.5))
		elif path.ends_with("narrator_icon.png"):
			_create_image(path, Color(0.3, 0.3, 0.6))
		elif path.ends_with("system_icon.png"):
			_create_image(path, Color(0.6, 0.3, 0.3))

func _create_image(path, color):
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	var dir_path = path.get_base_dir()
	var dir = DirAccess.open("res://")
	if not dir.dir_exists(dir_path):
		dir.make_dir_recursive(dir_path)
	
	var err = image.save_png(path)
	if err != OK:
		push_error("无法创建资源: " + path)
	else:
		print("已创建资源: " + path)

func _init_game_systems():
	print("初始化游戏系统...")
	
	var game_state = get_node("/root/GameState")
	var emotion_system = get_node("/root/EmotionSystem")
	var relationship_system = get_node("/root/RelationshipSystem")
	
	# 确保有默认玩家角色
	if game_state.get_player_character() == null:
		# 仅在开发测试时使用默认值
		var default_character = "erika"
		game_state.set_player_character(default_character)
		print("设置临时测试用默认角色: ", default_character)
		print("注意：此为开发测试模式，正式游戏中应从角色选择界面选择角色")
	
	# 确保情感和关系系统初始化
	if not emotion_system.character_emotions.has(game_state.get_player_character()):
		print("重置情感系统...")
		emotion_system.reset_emotions()
	
	if not relationship_system.relationships.has(game_state.get_player_character()):
		print("重置关系系统...")
		relationship_system.reset_relationships()
	
	print("系统初始化完成")

func _launch_appropriate_scene():
	print("启动游戏场景...")
	
	var game_state = get_node("/root/GameState")
	
	# 获取当前场景
	var current_scene = get_tree().current_scene
	if current_scene != null:
		var scene_name = current_scene.name
		print("当前场景: ", scene_name)
		
		# 如果已经在游戏场景，不需要重新加载
		if scene_name == "GameScene":
			print("已在游戏场景中，无需加载")
			return
	
	# 在正式版中，这里应该跳转到主菜单或角色选择
	# 但为了调试，直接加载游戏场景
	print("加载游戏场景...")
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn") 