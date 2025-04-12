extends Node

# 此脚本用于启动游戏并显示角色选择界面

var game_state
var emotion_system
var relationship_system

func _ready():
	print("快速启动模式")
	
	# 等待一帧以确保所有节点都准备好
	await get_tree().process_frame
	
	# 获取游戏状态
	game_state = get_node("/root/GameState")
	emotion_system = get_node("/root/EmotionSystem")
	relationship_system = get_node("/root/RelationshipSystem")
	
	# 重置情感和关系系统
	emotion_system.reset_emotions()
	relationship_system.reset_relationships()
	
	# 显示角色选择界面
	show_character_select()

# 显示角色选择界面
func show_character_select():
	# 首先移除当前场景
	self.queue_free()
	
	# 直接切换到角色选择场景
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")
	print("切换到角色选择界面")

# 处理角色选择
func _on_character_selected(character_id):
	print("选择了角色:", character_id)
	
	# 设置玩家角色
	game_state.set_player_character(character_id)
	
	# 确认玩家角色已设置
	var player_char = game_state.get_player_character()
	if player_char != character_id:
		push_error("设置角色失败!")
		return
	
	# 加载游戏场景
	load_game_scene()

# 加载游戏场景
func load_game_scene():
	print("准备加载游戏场景...")
	
	# 加载游戏场景
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