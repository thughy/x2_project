extends Control

# UI Components
@onready var name_label = $DialoguePanel/NameLabel
@onready var text_label = $DialoguePanel/TextLabel
@onready var portrait = $PortraitPanel/Portrait
@onready var choices_container = $ChoicesPanel/VBoxContainer
@onready var emotion_display = $EmotionPanel
@onready var relationship_display = $RelationshipPanel
@onready var continue_indicator = $DialoguePanel/ContinueIndicator

var choice_button_scene = preload("res://scenes/ui/choice_button.tscn")
var dialogue_manager
var game_state
var emotion_system
var relationship_system
var current_speaker_id = ""
var is_player_speaking = false
var portrait_load_error_shown = false

signal dialogue_advanced
signal choice_selected(choice_index)

func _ready():
	dialogue_manager = get_node("/root/DialogueManager")
	game_state = get_node("/root/GameState")
	emotion_system = get_node("/root/EmotionSystem")
	relationship_system = get_node("/root/RelationshipSystem")
	
	# Connect signals
	dialogue_manager.connect("dialogue_started", Callable(self, "_on_dialogue_started"))
	dialogue_manager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	
	# Hide UI initially
	hide()
	$ChoicesPanel.visible = false
	$EmotionPanel.visible = false
	$RelationshipPanel.visible = false
	
	# 预检查所有角色肖像
	_precheck_character_portraits()

func _precheck_character_portraits():
	print("预检查角色肖像资源...")
	for character_id in game_state.CHARACTERS:
		# 检查基本肖像
		var neutral_path = game_state.get_character_portrait(character_id, "neutral")
		if not ResourceLoader.exists(neutral_path):
			print("警告：找不到角色 ", character_id, " 的中性肖像")
		else:
			print("找到角色 ", character_id, " 的中性肖像")
		
		# 检查常用情绪肖像
		var emotions = ["happy", "sad", "angry", "curious", "confused", "warm", "professional"]
		for emotion in emotions:
			var path = game_state.get_character_portrait(character_id, emotion)
			if ResourceLoader.exists(path):
				print("找到肖像: ", path)

func _input(event):
	# 调试信息 - 首先打印所有输入事件以便调试
	if event is InputEventKey and event.pressed:
		print("[对话 UI] 按键输入: ", event.keycode, ", 扫描码: ", event.physical_keycode)
	
	# 如果是鼠标点击，也打印调试信息
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("[对话 UI] 鼠标点击位置: ", event.position)
	
	# 如果对话UI可见，且没有选择项显示，则允许通过点击或空格键前进对话
	if visible and choices_container.get_child_count() == 0:
		# 检查空格键或回车键
		if event.is_action_pressed("ui_continue") or event.is_action_pressed("ui_accept"):
			print("[对话 UI] 发送对话前进信号")
			emit_signal("dialogue_advanced")
			return
		
		# 检查鼠标点击
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# 确保点击在对话面板区域内
			if $DialoguePanel.get_global_rect().has_point(event.position):
				print("[对话 UI] 鼠标点击对话面板，发送对话前进信号")
				emit_signal("dialogue_advanced")
				return
	
	# 调试信息
	if event.is_action_pressed("ui_continue"):
		print("[对话 UI] UI continue action pressed. UI visible: ", visible, ", Choices count: ", choices_container.get_child_count())

