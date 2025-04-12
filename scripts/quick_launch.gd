extends Node

# 此脚本用于快速启动游戏并设置默认玩家角色
# 用于开发测试，绕过角色选择界面

func _ready():
	print("快速启动模式 - 直接进入游戏")
	
	# 等待一帧以确保所有节点都准备好
	await get_tree().process_frame
	
	# 获取游戏状态
	var game_state = get_node("/root/GameState")
	var emotion_system = get_node("/root/EmotionSystem")
	var relationship_system = get_node("/root/RelationshipSystem")
	
	# 设置默认玩家角色
	var default_character = "erika"
	print("设置默认玩家角色:", default_character)
	game_state.set_player_character(default_character)
	
	# 重置情感和关系系统
	emotion_system.reset_emotions()
	relationship_system.reset_relationships()
	
	# 确认玩家角色已设置
	var player_char = game_state.get_player_character()
	if player_char != default_character:
		push_error("设置默认角色失败!")
		return
	
	print("准备加载游戏场景...")
	
	# 直接加载游戏场景
	var scene = load("res://scenes/game_scene.tscn")
	if scene:
		# 使用实例化方式加载场景
		var instance = scene.instantiate()
		get_tree().root.add_child(instance)
		if get_tree().current_scene != null:
			get_tree().current_scene.queue_free()
		get_tree().current_scene = instance
		print("游戏场景加载完成")
	else:
		push_error("加载游戏场景失败")
		get_tree().change_scene_to_file("res://scenes/game_scene.tscn") 