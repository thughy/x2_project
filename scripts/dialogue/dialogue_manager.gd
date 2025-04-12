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
	
	# 加载角色特定对话
	load_character_specific_dialogues()

# 加载特定角色的对话文件
func load_character_specific_dialogues():
	print("[对话管理器] 正在加载角色特定对话文件...")
	
	# 定义所有角色对话脚本
	var character_dialogues = {
		"erika": "res://scripts/dialogue/chapter1_erika.gd",
		"isa": "res://scripts/dialogue/chapter1_isa.gd",
		"neil": "res://scripts/dialogue/chapter1_neil.gd",
		"kai": "res://scripts/dialogue/chapter1_kai.gd"
	}
	
	# 记录成功加载的对话脚本
	var loaded_dialogues = []
	
	# 尝试加载所有角色对话
	for character_id in character_dialogues:
		var dialogue_path = character_dialogues[character_id]
		print("[对话管理器] 尝试加载角色对话:", character_id, ", 路径:", dialogue_path)
		
		# 使用改进的加载方法
		var dialogue_script = load_if_exists(dialogue_path)
		if dialogue_script:
			print("[对话管理器] 成功加载脚本:", dialogue_path)
			var dialogue_instance = dialogue_script.new()
			
			# 列出脚本中的所有方法
			print("[对话管理器] 脚本", character_id, "中的方法:")
			for method in dialogue_instance.get_method_list():
				print("  - ", method.name)
			
			# 加载角色特定的对话
			# 首先加载角色特定的引导对话
			if dialogue_instance.has_method("create_intro_dialogue"):
				var intro_dialogue_id = "chapter1_intro_" + character_id
				print("[对话管理器] 正在创建引导对话 ID:", intro_dialogue_id)
				var intro_dialogue_data = dialogue_instance.create_intro_dialogue()
				
				# 检查对话数据结构
				print("[对话管理器] 引导对话数据结构:")
				print("  - 标题:", intro_dialogue_data.get("title", "<无标题>"))
				print("  - 开始节点:", intro_dialogue_data.get("start_node", "<无开始节点>"))
				if intro_dialogue_data.has("nodes"):
					print("  - 节点数量:", intro_dialogue_data["nodes"].size())
					# 打印前三个节点的说话者
					var count = 0
					for node_id in intro_dialogue_data["nodes"]:
						if count < 3:
							var node = intro_dialogue_data["nodes"][node_id]
							print("    - 节点", node_id, ": 说话者 =", node.get("speaker", "<无说话者>"))
							count += 1
				
				add_dialogue(intro_dialogue_id, intro_dialogue_data)
				print("[对话管理器] 成功加载", character_id, "的引导对话")
			
			# 加载实验室场景对话
			if dialogue_instance.has_method("create_lab_scene_dialogue"):
				var lab_dialogue_id = "chapter1_lab_scene_" + character_id
				var lab_dialogue_data = dialogue_instance.create_lab_scene_dialogue()
				add_dialogue(lab_dialogue_id, lab_dialogue_data)
				print("成功加载", character_id, "的实验室对话")
			
			# 加载危机场景对话
			if dialogue_instance.has_method("create_crisis_scene_dialogue"):
				var crisis_dialogue_id = "chapter1_crisis_scene_" + character_id
				var crisis_dialogue_data = dialogue_instance.create_crisis_scene_dialogue()
				add_dialogue(crisis_dialogue_id, crisis_dialogue_data)
				print("成功加载", character_id, "的危机对话")
			
			# 加载解决方案对话
			if dialogue_instance.has_method("create_resolution_dialogue"):
				var resolution_dialogue_id = "chapter1_resolution_" + character_id
				var resolution_dialogue_data = dialogue_instance.create_resolution_dialogue()
				add_dialogue(resolution_dialogue_id, resolution_dialogue_data)
				print("成功加载", character_id, "的解决方案对话")
			
			# 加载通用章节对话
			if dialogue_instance.has_method("create_chapter1_dialogue"):
				var dialogue_id = "chapter1_" + character_id
				var dialogue_data = dialogue_instance.create_chapter1_dialogue()
				add_dialogue(dialogue_id, dialogue_data)
				loaded_dialogues.append(character_id)
				print("成功加载", character_id, "的通用视角对话")
			else:
				print("警告:", character_id, "对话脚本缺少create_chapter1_dialogue方法")
	
	# 打印加载结果摘要
	if loaded_dialogues.size() > 0:
		print("成功加载的对话脚本:", loaded_dialogues)
	else:
		print("警告: 没有成功加载任何角色对话脚本")

# 安全加载资源，使用更可靠的方法
func load_if_exists(path):
	print("尝试加载资源文件:", path)
	
	# 首先使用ResourceLoader检查
	var exists = ResourceLoader.exists(path)
	if exists:
		print("资源文件存在，尝试加载:", path)
		var resource = load(path)
		if resource:
			print("成功加载资源文件:", path)
			return resource
		else:
			print("资源加载失败，返回null:", path)
	else:
		# 使用FileAccess再次检查
		var file_path = path.trim_prefix("res://")
		print("使用FileAccess检查文件:", file_path)
		
		if FileAccess.file_exists(file_path):
			print("文件存在，尝试直接加载:", path)
			var resource = load(path)
			if resource:
				print("成功加载资源文件:", path)
				return resource
			else:
				print("资源加载失败，返回null:", path)
		else:
			print("警告: 找不到资源文件 " + path)
	
	return null

# Add a dialogue to the library
func add_dialogue(dialogue_id, dialogue_data):
	dialogue_library[dialogue_id] = dialogue_data
	return true

# Start a dialogue by ID
func start_dialogue(dialogue_id):
	print("[调试] 尝试启动对话 ID:", dialogue_id)
	print("[调试] 当前对话库中的对话 ID:", dialogue_library.keys())
	
	if dialogue_id in dialogue_library:
		print("[调试] 找到对话 ID:", dialogue_id)
		print("[调试] 对话标题:", dialogue_library[dialogue_id].get("title", "无标题"))
		print("[调试] 对话描述:", dialogue_library[dialogue_id].get("description", "无描述"))
		
		current_dialogue = dialogue_id
		dialogue_history = []
		
		# Get the first node
		var first_node = dialogue_library[dialogue_id]["start_node"]
		current_node = first_node
		
		print("[调试] 对话起始节点:", first_node)
		print("[调试] 节点数量:", dialogue_library[dialogue_id]["nodes"].size())
		
		# 打印前几个节点的说话者信息
		var node_count = 0
		for node_id in dialogue_library[dialogue_id]["nodes"]:
			if node_count < 5:  # 只打印前5个节点
				var node_data = dialogue_library[dialogue_id]["nodes"][node_id]
				print("[调试] 节点", node_id, "的说话者:", node_data.get("speaker", "未指定"))
				node_count += 1
		
		emit_signal("dialogue_started", dialogue_id)
		
		# Process the first node
		process_current_node()
		
		return true
	else:
		print("[调试] 未找到对话 ID:", dialogue_id)
	
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

# Get the current node data
func get_current_node():
	if current_dialogue == null or current_node == null:
		print("[对话管理器] get_current_node: 当前没有活动对话")
		return null
	
	if not dialogue_library.has(current_dialogue):
		print("[对话管理器] get_current_node: 当前对话 ID ", current_dialogue, " 不存在")
		return null
	
	if not dialogue_library[current_dialogue]["nodes"].has(current_node):
		print("[对话管理器] get_current_node: 当前节点 ID ", current_node, " 不存在")
		return null
	
	return dialogue_library[current_dialogue]["nodes"][current_node]

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