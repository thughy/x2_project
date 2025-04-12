@tool
extends EditorScript

# 检查重要图像资源和路径

func _run():
	print("\n===== 图像资源调试工具 =====")
	
	# 检查角色肖像
	check_character_portraits()
	
	# 检查UI图标
	check_ui_icons()
	
	# 检查背景图像
	check_backgrounds()
	
	print("\n===== 调试完成 =====")

func check_character_portraits():
	print("\n----- 检查角色肖像 -----")
	
	var characters = ["isa", "erika", "neil", "kai"]
	var emotions = [
		"neutral", "curious", "happy", "sad", "confused", 
		"surprised", "warm", "awe", "hopeful", "reflective"
	]
	
	var missing_count = 0
	var total_count = 0
	
	for character in characters:
		for emotion in emotions:
			var path = "res://assets/characters/" + character + "_" + emotion + ".png"
			total_count += 1
			
			if ResourceLoader.exists(path):
				# 尝试加载资源
				var texture = load(path)
				if texture:
					var size = texture.get_size()
					if size.x != 512 or size.y != 512:
						print("⚠️ " + path + " - 尺寸不是512x512 (实际: " + str(size.x) + "x" + str(size.y) + ")")
					else:
						print("✓ " + path + " - 正确加载")
				else:
					print("❌ " + path + " - 存在但无法加载")
					missing_count += 1
			else:
				print("❌ " + path + " - 文件不存在")
				missing_count += 1
	
	print("\n角色肖像总结: 已检查 " + str(total_count) + " 个文件，缺少 " + str(missing_count) + " 个")
	
	# 检查通用默认肖像
	var default_path = "res://assets/characters/_neutral.png"
	if ResourceLoader.exists(default_path):
		print("✓ 默认肖像存在: " + default_path)
	else:
		print("❌ 默认肖像不存在: " + default_path)

func check_ui_icons():
	print("\n----- 检查UI图标 -----")
	
	var ui_paths = [
		"res://assets/ui/narrator_icon.png",
		"res://assets/ui/system_icon.png"
	]
	
	for path in ui_paths:
		if ResourceLoader.exists(path):
			var texture = load(path)
			if texture:
				var size = texture.get_size()
				if size.x != 128 or size.y != 128:
					print("⚠️ " + path + " - 尺寸不是128x128 (实际: " + str(size.x) + "x" + str(size.y) + ")")
				else:
					print("✓ " + path + " - 正确加载")
			else:
				print("❌ " + path + " - 存在但无法加载")
		else:
			print("❌ " + path + " - 文件不存在")

func check_backgrounds():
	print("\n----- 检查背景图像 -----")
	
	var scene_types = ["research", "private", "public", "boundary", "crisis"]
	var missing_count = 0
	
	# 检查两种可能的路径
	var path_formats = [
		"res://assets/background/background_%s.png",
		"res://assets/backgrounds/background_%s.png"
	]
	
	for scene in scene_types:
		var found = false
		
		for path_format in path_formats:
			var path = path_format % scene
			
			if ResourceLoader.exists(path):
				var texture = load(path)
				if texture:
					var size = texture.get_size()
					if size.x != 1280 or size.y != 720:
						print("⚠️ " + path + " - 尺寸不是1280x720 (实际: " + str(size.x) + "x" + str(size.y) + ")")
					else:
						print("✓ " + path + " - 正确加载")
					found = true
					break
		
		if not found:
			missing_count += 1
			print("❌ 背景图像缺失: background_" + scene + ".png")
	
	print("\n背景图像总结: 已检查 " + str(scene_types.size()) + " 个场景，缺少 " + str(missing_count) + " 个背景")
	
	# 提供修复建议
	if missing_count > 0:
		print("\n建议: 运行以下脚本以修复背景路径问题:")
		print("python scripts/tools/fix_background_paths.py") 