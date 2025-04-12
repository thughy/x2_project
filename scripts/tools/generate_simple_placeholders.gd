extends SceneTree

# 一个简单的脚本，用于生成游戏所需的所有占位图像
# 从命令行运行: godot --headless --script scripts/tools/generate_simple_placeholders.gd

func _init():
	print("开始生成占位图像...")
	
	# 创建目录（如果不存在）
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("res://assets/characters"):
		dir.make_dir_recursive("res://assets/characters")
	if not dir.dir_exists("res://assets/ui"):
		dir.make_dir_recursive("res://assets/ui")
	if not dir.dir_exists("res://assets/backgrounds"):
		dir.make_dir_recursive("res://assets/backgrounds")
	
	# 生成角色图像
	create_character_placeholders()
	
	# 生成背景图像
	create_background_placeholders()
	
	# 生成UI图标
	create_ui_placeholders()
	
	print("占位图像生成完成！")
	quit()

func create_character_placeholders():
	# 角色颜色
	var colors = {
		"isa": Color(0.2, 0.6, 1.0),    # 蓝色用于AI伊莎
		"erika": Color(1.0, 0.4, 0.7),  # 粉色用于人类艾丽卡
		"neil": Color(0.3, 0.8, 0.3),   # 绿色用于人类尼尔
		"kai": Color(1.0, 0.5, 0.2)     # 橙色用于AI卡伊
	}
	
	# 伊莎的表情
	var isa_expressions = ["neutral", "curious", "sad", "warm", "confused", "awe", "hopeful"]
	for expr in isa_expressions:
		create_placeholder_image("res://assets/characters/isa_" + expr + ".png", 512, 512, colors["isa"])
	
	# 艾丽卡的表情
	var erika_expressions = ["neutral", "professional", "concerned", "thoughtful", "excited", "sad", "hopeful"]
	for expr in erika_expressions:
		create_placeholder_image("res://assets/characters/erika_" + expr + ".png", 512, 512, colors["erika"])
	
	# 尼尔的表情
	var neil_expressions = ["neutral", "skeptical", "analytical", "frustrated", "surprised", "defensive", "thoughtful"]
	for expr in neil_expressions:
		create_placeholder_image("res://assets/characters/neil_" + expr + ".png", 512, 512, colors["neil"])
	
	# 卡伊的表情
	var kai_expressions = ["neutral", "angry", "determined", "defensive", "curious", "doubtful", "hopeful"]
	for expr in kai_expressions:
		create_placeholder_image("res://assets/characters/kai_" + expr + ".png", 512, 512, colors["kai"])

func create_background_placeholders():
	# 背景颜色
	var colors = {
		"research": Color(0.2, 0.3, 0.5),  # 研究空间的深蓝色
		"private": Color(0.3, 0.2, 0.4),   # 私人空间的紫色
		"public": Color(0.5, 0.5, 0.5),    # 公共空间的灰色
		"boundary": Color(0.7, 0.7, 0.9),  # 边界空间的浅蓝色
		"crisis": Color(0.8, 0.2, 0.2)     # 危机空间的红色
	}
	
	# 创建各个背景
	for space in colors:
		create_placeholder_image("res://assets/backgrounds/background_" + space + ".png", 1280, 720, colors[space])
		# 同时在UI目录创建一份副本
		create_placeholder_image("res://assets/ui/background_" + space + ".png", 1280, 720, colors[space])

func create_ui_placeholders():
	# UI颜色
	var colors = {
		"narrator_icon": Color(0.8, 0.8, 0.8),     # 旁白图标的浅灰色
		"system_icon": Color(0.3, 0.3, 0.3),       # 系统图标的深灰色
		"menu_bg": Color(0.1, 0.1, 0.2, 0.7)       # 菜单背景的半透明深蓝色
	}
	
	# 创建UI元素
	create_placeholder_image("res://assets/ui/narrator_icon.png", 128, 128, colors["narrator_icon"])
	create_placeholder_image("res://assets/ui/system_icon.png", 128, 128, colors["system_icon"])
	create_placeholder_image("res://assets/ui/menu_bg.png", 512, 512, colors["menu_bg"])

func create_placeholder_image(path, width, height, color):
	# 创建图像
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	# 绘制边框
	for x in range(width):
		for y in range(height):
			if x < 3 or x > width - 3 or y < 3 or y > height - 3:
				image.set_pixel(x, y, Color(1, 1, 1, 0.5))
	
	# 保存图像
	image.save_png(path)
	print("已创建: " + path) 