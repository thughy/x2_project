extends Node

@onready var dialogue_scene_controller = $DialogueSceneController
@onready var environment_display = $EnvironmentDisplay
@onready var menu_button = $MenuButton

var game_state
var environment_system
var current_scene_type = null
var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
var pause_menu = null

func _ready():
	game_state = get_node("/root/GameState")
	environment_system = get_node("/root/EnvironmentSystem")
	
	# Connect signals
	menu_button.connect("pressed", Callable(self, "_on_menu_button_pressed"))
	environment_system.connect("environment_changed", Callable(self, "_on_environment_changed"))
	
	# 确保玩家角色已设置，如果未设置则使用默认值
	if game_state.get_player_character() == null:
		print("设置默认玩家角色为艾丽卡")
		game_state.set_player_character("erika")
	
	# Set initial environment based on first scene
	set_initial_environment()
	
	# Start the first dialogue
	dialogue_scene_controller.start_dialogue("chapter1_intro")
	
	# Update environment display
	update_environment_display()

func set_initial_environment():
	# Set initial environment based on first scene in chapter 1
	environment_system.change_environment(
		environment_system.SceneType.RESEARCH,
		environment_system.Weather.CLEAR,
		environment_system.TimeOfDay.MORNING,
		environment_system.Temperature.MILD
	)

func update_environment_display():
	# Update the environment display UI
	var env_desc = environment_system.get_environment_description()
	environment_display.text = env_desc

func _on_environment_changed(old_env, new_env):
	# Update environment display when environment changes
	update_environment_display()
	
	# Apply environmental effects to all characters
	for character_id in game_state.CHARACTERS:
		environment_system.apply_environment_effects(character_id)

func _on_menu_button_pressed():
	# Show pause menu
	if pause_menu == null:
		pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)
		pause_menu.connect("resumed", Callable(self, "_on_game_resumed"))
		pause_menu.connect("quit_to_main", Callable(self, "_on_quit_to_main"))
		get_tree().paused = true
	else:
		remove_child(pause_menu)
		pause_menu = null
		get_tree().paused = false

func _on_game_resumed():
	# Resume game
	remove_child(pause_menu)
	pause_menu = null
	get_tree().paused = false

func _on_quit_to_main():
	# Save game before quitting
	game_state.save_game("quicksave")
	
	# Unpause and return to main menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	# Quick save with F5
	if event.is_action_pressed("ui_save"):
		game_state.save_game("quicksave")
		print("Game saved")
		
	# Quick load with F8
	if event.is_action_pressed("ui_load"):
		if game_state.load_game("quicksave"):
			print("Game loaded")
			# Restart current dialogue
			if game_state.current_scene:
				dialogue_scene_controller.start_dialogue(game_state.current_scene) 