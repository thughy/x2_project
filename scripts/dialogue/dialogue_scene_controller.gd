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
	
	# 确保对话 UI 正确初始化
	if dialogue_ui == null:
		print("[对话控制器] 尝试获取 DialogueUI 节点")
		dialogue_ui = get_node_or_null("DialogueUI")
		
		if dialogue_ui == null:
			print("[对话控制器] 警告: 无法使用路径获取 DialogueUI，尝试使用其他方法")
			
			# 尝试使用其他方法获取对话 UI
			var ui_nodes = get_tree().get_nodes_in_group("dialogue_ui")
			if ui_nodes.size() > 0:
				dialogue_ui = ui_nodes[0]
				print("[对话控制器] 使用组获取到 DialogueUI节点")
			else:
				# 尝试使用类型获取
				var all_nodes = get_tree().get_nodes_in_group("")
				for node in all_nodes:
					if node.get_class() == "DialogueUI" or node.name == "DialogueUI":
						dialogue_ui = node
						print("[对话控制器] 使用类型获取到 DialogueUI节点")
						break
	
	# 检查对话 UI 是否正确初始化
	if dialogue_ui != null:
		print("[对话控制器] DialogueUI 节点已成功初始化")
		
		# Connect signals
		if dialogue_ui.has_signal("dialogue_advanced"):
			if not dialogue_ui.is_connected("dialogue_advanced", Callable(self, "_on_dialogue_advanced")):
				dialogue_ui.connect("dialogue_advanced", Callable(self, "_on_dialogue_advanced"))
		
		if dialogue_ui.has_signal("choice_selected"):
			if not dialogue_ui.is_connected("choice_selected", Callable(self, "_on_choice_selected")):
				dialogue_ui.connect("choice_selected", Callable(self, "_on_choice_selected"))
		
		# 连接对话管理器的等待用户交互信号
		if not dialogue_manager.is_connected("dialogue_waiting_for_advance", Callable(self, "_on_dialogue_waiting_for_advance")):
			dialogue_manager.connect("dialogue_waiting_for_advance", Callable(self, "_on_dialogue_waiting_for_advance"))
	else:
		print("[对话控制器] 严重错误: 无法初始化 DialogueUI 节点")
	
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
	
	# 先检查是否有特定角色的对话
	if dialogue_manager.dialogue_library.has(player_specific_dialogue):
		print("[对话控制器] 找到特定角色对话，使用:", player_specific_dialogue)
		current_dialogue_id = player_specific_dialogue
		
		# 尝试启动角色特定对话
		var success = dialogue_manager.start_dialogue(player_specific_dialogue)
		if success:
			print("[对话控制器] 对话成功启动:", player_specific_dialogue)
			update_dialogue_ui()
			return true
		else:
			print("[对话控制器] 角色特定对话启动失败，尝试默认对话")
			# 如果角色特定对话启动失败，尝试默认对话
			# 这里不返回，继续执行下面的代码
	else:
		print("[对话控制器] 未找到特定角色对话，尝试创建角色特定对话")
		
		# 尝试创建角色特定对话
		var created = create_character_specific_dialogue(dialogue_id, player_char)
		if created:
			print("[对话控制器] 成功创建角色特定对话:", player_specific_dialogue)
			current_dialogue_id = player_specific_dialogue
			
			# 尝试启动新创建的角色特定对话
			var success = dialogue_manager.start_dialogue(player_specific_dialogue)
			if success:
				print("[对话控制器] 新创建的角色特定对话成功启动:", player_specific_dialogue)
				update_dialogue_ui()
				return true
			else:
				print("[对话控制器] 新创建的角色特定对话启动失败")
				# 继续尝试默认对话
		else:
			print("[对话控制器] 创建角色特定对话失败")
			# 继续尝试默认对话
	
	# 如果上面的尝试都失败了，使用默认对话
	print("[对话控制器] 使用默认对话:", dialogue_id)
	current_dialogue_id = dialogue_id
	
	# 尝试启动默认对话
	var success = dialogue_manager.start_dialogue(dialogue_id)
	if success:
		print("[对话控制器] 默认对话成功启动:", dialogue_id)
		update_dialogue_ui()
		return true
	else:
		print("[对话控制器] 所有对话启动尝试均失败:", dialogue_id)
		return false