func display_dialogue(speaker_id, text, emotion="neutral"):
	# 调试信息
	print("[对话 UI] 显示对话: 原始说话者=", speaker_id, ", 情绪=", emotion, ", 玩家角色=", game_state.get_player_character())
	
	# 打印当前对话的内容
	print("[对话 UI] 原始对话内容: \"", text, "\"")
	
	# 获取玩家角色ID和名称
	var player_char_id = game_state.get_player_character()
	if player_char_id == null:
		print("[对话 UI] 严重错误：玩家角色未设置！")
		player_char_id = "erika" # 为防止崩溃强制设置默认值
	
	var player_name = game_state.get_character_name(player_char_id)
	
	# 替换文本中的[player_character]标记
	text = text.replace("[player_character]", player_name)
	
	# 处理特殊说话者
	var final_speaker_id = speaker_id
	var final_speaker_name = ""
	var final_emotion = emotion
	
	# 第1步：处理player标记
	if speaker_id == "player":
		print("[对话 UI] 检测到player标记，替换为玩家角色:", player_char_id)
		final_speaker_id = player_char_id
		final_speaker_name = player_name
		is_player_speaking = true
	
	# 第2步：处理narrator或system（强制替换为玩家角色）
	elif speaker_id == "narrator" or speaker_id == "system":
		print("[对话 UI] 检测到旁白，将其替换为玩家角色:", player_char_id)
		final_speaker_id = player_char_id
		final_speaker_name = player_name
		is_player_speaking = true
		
		# 如果旁白没有指定情绪，设置一个默认情绪
		if emotion == "neutral":
			final_emotion = "thoughtful"
		
		# 修改文本，使其更适合主角发言
		text = convert_narrator_text_to_first_person(text)
	
	# 第3步：处理其他角色
	else:
		final_speaker_name = game_state.get_character_name(speaker_id)
		if final_speaker_name.is_empty():
			final_speaker_name = speaker_id.capitalize()
		is_player_speaking = (speaker_id == player_char_id)
	
	# 更新UI
	name_label.text = final_speaker_name
	current_speaker_id = final_speaker_id
	
	print("[对话 UI] 最终处理结果: 说话者=", final_speaker_id, ", 显示名称=", final_speaker_name, ", 情绪=", final_emotion)
	print("[对话 UI] 最终对话内容: \"", text, "\"")
	
	# 处理特殊说话者（旁白或系统）
	if final_speaker_id == "narrator" or final_speaker_id == "system":
		# Try to load appropriate icon
		var icon_path = "res://assets/ui/" + final_speaker_id + "_icon.png"
		var icon_loaded = false
		
		if FileAccess.file_exists(icon_path.trim_prefix("res://")):
			var texture = load(icon_path)
			if texture:
				portrait.texture = texture
				icon_loaded = true
				print("成功加载", final_speaker_id, "图标:", icon_path)
		
		# If icon loading fails, create a custom placeholder
		if not icon_loaded:
			var color = Color(0.6, 0.6, 0.8) if final_speaker_id == "narrator" else Color(0.8, 0.6, 0.3) # Purple for narrator, orange for system
			portrait.texture = create_placeholder_texture(color)
			print("为", final_speaker_id, "创建自定义图标")
		
		# 隐藏情感和关系面板，因为叙述者/系统没有情感和关系
		emotion_display.visible = false
		relationship_display.visible = false
		
		text_label.text = text
		show()
		return
	else:
		# 处理普通角色
		if game_state.character_data.has(final_speaker_id):
			name_label.text = game_state.get_character_name(final_speaker_id)
		else:
			print("警告：未知角色ID:", final_speaker_id)
			name_label.text = final_speaker_id
	
	# 加载肖像 - 使用最终处理后的说话者ID
	load_character_portrait(final_speaker_id, final_emotion)
	
	# Set text
	text_label.text = text
	
	# Update emotion display - 总是尝试显示
	update_emotion_display(final_speaker_id)
	
	# Update relationship display if applicable - 总是尝试显示
	if player_char_id != "" and final_speaker_id != "narrator" and final_speaker_id != "system" and player_char_id != final_speaker_id:
		update_relationship_display(player_char_id, final_speaker_id)
	else:
		relationship_display.visible = false
	
	# 确保对话UI显示
	show()
	continue_indicator.visible = true

