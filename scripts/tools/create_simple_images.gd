extends Node

# 创建纯色块的脚本

func _ready():
	# 创建必要的目录
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("res://assets/characters"):
		dir.make_dir_recursive("res://assets/characters")
	if not dir.dir_exists("res://assets/ui"):
		dir.make_dir_recursive("res://assets/ui")
	
	# 创建纯色块图像
	create_colored_image("res://assets/characters/_neutral.png", Color(0.5, 0.5, 0.5))
	create_colored_image("res://assets/ui/narrator_icon.png", Color(0.3, 0.3, 0.6))
	create_colored_image("res://assets/ui/system_icon.png", Color(0.6, 0.3, 0.3))
	
	print("纯色块图像创建完成")

func create_colored_image(path, color):
	# 创建一个新的图像
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# 保存图像
	var err = image.save_png(path)
	if err != OK:
		push_error("无法创建图像: " + path)
		return false
	else:
		print("已创建图像: " + path)
		return true 