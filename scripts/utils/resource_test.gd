extends Node

# 这个脚本用于在游戏启动时直接测试资源加载

func _ready():
	# 延迟执行测试，确保所有系统都已初始化
	get_tree().create_timer(1.0).timeout.connect(run_tests)

func run_tests():
	print("开始资源加载测试...")
	
	# 测试背景加载
	test_background_loading()
	
	# 测试角色肖像加载
	test_portrait_loading()

func test_background_loading():
	print("测试背景加载...")
	
	# 直接尝试加载研究场景背景
	var bg_path = "res://assets/background/background_research.png"
	print("尝试加载: " + bg_path)
	
	if ResourceLoader.exists(bg_path):
		print("ResourceLoader 报告文件存在")
		var texture = ResourceLoader.load(bg_path)
		if texture:
			print("成功加载背景纹理!")
			
			# 创建一个临时的TextureRect来显示背景
			var texture_rect = TextureRect.new()
			texture_rect.texture = texture
			texture_rect.expand = true
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			texture_rect.size = Vector2(400, 300)
			texture_rect.position = Vector2(50, 50)
			
			# 添加到场景中
			add_child(texture_rect)
			print("已添加背景预览到场景")
		else:
			print("加载失败，无法获取纹理")
	else:
		print("ResourceLoader 报告文件不存在")
		
		# 尝试使用FileAccess检查
		if FileAccess.file_exists(bg_path.trim_prefix("res://")):
			print("FileAccess 报告文件存在，但ResourceLoader无法加载")
		else:
			print("FileAccess 也报告文件不存在")

func test_portrait_loading():
	print("测试角色肖像加载...")
	
	# 尝试加载Erika的肖像
	var portrait_path = "res://assets/characters/erika.png"
	print("尝试加载: " + portrait_path)
	
	if ResourceLoader.exists(portrait_path):
		print("ResourceLoader 报告文件存在")
		var texture = ResourceLoader.load(portrait_path)
		if texture:
			print("成功加载角色肖像纹理!")
			
			# 创建一个临时的TextureRect来显示肖像
			var texture_rect = TextureRect.new()
			texture_rect.texture = texture
			texture_rect.expand = true
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			texture_rect.size = Vector2(200, 200)
			texture_rect.position = Vector2(500, 50)
			
			# 添加到场景中
			add_child(texture_rect)
			print("已添加肖像预览到场景")
		else:
			print("加载失败，无法获取纹理")
	else:
		print("ResourceLoader 报告文件不存在")
		
		# 尝试使用FileAccess检查
		if FileAccess.file_exists(portrait_path.trim_prefix("res://")):
			print("FileAccess 报告文件存在，但ResourceLoader无法加载")
		else:
			print("FileAccess 也报告文件不存在")
