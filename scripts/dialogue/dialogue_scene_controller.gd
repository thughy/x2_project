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
	# 检查是否有基于玩家角色的特定对话
	var player_char = game_state.get_player_character()
	var player_specific_dialogue = dialogue_id + "_" + player_char
	
	print("[对话控制器] 尝试启动对话:", dialogue_id)
	print("[对话控制器] 玩家角色:", player_char)
	print("[对话控制器] 检查是否有特定角色对话:", player_specific_dialogue)
	
	# 列出所有可用的对话 ID
	print("[对话控制器] 所有可用的对话 ID:")
	for id in dialogue_manager.dialogue_library.keys():
		print("  - ", id)
	
	# 如果存在特定角色的对话，使用它
	if dialogue_manager.dialogue_library.has(player_specific_dialogue):
		print("[对话控制器] 找到特定角色对话，使用:", player_specific_dialogue)
		dialogue_id = player_specific_dialogue
	else:
		print("[对话控制器] 未找到特定角色对话，使用默认对话:", dialogue_id)
	
	current_dialogue_id = dialogue_id
	
	# 尝试启动对话
	var success = dialogue_manager.start_dialogue(dialogue_id)
	if success:
		print("[对话控制器] 对话成功启动:", dialogue_id)
		update_dialogue_ui()
		return true
	else:
		print("[对话控制器] 对话启动失败:", dialogue_id)
		return false

func update_dialogue_ui():
	# Get current dialogue info
	var speaker = dialogue_manager.get_current_speaker()
	
	# Debug output
	print("[对话控制器] 当前对话 ID:", current_dialogue_id)
	print("[对话控制器] 当前对话说话者:", speaker)
	print("[对话控制器] 当前玩家角色:", game_state.get_player_character())
	
	# 获取当前对话节点的详细信息
	var current_node = dialogue_manager.get_current_node()
	if current_node:
		print("[对话控制器] 当前对话节点:")
		for key in current_node.keys():
			print("  - ", key, ": ", current_node[key])
	
	# Special handling for player character
	if speaker == "player":
		# 保留"player"标识符，让UI处理它
		# 这样可以避免在角色特定对话中出现问题
		print("[对话控制器] 当前说话者是玩家角色，保留player标识符")
	
	var text = dialogue_manager.get_current_text()
	var choices = dialogue_manager.get_current_choices()
	
	# 打印当前对话文本和选项
	print("[对话控制器] 当前对话文本: \"", text, "\"")
	if choices and choices.size() > 0:
		print("[对话控制器] 当前对话选项:")
		for i in range(choices.size()):
			print("  ", i+1, ". ", choices[i]["text"])
	var node_data = null
	
	if dialogue_manager.current_dialogue != null and dialogue_manager.current_node != null:
		node_data = dialogue_manager.dialogue_library[dialogue_manager.current_dialogue]["nodes"][dialogue_manager.current_node]
		print("当前对话ID:", dialogue_manager.current_dialogue, "节点ID:", dialogue_manager.current_node)
	
	var emotion = "neutral"
	if node_data and "emotion" in node_data:
		emotion = node_data["emotion"]
		print("情绪状态:", emotion)
	
	# Display the dialogue
	dialogue_ui.display_dialogue(speaker, text, emotion)
	
	# If there are choices, display them
	if choices.size() > 0:
		print("显示选择项:", choices.size(), "个")
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
	
	print("检查场景转换 - 当前标志:", flags)
	
	# Check if we need to go to a new scene
	if "goto_lab_scene" in flags and flags["goto_lab_scene"]:
		print("转换到实验室场景")
		# 更新环境系统的场景类型
		environment_system.change_environment(environment_system.SceneType.PRIVATE)
		print("环境系统已更新为实验室场景")
		start_dialogue("chapter1_lab_scene")
		return true
	
	if "goto_crisis_scene" in flags and flags["goto_crisis_scene"]:
		print("转换到危机场景")
		# 更新环境系统的场景类型
		environment_system.change_environment(environment_system.SceneType.CRISIS)
		print("环境系统已更新为危机场景")
		start_dialogue("chapter1_crisis_scene")
		return true
	
	if "goto_resolution_scene" in flags and flags["goto_resolution_scene"]:
		print("转换到结局场景")
		# 更新环境系统的场景类型
		environment_system.change_environment(environment_system.SceneType.BOUNDARY)
		print("环境系统已更新为结局场景")
		start_dialogue("chapter1_resolution")
		return true
	
	if "return_to_main" in flags and flags["return_to_main"]:
		# Return to main menu
		print("返回主菜单")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return true
	
	return false

func _on_dialogue_advanced():
	print("对话前进")
	
	# Process flags before advancing to check for scene transitions
	if check_scene_transition():
		return
	
	# Clear choices just in case
	dialogue_ui.clear_choices()
	
	# Advance to the next node
	print("处理当前对话节点")
	dialogue_manager.process_current_node()
	
	# Update the UI
	update_dialogue_ui()

func _on_choice_selected(choice_index):
	print("选择了选项:", choice_index)
	
	# Make the choice
	if dialogue_manager.make_choice(choice_index):
		# Update the UI
		update_dialogue_ui()
	else:
		# Check for scene transitions
		check_scene_transition() 