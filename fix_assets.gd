extends SceneTree

func _init():
	print("Creating placeholder image assets...")
	
	# Create a neutral character placeholder
	create_placeholder_image("res://assets/characters/_neutral.png", Color(0.7, 0.7, 0.7), 512, 512)
	
	# Create narrator icon
	create_placeholder_image("res://assets/ui/narrator_icon.png", Color(0.3, 0.5, 0.8), 128, 128)
	
	# Create system icon
	create_placeholder_image("res://assets/ui/system_icon.png", Color(0.8, 0.3, 0.3), 128, 128)
	
	print("Asset creation complete!")
	quit()

func create_placeholder_image(path, color, width, height):
	print("Creating image: " + path)
	
	# Create image
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# Draw a border
	var border_color = Color(0.2, 0.2, 0.2)
	for x in range(width):
		for y in range(height):
			if x < 2 or x > width - 3 or y < 2 or y > height - 3:
				image.set_pixel(x, y, border_color)
	
	# Save the image
	var result = image.save_png(path)
	if result == OK:
		print("Successfully saved: " + path)
	else:
		print("Failed to save: " + path + ", error: " + str(result))
