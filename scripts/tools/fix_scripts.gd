extends SceneTree

# 这个脚本用于修复项目中的脚本文件
# 从命令行运行: godot --headless --script scripts/tools/fix_scripts.gd

func _init():
	print("开始修复脚本文件...")
	
	# 核心系统脚本
	fix_script("res://scripts/core/game_state.gd")
	fix_script("res://scripts/core/emotion_system.gd")
	fix_script("res://scripts/core/relationship_system.gd") 
	fix_script("res://scripts/core/environment_system.gd")
	fix_script("res://scripts/core/input_map_setup.gd")
	
	# 对话系统脚本
	fix_script("res://scripts/dialogue/dialogue_manager.gd")
	fix_script("res://scripts/dialogue/dialogue_scene_controller.gd")
	fix_script("res://scripts/dialogue/chapter1_dialogues.gd")
	
	# 场景脚本
	fix_script("res://scripts/game_scene.gd")
	
	print("脚本修复完成！")
	quit()

# 修复脚本，确保格式正确并且以extends Node或适当的类开头
func fix_script(path):
	if not FileAccess.file_exists(path):
		print("文件不存在: " + path)
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	# 检测文件的第一行
	var lines = content.split("\n")
	var first_line = lines[0].strip_edges() if lines.size() > 0 else ""
	
	# 如果第一行不是以extends开头，添加适当的extends
	if not first_line.begins_with("extends"):
		print("修复文件: " + path + " (添加extends Node)")
		content = "extends Node\n\n" + content
		
		# 写回文件
		file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(content)
		file.close()
	else:
		print("文件正常: " + path)
		
	# 额外确认文件不包含非法字符
	file = FileAccess.open(path, FileAccess.READ_WRITE)
	content = file.get_as_text()
	
	# 移除Unicode BOM标记和其他可能导致问题的字符
	if content.begins_with("\uFEFF"):
		print("移除BOM标记: " + path)
		content = content.substr(1)
		file.seek(0)
		file.store_string(content)
	
	file.close() 