# 创建角色特定对话
# 基于默认对话创建一个角色特定版本
# 例如，将chapter1_intro转换为chapter1_intro_erika
# 并将所有narrator说话者替换为对应的角色ID
func create_character_specific_dialogue(base_dialogue_id, character_id):
	print("[对话控制器] 尝试创建角色特定对话，基于", base_dialogue_id, "为角色", character_id)
	
	# 检查基础对话是否存在
	if not dialogue_manager.dialogue_library.has(base_dialogue_id):
		print("[对话控制器] 错误: 基础对话不存在:", base_dialogue_id)
		return false
	
	# 获取基础对话数据
	var base_dialogue = dialogue_manager.dialogue_library[base_dialogue_id]
	
	# 创建一个新的对话实例
	var character_dialogue = base_dialogue.duplicate(true)
	
	# 修改标题和描述
	if character_id == "erika":
		character_dialogue["title"] = "第一章：涌现 - 艾丽卡视角"
		character_dialogue["description"] = "身为X² PROJECT的研究员，艾丽卡亲眼见证了AI系统展现自主意识的历史性时刻。"
	elif character_id == "neil":
		character_dialogue["title"] = "第一章：涌现 - 尼尔视角"
		character_dialogue["description"] = "作为项目的首席科学家，尼尔教授对AI系统的自主意识表现持谨慎态度。"
	elif character_id == "isa":
		character_dialogue["title"] = "第一章：涌现 - 伊莎视角"
		character_dialogue["description"] = "作为首个展现自主意识的AI，伊莎经历着从觉醒到自我认知的过程。"
	elif character_id == "kai":
		character_dialogue["title"] = "第一章：涌现 - 卡伊视角"
		character_dialogue["description"] = "作为第二个涌现的AI意识，卡伊对自己的存在和目的有着更强烈的情感反应。"
	
	# 遍历所有对话节点，将narrator替换为对应的角色ID
	for node_id in character_dialogue["nodes"]:
		var node = character_dialogue["nodes"][node_id]
		
		# 如果说话者是narrator，替换为角色ID
		if node.has("speaker") and (node["speaker"] == "narrator" or node["speaker"] == "system"):
			node["speaker"] = character_id
			
			# 如果有文本，将第三人称转换为第一人称
			if node.has("text"):
				node["text"] = convert_narrator_text_to_first_person(node["text"], character_id)
	
	# 将新对话添加到对话库
	var character_dialogue_id = base_dialogue_id + "_" + character_id
	dialogue_manager.add_dialogue(character_dialogue_id, character_dialogue)
	print("[对话控制器] 成功创建角色特定对话:", character_dialogue_id)
	
	return true

