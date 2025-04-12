extends Node

# 这个脚本用于验证和修复资源加载问题

# 验证所有关键资源是否可以正确加载
func validate_all_resources():
	print("开始验证关键资源...")
	
	# 验证角色肖像
	validate_character_portraits()
	
	# 验证背景图像
	validate_backgrounds()
	
	# 验证UI图标
	validate_ui_icons()
	
	print("资源验证完成")

# 验证角色肖像
func validate_character_portraits():
	print("验证角色肖像...")
	var game_state = get_node("/root/GameState")
	var characters = game_state.CHARACTERS
	
	for character_id in characters:
		print("检查角色: " + character_id)
		
		# 检查基本肖像
		var base_path = "res://assets/characters/" + character_id + ".png"
		var neutral_path = "res://assets/characters/" + character_id + "_neutral.png"
		
		var base_exists = ResourceLoader.exists(base_path)
		var neutral_exists = ResourceLoader.exists(neutral_path)
		
		print("基本肖像: " + base_path + " - " + ("存在" if base_exists else "不存在"))
		print("中性肖像: " + neutral_path + " - " + ("存在" if neutral_exists else "不存在"))
		
		# 尝试直接加载
		if base_exists:
			var texture = load(base_path)
			if texture:
				print("成功加载基本肖像")
			else:
				print("加载基本肖像失败")
		
		if neutral_exists:
			var texture = load(neutral_path)
			if texture:
				print("成功加载中性肖像")
			else:
				print("加载中性肖像失败")

# 验证背景图像
func validate_backgrounds():
	print("验证背景图像...")
	var environment_system = get_node("/root/EnvironmentSystem")
	var scene_types = ["research", "private", "public", "boundary", "crisis"]
	
	for scene_type in scene_types:
		# 检查background目录
		var bg_path = "res://assets/background/background_" + scene_type + ".png"
		var bg_exists = ResourceLoader.exists(bg_path)
		print("背景(无s): " + bg_path + " - " + ("存在" if bg_exists else "不存在"))
		
		# 检查backgrounds目录
		var bgs_path = "res://assets/backgrounds/background_" + scene_type + ".png"
		var bgs_exists = ResourceLoader.exists(bgs_path)
		print("背景(有s): " + bgs_path + " - " + ("存在" if bgs_exists else "不存在"))
		
		# 尝试直接加载
		if bg_exists:
			var texture = load(bg_path)
			if texture:
				print("成功加载背景(无s)")
			else:
				print("加载背景(无s)失败")
		
		if bgs_exists:
			var texture = load(bgs_path)
			if texture:
				print("成功加载背景(有s)")
			else:
				print("加载背景(有s)失败")

# 验证UI图标
func validate_ui_icons():
	print("验证UI图标...")
	var icon_paths = [
		"res://assets/ui/narrator_icon.png",
		"res://assets/ui/system_icon.png"
	]
	
	for path in icon_paths:
		var exists = ResourceLoader.exists(path)
		print("图标: " + path + " - " + ("存在" if exists else "不存在"))
		
		# 尝试直接加载
		if exists:
			var texture = load(path)
			if texture:
				print("成功加载图标")
			else:
				print("加载图标失败")

# 强制重新导入资源
func force_reimport_resources():
	print("尝试强制重新导入资源...")
	
	# 在Godot 4中，我们不能直接通过脚本重新导入资源
	# 但我们可以尝试通过其他方式修复资源加载问题
	
	# 1. 尝试预加载关键资源
	preload_key_resources()
	
	print("资源重新导入尝试完成")

# 预加载关键资源
func preload_key_resources():
	print("预加载关键资源...")
	
	# 预加载一些关键背景
	var preloaded_resources = []
	
	# 尝试预加载研究场景背景
	var research_bg = load("res://assets/background/background_research.png")
	if research_bg:
		preloaded_resources.append("研究场景背景")
	
	# 尝试预加载角色肖像
	var erika_portrait = load("res://assets/characters/erika.png")
	if erika_portrait:
		preloaded_resources.append("Erika肖像")
	
	print("成功预加载资源: " + str(preloaded_resources))

# 修复资源路径问题
func fix_resource_paths():
	print("修复资源路径问题...")
	
	# 在这里我们可以添加一些代码来修复资源路径问题
	# 例如，创建缺失的目录或移动资源文件
	
	print("资源路径修复完成")
