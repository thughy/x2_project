extends Control

@onready var resume_button = $PanelContainer/VBoxContainer/ResumeButton
@onready var save_button = $PanelContainer/VBoxContainer/SaveButton
@onready var load_button = $PanelContainer/VBoxContainer/LoadButton
@onready var quit_button = $PanelContainer/VBoxContainer/QuitButton

var game_state

signal resumed
signal quit_to_main

func _ready():
	game_state = get_node("/root/GameState")
	
	# Connect button signals
	resume_button.connect("pressed", Callable(self, "_on_resume_pressed"))
	save_button.connect("pressed", Callable(self, "_on_save_pressed"))
	load_button.connect("pressed", Callable(self, "_on_load_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
	
	# Check if there's a save file to enable/disable load button
	if not FileAccess.file_exists("user://saves/quicksave.json"):
		load_button.disabled = true
	
	# Pause the game
	get_tree().paused = true

func _on_resume_pressed():
	emit_signal("resumed")

func _on_save_pressed():
	if game_state.save_game("quicksave"):
		# Show save success message
		var save_label = $PanelContainer/VBoxContainer/SaveMessageLabel
		save_label.text = "游戏已保存"
		save_label.show()
		
		# Enable load button
		load_button.disabled = false
		
		# Hide message after delay
		var timer = get_tree().create_timer(2.0)
		await timer.timeout
		save_label.hide()

func _on_load_pressed():
	if game_state.load_game("quicksave"):
		# Resume and reload current scene
		emit_signal("resumed")
		get_tree().reload_current_scene()

func _on_quit_pressed():
	emit_signal("quit_to_main")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("resumed") 