func load_character_portrait(character_id, emotion="neutral"):
	# 专门处理肖像加载逻辑
	var portrait_loaded = false
	
	# 直接打印所有可用的资源文件以便调试
	print("当前角色ID:", character_id, ", 尝试加载情绪:", emotion)
	
	# 尝试加载方式1: 直接使用情绪名称的肖像
	var emotion_path = "res://assets/characters/" + character_id + "_" + emotion + ".png"
	print("尝试路径1:", emotion_path)
	
	if ResourceLoader.exists(emotion_path):
		var texture = load(emotion_path)
		if texture:
			portrait.texture = texture
			print("成功加载情绪肖像:", emotion_path)
			portrait_loaded = true
		else:
			print("加载情绪肖像失败:", emotion_path)
	else:
		print("情绪肖像不存在:", emotion_path)
	
	# 尝试加载方式2: 中性表情
	if not portrait_loaded:
		var neutral_path = "res://assets/characters/" + character_id + "_neutral.png"
		print("尝试路径2:", neutral_path)
		
		if ResourceLoader.exists(neutral_path):
			var texture = load(neutral_path)
			if texture:
				portrait.texture = texture
				print("成功加载中性肖像:", neutral_path)
				portrait_loaded = true
			else:
				print("加载中性肖像失败:", neutral_path)
		else:
			print("中性肖像不存在:", neutral_path)
	
	# 尝试加载方式3: 基本角色肖像（没有情绪后缀）
	if not portrait_loaded:
		var base_path = "res://assets/characters/" + character_id + ".png"
		print("尝试路径3:", base_path)
		
		if ResourceLoader.exists(base_path):
			var texture = load(base_path)
			if texture:
				portrait.texture = texture
				print("成功加载基本肖像:", base_path)
				portrait_loaded = true
			else:
				print("加载基本肖像失败:", base_path)
		else:
			print("基本肖像不存在:", base_path)
	
	# 如果所有尝试都失败，创建一个角色特定的占位符纹理
	if not portrait_loaded:
		print("警告：找不到角色肖像,创建占位符")
		
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
		elif character_id == "narrator":
			color = Color(0.6, 0.6, 0.8) # 紫色调
		elif character_id == "system":
			color = Color(0.8, 0.6, 0.3) # 橙色调
		
		portrait.texture = create_placeholder_texture(color)
		portrait_loaded = true
		print("使用生成的占位符纹理")
		
		# 只显示一次警告
		if not portrait_load_error_shown:
			push_warning("警告：使用生成的占位符肖像")
			portrait_load_error_shown = true

func create_placeholder_texture(color):
	# 创建一个简单的纯色纹理作为肖像占位符
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(color)
	var texture = ImageTexture.create_from_image(image)
	return texture

func display_choices(choices):
	# Clear previous choices
	for child in choices_container.get_children():
		child.queue_free()
	
	# Create buttons for each choice
	for i in range(choices.size()):
		var choice = choices[i]
		var button = choice_button_scene.instantiate()
		choices_container.add_child(button)
		
		# Replace [player_character] with the actual character name
		var choice_text = choice.text
		var player_char_id = game_state.get_player_character()
		var player_name = game_state.get_character_name(player_char_id)
		choice_text = choice_text.replace("[player_character]", player_name)
		
		button.text = choice_text
		button.choice_index = i
		button.connect("pressed", Callable(self, "_on_choice_button_pressed").bind(i))
	
	# 显示选择面板
	$ChoicesPanel.visible = true
	continue_indicator.visible = false

func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()
	
	# 隐藏选择面板
	$ChoicesPanel.visible = false
	continue_indicator.visible = true

func update_emotion_display(character_id):
	# This function will update the emotion display UI
	print("更新情感显示 - 角色ID:", character_id)
	
	if character_id == "narrator" or character_id == "system":
		emotion_display.visible = false
		print("隐藏情感面板 - 特殊角色:", character_id)
		return
	
	# Check if character exists in emotion system
	if not emotion_system.character_emotions.has(character_id):
		emotion_display.visible = false
		print("隐藏情感面板 - 找不到角色情感数据:", character_id)
		return
		
	var emotions_text = ""
	
	# Display base emotions
	for emotion_type in emotion_system.character_emotions[character_id]["base"]:
		var value = emotion_system.character_emotions[character_id]["base"][emotion_type]
		if value > 25:  # Only show significant emotions
			emotions_text += emotion_system.emotion_names[emotion_type] + ": " + str(value) + "\n"
	
	# Display active compound emotions
	var compound_emotions_text = ""
	for compound_emotion in emotion_system.character_emotions[character_id]["compound"]:
		if emotion_system.character_emotions[character_id]["compound"][compound_emotion]["active"]:
			var value = emotion_system.character_emotions[character_id]["compound"][compound_emotion]["value"]
			compound_emotions_text += emotion_system.compound_emotion_names[compound_emotion] + ": " + str(int(value)) + "\n"
	
	if compound_emotions_text != "":
		emotions_text += "\n复合情绪:\n" + compound_emotions_text
	
	emotion_display.get_node("EmotionText").text = emotions_text
	print("显示情感面板 - 数据更新完成")
	emotion_display.visible = true

