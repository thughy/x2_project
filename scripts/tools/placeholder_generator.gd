extends Node2D

# This script creates placeholder images for the game
# To use:
# 1. Create a basic scene with this script attached to a Node2D
# 2. Run the scene
# 3. Press the spacebar to generate all placeholder images

func _ready():
	print("Press SPACE to generate placeholder images")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		generate_all_placeholders()

func generate_all_placeholders():
	print("Generating placeholder images...")
	
	# Create directories if they don't exist
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("res://assets/characters"):
		dir.make_dir_recursive("res://assets/characters")
	if not dir.dir_exists("res://assets/ui"):
		dir.make_dir_recursive("res://assets/ui")
	if not dir.dir_exists("res://assets/backgrounds"):
		dir.make_dir_recursive("res://assets/backgrounds")
	
	# Generate character images
	create_character_placeholders()
	
	# Generate background images
	create_background_placeholders()
	
	# Generate UI icons
	create_ui_placeholders()
	
	print("Placeholder generation complete!")

func create_character_placeholders():
	# Character colors
	var colors = {
		"isa": Color(0.2, 0.6, 1.0), # Blue for AI Isa
		"erika": Color(1.0, 0.4, 0.7), # Pink for Human Erika
		"neil": Color(0.3, 0.8, 0.3), # Green for Human Neil
		"kai": Color(1.0, 0.5, 0.2) # Orange for AI Kai
	}
	
	# Expressions for Isa
	var isa_expressions = ["neutral", "curious", "sad", "warm", "confused", "awe", "hopeful"]
	for expr in isa_expressions:
		create_placeholder_image("res://assets/characters/isa_" + expr + ".png", 512, 512, colors["isa"], "Isa\n" + expr)
	
	# Expressions for Erika
	var erika_expressions = ["neutral", "professional", "concerned", "thoughtful", "excited", "sad", "hopeful"]
	for expr in erika_expressions:
		create_placeholder_image("res://assets/characters/erika_" + expr + ".png", 512, 512, colors["erika"], "Erika\n" + expr)
	
	# Expressions for Neil
	var neil_expressions = ["neutral", "skeptical", "analytical", "frustrated", "surprised", "defensive", "thoughtful"]
	for expr in neil_expressions:
		create_placeholder_image("res://assets/characters/neil_" + expr + ".png", 512, 512, colors["neil"], "Neil\n" + expr)
	
	# Expressions for Kai
	var kai_expressions = ["neutral", "angry", "determined", "defensive", "curious", "doubtful", "hopeful"]
	for expr in kai_expressions:
		create_placeholder_image("res://assets/characters/kai_" + expr + ".png", 512, 512, colors["kai"], "Kai\n" + expr)

func create_background_placeholders():
	# Background colors
	var colors = {
		"research": Color(0.2, 0.3, 0.5), # Dark blue for research space
		"private": Color(0.3, 0.2, 0.4), # Purple for private space
		"public": Color(0.5, 0.5, 0.5), # Gray for public space
		"boundary": Color(0.7, 0.7, 0.9), # Light blue for boundary space
		"crisis": Color(0.8, 0.2, 0.2) # Red for crisis space
	}
	
	# Create each background
	for space in colors:
		create_placeholder_image("res://assets/backgrounds/background_" + space + ".png", 1280, 720, colors[space], space + " space")

func create_ui_placeholders():
	# UI colors
	var colors = {
		"narrator_icon": Color(0.8, 0.8, 0.8), # Light gray for narrator
		"system_icon": Color(0.3, 0.3, 0.3), # Dark gray for system
		"menu_bg": Color(0.1, 0.1, 0.2, 0.7) # Semi-transparent dark blue for menu
	}
	
	# Create UI elements
	create_placeholder_image("res://assets/ui/narrator_icon.png", 128, 128, colors["narrator_icon"], "Narrator")
	create_placeholder_image("res://assets/ui/system_icon.png", 128, 128, colors["system_icon"], "System")
	create_placeholder_image("res://assets/ui/menu_bg.png", 512, 512, colors["menu_bg"], "Menu")
	
	# Create backgrounds for UI
	for space in ["research", "private", "public", "boundary", "crisis"]:
		var path = "res://assets/ui/background_" + space + ".png"
		# Create a copy of the background images in the UI folder
		var src_path = "res://assets/backgrounds/background_" + space + ".png"
		var file = FileAccess.open(src_path, FileAccess.READ)
		if file:
			var image_data = file.get_buffer(file.get_length())
			file.close()
			
			file = FileAccess.open(path, FileAccess.WRITE)
			file.store_buffer(image_data)
			file.close()
			print("Copied: " + path)

func create_placeholder_image(path, width, height, color, text = ""):
	# Create image
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	if text != "":
		# Add text to image by drawing a border and pattern
		# Draw a border
		for x in range(width):
			for y in range(height):
				if x < 5 or x > width - 5 or y < 5 or y > height - 5:
					image.set_pixel(x, y, Color(1, 1, 1, 0.8))
				
				# Draw simple text pattern (just for visual distinction)
				if (x + y) % 20 == 0:
					image.set_pixel(x, y, Color(1, 1, 1, 0.5))
	
	# Save the image
	image.save_png(path)
	print("Created: " + path) 