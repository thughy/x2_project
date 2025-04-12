@tool
extends EditorScript

func _run():
	print("创建UI图标...")
	
	# 创建Narrator图标
	create_icon("res://assets/ui/narrator_icon.png", Color(0.3, 0.3, 0.6, 1.0))
	
	# 创建System图标
	create_icon("res://assets/ui/system_icon.png", Color(0.6, 0.3, 0.3, 1.0))
	
	print("UI图标创建完成")

func create_icon(path, color):
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# 添加一些简单的图形，区分图标
	for x in range(32, 96):
		for y in range(32, 96):
			if (x - 64) * (x - 64) + (y - 64) * (y - 64) < 900:
				image.set_pixel(x, y, Color(1, 1, 1, 0.7))
	
	var err = image.save_png(path)
	if err != OK:
		print("保存图标出错:", path, err)
	else:
		print("图标已创建:", path) 