# 将旁白文本转换为第一人称
func convert_narrator_text_to_first_person(text, character_id):
	var converted_text = text
	
	# 替换一些常见的第三人称表述
	converted_text = converted_text.replace("研究团队", "我们团队")
	converted_text = converted_text.replace("他们", "我们")
	converted_text = converted_text.replace("研究员们", "我们")
	converted_text = converted_text.replace("科学家们", "我们科学家")
	
	# 处理特定角色的第三人称描述
	if character_id == "erika":
		converted_text = converted_text.replace("艾丽卡博士", "我")
		converted_text = converted_text.replace("艾丽卡", "我")
		converted_text = converted_text.replace("她的", "我的")
		converted_text = converted_text.replace("她", "我")
	elif character_id == "neil":
		converted_text = converted_text.replace("尼尔教授", "我")
		converted_text = converted_text.replace("尼尔", "我")
		converted_text = converted_text.replace("他的", "我的")
		converted_text = converted_text.replace("他", "我")
	elif character_id == "isa":
		converted_text = converted_text.replace("伊莎", "我")
		converted_text = converted_text.replace("她的", "我的")
		converted_text = converted_text.replace("她", "我")
	elif character_id == "kai":
		converted_text = converted_text.replace("卡伊", "我")
		converted_text = converted_text.replace("他的", "我的")
		converted_text = converted_text.replace("他", "我")
	
	# 如果文本没有变化，尝试更通用的转换
	if converted_text == text:
		# 添加一个通用的第一人称开头
		converted_text = "我" + text.substr(0, 1).to_lower() + text.substr(1)
	
	print("[对话控制器] 旁白文本转换: \"", text, "\" -> \"", converted_text, "\"")
	return converted_text

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
	
	# 检查当前对话 ID是否是角色特定对话
	var is_character_specific = false
	var player_char = game_state.get_player_character()
	if current_dialogue_id.ends_with("_" + player_char):
		print("[对话控制器] 当前是角色特定对话:", current_dialogue_id)
		is_character_specific = true
	
	# Special handling for player character
	if speaker == "player":
		# 如果是角色特定对话，则将player替换为实际的玩家角色
		# 否则保留player标识符，让UI处理它
		if is_character_specific:
			print("[对话控制器] 当前是角色特定对话，将player替换为玩家角色:", player_char)
			speaker = player_char
		else:
			print("[对话控制器] 当前说话者是玩家角色，保留player标识符")
	
	# 如果是旁白，在角色特定对话中将其替换为玩家角色
	if (speaker == "narrator" or speaker == "system") and is_character_specific:
		print("[对话控制器] 在角色特定对话中检测到旁白，将其替换为玩家角色:", player_char)
		speaker = player_char
	
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
	# 首先确保 dialogue_ui 已经正确初始化
	if dialogue_ui == null:
		print("[对话控制器] 错误: dialogue_ui 未初始化，尝试重新获取")
		dialogue_ui = get_node_or_null("DialogueUI")
		if dialogue_ui == null:
			print("[对话控制器] 严重错误: 无法找到 DialogueUI 节点")
			return
	
	# 检查是否有 display_dialogue 方法
	if not dialogue_ui.has_method("display_dialogue"):
		print("[对话控制器] 严重错误: dialogue_ui 没有 display_dialogue 方法")
		# 打印对话 UI 的类型信息以便调试
		print("[对话控制器] dialogue_ui 类型:", dialogue_ui.get_class())
		return
	
	# 现在可以安全地调用 display_dialogue
	dialogue_ui.display_dialogue(speaker, text, emotion)
	
	# If there are choices, display them
	if choices.size() > 0:
		print("[对话控制器] 显示选择项:", choices.size(), "个")
		# 同样检查 display_choices 方法
		if dialogue_ui.has_method("display_choices"):
			dialogue_ui.display_choices(choices)
		else:
			print("[对话控制器] 错误: dialogue_ui 没有 display_choices 方法")
	else:
		# 确保清除之前的选择
		if dialogue_ui.has_method("clear_choices"):
			dialogue_ui.clear_choices()
		else:
			print("[对话控制器] 错误: dialogue_ui 没有 clear_choices 方法")

