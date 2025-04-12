extends Control

@onready var resume_button = $PanelContainer/VBoxContainer/ResumeButton
@onready var save_button = $PanelContainer/VBoxContainer/SaveButton
@onready var load_button = $PanelContainer/VBoxContainer/LoadButton
@onready var quit_button = $PanelContainer/VBoxContainer/QuitButton
@onready var save_message = $PanelContainer/VBoxContainer/SaveMessageLabel

var game_state

signal resumed
signal quit_to_main

func _ready():
	game_state = get_node("/root/GameState")
	
	# Connect button signals
	resume_button.connect("pressed", Callable(self, "_on_resume_button_pressed"))
	save_button.connect("pressed", Callable(self, "_on_save_button_pressed"))
	load_button.connect("pressed", Callable(self, "_on_load_button_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))
	
	# Start with save message hidden
	save_message.visible = false

func _on_resume_button_pressed():
	emit_signal("resumed")

func _on_save_button_pressed():
	# Save the game
	game_state.save_game("quicksave")
	
	# Show save message
	save_message.visible = true
	
	# Hide message after 2 seconds
	await get_tree().create_timer(2.0).timeout
	save_message.visible = false

func _on_load_button_pressed():
	# Load game
	if game_state.load_game("quicksave"):
		# Tell parent the game was loaded
		emit_signal("resumed")
		get_tree().reload_current_scene()
	else:
		# Show error message
		save_message.text = "无法加载存档"
		save_message.visible = true
		await get_tree().create_timer(2.0).timeout
		save_message.visible = false
		save_message.text = "游戏已保存"

func _on_quit_button_pressed():
	# Save game before quitting
	game_state.save_game("quicksave")
	
	# 预先加载主菜单场景
	var main_menu_scene = load("res://scenes/main_menu.tscn")
	if main_menu_scene:
		# 预先实例化场景
		var main_menu_instance = main_menu_scene.instantiate()
		# 确保场景结构完整
		if main_menu_instance:
			# 清理实例，只是为了测试
			main_menu_instance.queue_free()
			# 使用PackedScene切换
			emit_signal("quit_to_main")
		else:
			# 如果无法实例化，使用文件路径切换
			push_warning("无法实例化主菜单场景，使用备用方法")
			emit_signal("quit_to_main")
	else:
		# 如果无法加载，使用文件路径切换
		push_warning("无法加载主菜单场景，使用备用方法")
		emit_signal("quit_to_main")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("resumed") 