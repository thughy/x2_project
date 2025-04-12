@tool
extends EditorScript

func _run():
	print("创建默认肖像...")
	
	# 创建一个灰色的图像作为默认肖像
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.5, 0.5, 0.5, 1.0))
	
	# 保存图像
	var err = image.save_png("res://assets/characters/_neutral.png")
	if err != OK:
		print("保存默认肖像出错:", err)
	else:
		print("默认肖像已创建: res://assets/characters/_neutral.png") 