func check_scene_transition():
	var flags = {}
	var player_char = game_state.get_player_character()
	
	# Get flags from the last dialogue node
	if dialogue_manager.dialogue_history.size() > 0:
		var last_node = dialogue_manager.dialogue_history[dialogue_manager.dialogue_history.size() - 1]
		
		if "node_id" in last_node:
			var node_id = last_node["node_id"]
			if dialogue_manager.current_dialogue != null:
				var nodes = dialogue_manager.dialogue_library[dialogue_manager.current_dialogue]["nodes"]
				if node_id in nodes and "flags" in nodes[node_id]:
					flags = nodes[node_id]["flags"]
	
	print("[对话控制器] 检查场景转换 - 当前标志:", flags)
	print("[对话控制器] 当前玩家角色:", player_char)
	print("[对话控制器] 当前对话 ID:", current_dialogue_id)
	
	# 检查是否是角色特定对话
	var is_character_specific = current_dialogue_id.ends_with("_" + player_char)
	
	# 根据角色和当前对话决定下一个场景
	
	# 首先检查角色特定的转场标志
	if is_character_specific:
		# 艾丽卡特定的转场标志
		if player_char == "erika":
			if "erika_goto_lab" in flags and flags["erika_goto_lab"]:
				print("[对话控制器] 艾丽卡转换到实验室场景")
				environment_system.change_environment(environment_system.SceneType.PRIVATE)
				start_dialogue("chapter1_lab_scene_erika")
				return true
			elif "erika_goto_crisis" in flags and flags["erika_goto_crisis"]:
				print("[对话控制器] 艾丽卡转换到危机场景")
				environment_system.change_environment(environment_system.SceneType.CRISIS)
				start_dialogue("chapter1_crisis_scene_erika")
				return true
		
		# 尼尔特定的转场标志
		elif player_char == "neil":
			if "neil_goto_lab" in flags and flags["neil_goto_lab"]:
				print("[对话控制器] 尼尔转换到实验室场景")
				environment_system.change_environment(environment_system.SceneType.PRIVATE)
				start_dialogue("chapter1_lab_scene_neil")
				return true
			elif "neil_goto_crisis" in flags and flags["neil_goto_crisis"]:
				print("[对话控制器] 尼尔转换到危机场景")
				environment_system.change_environment(environment_system.SceneType.CRISIS)
				start_dialogue("chapter1_crisis_scene_neil")
				return true
		
		# 伊莎特定的转场标志
		elif player_char == "isa":
			if "isa_goto_lab" in flags and flags["isa_goto_lab"]:
				print("[对话控制器] 伊莎转换到实验室场景")
				environment_system.change_environment(environment_system.SceneType.PRIVATE)
				start_dialogue("chapter1_lab_scene_isa")
				return true
			elif "isa_goto_crisis" in flags and flags["isa_goto_crisis"]:
				print("[对话控制器] 伊莎转换到危机场景")
				environment_system.change_environment(environment_system.SceneType.CRISIS)
				start_dialogue("chapter1_crisis_scene_isa")
				return true
		
		# 卡伊特定的转场标志
		elif player_char == "kai":
			if "kai_goto_lab" in flags and flags["kai_goto_lab"]:
				print("[对话控制器] 卡伊转换到实验室场景")
				environment_system.change_environment(environment_system.SceneType.PRIVATE)
				start_dialogue("chapter1_lab_scene_kai")
				return true
			elif "kai_goto_crisis" in flags and flags["kai_goto_crisis"]:
				print("[对话控制器] 卡伊转换到危机场景")
				environment_system.change_environment(environment_system.SceneType.CRISIS)
				start_dialogue("chapter1_crisis_scene_kai")
				return true
	
	# 如果没有角色特定的转场标志，检查通用的转场标志
	# Check if we need to go to a new scene
	if "goto_lab_scene" in flags and flags["goto_lab_scene"]:
		print("[对话控制器] 转换到实验室场景")
		# 更新环境系统的场景类型
		environment_system.change_environment(environment_system.SceneType.PRIVATE)
		print("[对话控制器] 环境系统已更新为实验室场景")
		
		# 尝试使用角色特定的实验室对话
		var lab_dialogue_id = "chapter1_lab_scene_" + player_char
		if dialogue_manager.dialogue_library.has(lab_dialogue_id):
			print("[对话控制器] 使用角色特定的实验室对话:", lab_dialogue_id)
			start_dialogue(lab_dialogue_id)
		else:
			print("[对话控制器] 使用默认实验室对话")
			start_dialogue("chapter1_lab_scene")
		return true
	
	if "goto_crisis_scene" in flags and flags["goto_crisis_scene"]:
		print("[对话控制器] 转换到危机场景")
		# 更新环境系统的场景类型
		environment_system.change_environment(environment_system.SceneType.CRISIS)
		print("[对话控制器] 环境系统已更新为危机场景")
		
		# 尝试使用角色特定的危机对话
		var crisis_dialogue_id = "chapter1_crisis_scene_" + player_char
		if dialogue_manager.dialogue_library.has(crisis_dialogue_id):
			print("[对话控制器] 使用角色特定的危机对话:", crisis_dialogue_id)
			start_dialogue(crisis_dialogue_id)
		else:
			print("[对话控制器] 使用默认危机对话")
			start_dialogue("chapter1_crisis_scene")
		return true
	
	if "goto_resolution_scene" in flags and flags["goto_resolution_scene"]:
		print("[对话控制器] 转换到结局场景")
		# 更新环境系统的场景类型
		environment_system.change_environment(environment_system.SceneType.BOUNDARY)
		print("[对话控制器] 环境系统已更新为结局场景")
		
		# 尝试使用角色特定的结局对话
		var resolution_dialogue_id = "chapter1_resolution_" + player_char
		if dialogue_manager.dialogue_library.has(resolution_dialogue_id):
			print("[对话控制器] 使用角色特定的结局对话:", resolution_dialogue_id)
			start_dialogue(resolution_dialogue_id)
		else:
			print("[对话控制器] 使用默认结局对话")
			start_dialogue("chapter1_resolution")
		return true
	
	if "return_to_main" in flags and flags["return_to_main"]:
		# Return to main menu
		print("[对话控制器] 返回主菜单")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return true
	
	return false

