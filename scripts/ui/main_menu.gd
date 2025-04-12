extends Control

@onready var new_game_button = $VBoxContainer/NewGameButton
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var title_label = $TitleLabel

var game_state

func _ready():
	game_state = get_node("/root/GameState")
	
	# Connect button signals
	new_game_button.connect("pressed", Callable(self, "_on_new_game_pressed"))
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))
	settings_button.connect("pressed", Callable(self, "_on_settings_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
	
	# Check if there's a save file to enable/disable continue button
	if not FileAccess.file_exists("user://saves/quicksave.json"):
		continue_button.disabled = true
	
	# Set title
	title_label.text = "X² PROJECT"

func _on_new_game_pressed():
	# Go to character selection screen
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_continue_pressed():
	# Load the last saved game
	if game_state.load_game("quicksave"):
		get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	else:
		print("Failed to load save file")

func _on_settings_pressed():
	# Show settings panel (not implemented in this version)
	pass

func _on_quit_pressed():
	# Quit the game
	get_tree().quit() 