extends Control

func _ready():
	# Connect button signals
	$VBoxContainer/StartGameButton.pressed.connect(_on_start_game_button_pressed)
	$VBoxContainer/GeneratePlaceholdersButton.pressed.connect(_on_generate_placeholders_button_pressed)
	$VBoxContainer/ViewMainMenuButton.pressed.connect(_on_view_main_menu_button_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_button_pressed)

func _on_start_game_button_pressed():
	# Check if we have placeholder images
	var dir = DirAccess.open("res://assets/characters")
	if not dir or dir.get_files().is_empty():
		_show_warning("No character images found. Please generate placeholders first.")
		return
		
	# Navigate to game scene
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _on_generate_placeholders_button_pressed():
	# Navigate to placeholder generator
	get_tree().change_scene_to_file("res://scenes/tools/placeholder_generator.tscn")

func _on_view_main_menu_button_pressed():
	# Navigate to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exit_button_pressed():
	# Exit the game
	get_tree().quit()

func _show_warning(message: String):
	# Create a simple warning dialog
	var dialog = AcceptDialog.new()
	dialog.title = "Warning"
	dialog.dialog_text = message
	add_child(dialog)
	dialog.popup_centered()
	await dialog.confirmed
	remove_child(dialog)
	dialog.queue_free() 