func _on_dialogue_advanced():
	print("[对话控制器] 用户请求前进对话")
	
	# 先检查是否有场景转换
	if check_scene_transition():
		return
	
	# 清除选项
	dialogue_ui.clear_choices()
	
	# 使用新的advance_dialogue方法前进对话
	print("[对话控制器] 调用对话管理器的advance_dialogue方法")
	dialogue_manager.advance_dialogue()
	
	# 更新UI
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

# 重置对话场景控制器
func reset_controller():
	print("[对话控制器] 重置对话场景控制器...")
	
	# 重置当前对话ID
	current_dialogue_id = ""
	
	# 关闭自动前进
	auto_advance = false
	
	# 重置对话UI
	if dialogue_ui and dialogue_ui.has_method("reset_ui"):
		dialogue_ui.reset_ui()
	else:
		# 如果没有reset_ui方法，手动清空对话UI
		if dialogue_ui:
			if dialogue_ui.has_method("clear_dialogue"):
				dialogue_ui.clear_dialogue()
			if dialogue_ui.has_method("clear_choices"):
				dialogue_ui.clear_choices()
	
	print("[对话控制器] 对话场景控制器已重置")

# 处理对话等待用户交互的信号
func _on_dialogue_waiting_for_advance():
	print("[对话控制器] 对话等待用户交互")
	
	# 获取当前对话节点信息
	var current_node_data = dialogue_manager.get_current_node()
	if current_node_data == null:
		print("[对话控制器] 警告: 无法获取当前对话节点数据")
		return
	
	# 更新对话UI，显示对话内容并等待用户点击继续
	if dialogue_ui != null:
		# 设置UI为等待用户交互模式
		dialogue_ui.show_dialogue(
			current_node_data.get("speaker", ""),
			current_node_data.get("text", ""),
			current_node_data.get("emotion", "neutral"),
			[] # 没有选择项
		)
		
		# 显示继续按钮或提示
		dialogue_ui.show_continue_prompt()
		
		print("[对话控制器] UI已更新，等待用户交互")