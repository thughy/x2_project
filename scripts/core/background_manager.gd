extends Node

# This script manages background loading and transitions

# Background texture paths
var background_textures = {
	"research": "res://assets/background/background_research.png",
	"private": "res://assets/background/background_private.png",
	"public": "res://assets/background/background_public.png",
	"boundary": "res://assets/background/background_boundary.png",
	"crisis": "res://assets/background/background_crisis.png"
}

# Get background texture path based on scene type
func get_background_path(scene_type):
	var environment_system = get_node("/root/EnvironmentSystem")
	
	var scene_name = ""
	match scene_type:
		environment_system.SceneType.RESEARCH:
			scene_name = "research"
		environment_system.SceneType.PRIVATE:
			scene_name = "private"
		environment_system.SceneType.PUBLIC:
			scene_name = "public"
		environment_system.SceneType.BOUNDARY:
			scene_name = "boundary"
		environment_system.SceneType.CRISIS:
			scene_name = "crisis"
	
	# Check if the background exists in the background folder
	var path = background_textures[scene_name]
	if FileAccess.file_exists(path.trim_prefix("res://")):
		return path
	
	# Check if the background exists in the backgrounds folder (with 's')
	var alt_path = "res://assets/backgrounds/background_" + scene_name + ".png"
	if FileAccess.file_exists(alt_path.trim_prefix("res://")):
		return alt_path
	
	# Return a default path if neither exists
	return "res://assets/background/background_research.png"

# Load background texture based on scene type
func load_background(scene_type):
	# 打印当前场景类型以便调试
	print("正在加载场景类型:", scene_type, "的背景")
	
	# 尝试直接从assets/background目录加载
	var bg_path = ""
	var environment_system = get_node("/root/EnvironmentSystem")
	
	# 确定场景名称
	var scene_name = ""
	match scene_type:
		environment_system.SceneType.RESEARCH:
			scene_name = "research"
		environment_system.SceneType.PRIVATE:
			scene_name = "private"
		environment_system.SceneType.PUBLIC:
			scene_name = "public"
		environment_system.SceneType.BOUNDARY:
			scene_name = "boundary"
		environment_system.SceneType.CRISIS:
			scene_name = "crisis"
	
	# 尝试从background目录加载
	bg_path = "res://assets/background/background_" + scene_name + ".png"
	print("尝试加载背景路径1:", bg_path)
	
	if ResourceLoader.exists(bg_path):
		var texture = load(bg_path)
		if texture:
			print("成功加载背景:", bg_path)
			return texture
		else:
			print("加载背景失败:", bg_path)
	else:
		print("背景资源不存在:", bg_path)
	
	# 尝试从backgrounds目录加载（注意多了一个s）
	bg_path = "res://assets/backgrounds/background_" + scene_name + ".png"
	print("尝试加载背景路径2:", bg_path)
	
	if ResourceLoader.exists(bg_path):
		var texture = load(bg_path)
		if texture:
			print("成功加载背景:", bg_path)
			return texture
		else:
			print("加载背景失败:", bg_path)
	else:
		print("背景资源不存在:", bg_path)
	
	# 如果都失败了，打印详细的错误信息
	print("警告: 无法加载任何背景图像，将使用纯色背景替代")
	return null