func update_relationship_display(from_character, to_character):
	# Check if relationship exists
	print("更新关系显示 - 从角色:", from_character, "到角色:", to_character)
	
	if not relationship_system.relationships.has(from_character) or not relationship_system.relationships[from_character].has(to_character):
		relationship_display.visible = false
		print("隐藏关系面板 - 找不到关系数据")
		return
	
	var relationship_text = ""
	var dimensions = relationship_system.relationships[from_character][to_character]
	
	relationship_text = "关系状态: " + relationship_system.get_relationship_description(from_character, to_character) + "\n\n"
	
	for dimension in dimensions:
		var dimension_name = relationship_system.dimension_names[dimension]
		var value = dimensions[dimension]
		relationship_text += dimension_name + ": " + str(value) + "\n"
	
	relationship_display.get_node("RelationshipText").text = relationship_text
	print("显示关系面板 - 数据更新完成")
	relationship_display.visible = true

func _on_dialogue_started(dialogue_id):
	show()
	# 强制显示面板用于调试
	_debug_force_show_panels()

func _debug_force_show_panels():
	# 调试功能：强制显示所有UI面板以检查它们是否正确渲染
	print("调试：强制显示UI面板")
	visible = true
	
	var player_char = game_state.get_player_character()
	if player_char:
		update_emotion_display(player_char)
		
		# 找一个非玩家角色更新关系面板
		var other_char = null
		for char_id in game_state.CHARACTERS:
			if char_id != player_char:
				other_char = char_id
				break
				
		if other_char:
			update_relationship_display(player_char, other_char)

func _on_dialogue_ended(dialogue_id):
	hide()

# 将旁白文本转换为第一人称
func convert_narrator_text_to_first_person(text):
	# 替换常见的第三人称描述为第一人称
	var converted_text = text
	
	# 替换一些常见的第三人称表述
	converted_text = converted_text.replace("研究团队", "我们团队")
	converted_text = converted_text.replace("他们", "我们")
	converted_text = converted_text.replace("研究员们", "我们")
	converted_text = converted_text.replace("科学家们", "我们科学家")
	
	# 处理特定角色的第三人称描述
	var player_char_id = game_state.get_player_character()
	if player_char_id == "erika":
		converted_text = converted_text.replace("艾丽卡博士", "我")
		converted_text = converted_text.replace("艾丽卡", "我")
		converted_text = converted_text.replace("她的", "我的")
		converted_text = converted_text.replace("她", "我")
	elif player_char_id == "neil":
		converted_text = converted_text.replace("尼尔教授", "我")
		converted_text = converted_text.replace("尼尔", "我")
		converted_text = converted_text.replace("他的", "我的")
		converted_text = converted_text.replace("他", "我")
	
	# 如果文本没有变化，尝试更通用的转换
	if converted_text == text:
		# 添加一个通用的第一人称开头
		converted_text = "我看到" + text.substr(0, 1).to_lower() + text.substr(1)
	
	print("[对话 UI] 旁白文本转换: \"", text, "\" -> \"", converted_text, "\"")
	return converted_text

func _on_choice_button_pressed(choice_index):
	emit_signal("choice_selected", choice_index)
	clear_choices() 

# 重置对话UI到初始状态
func reset_ui():
	print("[对话UI] 重置对话UI到初始状态...")
	
	# 清除当前对话内容
	name_label.text = ""
	text_label.text = ""
	current_speaker_id = ""
	is_player_speaking = false
	
	# 清除选项
	clear_choices()
	
	# 隐藏所有面板
	$ChoicesPanel.visible = false
	$EmotionPanel.visible = false
	$RelationshipPanel.visible = false
	continue_indicator.visible = false
	
	# 隐藏整个对话UI
	hide()
	
	print("[对话UI] 对话UI已重置")

# 清除当前对话内容
func clear_dialogue():
	print("[对话UI] 清除当前对话内容")
	name_label.text = ""
	text_label.text = ""
	continue_indicator.visible = false

# 显示继续提示，提示用户点击继续
func show_continue_prompt():
	print("[对话UI] 显示继续提示")
	continue_indicator.visible = true
	# 确保对话面板可见
	show()