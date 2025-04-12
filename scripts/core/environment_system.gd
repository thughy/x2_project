extends Node

enum SceneType {
	RESEARCH,
	PRIVATE,
	PUBLIC,
	BOUNDARY,
	CRISIS
}

enum Weather {
	CLEAR,
	CLOUDY,
	OVERCAST,
	LIGHT_RAIN,
	HEAVY_RAIN,
	THUNDERSTORM,
	FOGGY,
	SNOWY
}

enum TimeOfDay {
	DAWN,
	MORNING,
	NOON,
	AFTERNOON,
	DUSK,
	EVENING,
	NIGHT,
	MIDNIGHT
}

enum Temperature {
	COLD,
	COOL,
	MILD,
	WARM,
	HOT
}

# Scene type descriptions
var scene_type_descriptions = {
	SceneType.RESEARCH: "研究空间 - 理性、结构化、目标导向",
	SceneType.PRIVATE: "私人空间 - 亲密、放松、真实",
	SceneType.PUBLIC: "公共空间 - 社交、规范、表达受限",
	SceneType.BOUNDARY: "边界空间 - 反思、过渡、象征性",
	SceneType.CRISIS: "危机空间 - 紧张、危险、决断"
}

# Weather descriptions
var weather_descriptions = {
	Weather.CLEAR: "晴朗",
	Weather.CLOUDY: "多云",
	Weather.OVERCAST: "阴天",
	Weather.LIGHT_RAIN: "小雨",
	Weather.HEAVY_RAIN: "暴雨",
	Weather.THUNDERSTORM: "雷暴",
	Weather.FOGGY: "雾天",
	Weather.SNOWY: "雪天"
}

# Time of day descriptions
var time_descriptions = {
	TimeOfDay.DAWN: "黎明",
	TimeOfDay.MORNING: "早晨",
	TimeOfDay.NOON: "正午",
	TimeOfDay.AFTERNOON: "下午",
	TimeOfDay.DUSK: "黄昏",
	TimeOfDay.EVENING: "夜晚",
	TimeOfDay.NIGHT: "深夜",
	TimeOfDay.MIDNIGHT: "午夜"
}

# Temperature descriptions
var temperature_descriptions = {
	Temperature.COLD: "寒冷",
	Temperature.COOL: "凉爽",
	Temperature.MILD: "温和",
	Temperature.WARM: "温暖",
	Temperature.HOT: "炎热"
}

# Current environment state
var current_environment = {
	"scene_type": SceneType.RESEARCH,
	"weather": Weather.CLEAR,
	"time": TimeOfDay.MORNING,
	"temperature": Temperature.MILD
}

# Signal for environment changes
signal environment_changed(old_env, new_env)

func _ready():
	pass

# 重置环境系统到默认状态
func reset_environment():
	print("[环境系统] 重置环境系统到默认状态...")
	
	# 保存当前环境以便发送信号
	var old_env = current_environment.duplicate()
	
	# 重置为默认环境
	current_environment = {
		"scene_type": SceneType.RESEARCH,
		"weather": Weather.CLEAR,
		"time": TimeOfDay.MORNING,
		"temperature": Temperature.MILD
	}
	
	# 发送环境变化信号
	emit_signal("environment_changed", old_env, current_environment)
	
	print("[环境系统] 环境系统已重置为默认状态")

# Get the current scene type
func get_scene_type():
	return current_environment["scene_type"]

# Get the current weather
func get_weather():
	return current_environment["weather"]

# Get the current time
func get_time():
	return current_environment["time"]

# Get the current temperature
func get_temperature():
	return current_environment["temperature"]

# Get the description of the current environment
func get_environment_description():
	var scene_desc = scene_type_descriptions[current_environment["scene_type"]]
	var weather_desc = weather_descriptions[current_environment["weather"]]
	var time_desc = time_descriptions[current_environment["time"]]
	var temp_desc = temperature_descriptions[current_environment["temperature"]]
	
	return "场景：%s\n时间：%s，天气：%s，温度：%s" % [scene_desc, time_desc, weather_desc, temp_desc]

# Change the environment
func change_environment(new_scene_type = null, new_weather = null, new_time = null, new_temperature = null):
	var old_env = current_environment.duplicate()
	
	if new_scene_type != null:
		current_environment["scene_type"] = new_scene_type
	
	if new_weather != null:
		current_environment["weather"] = new_weather
	
	if new_time != null:
		current_environment["time"] = new_time
	
	if new_temperature != null:
		current_environment["temperature"] = new_temperature
	
	emit_signal("environment_changed", old_env, current_environment)

# Get emotion modifiers based on current environment
func get_emotion_modifiers():
	var modifiers = {}
	
	# Scene type effects
	match current_environment["scene_type"]:
		SceneType.RESEARCH:
			modifiers["curiosity"] = 10
			modifiers["joy"] = -5
		SceneType.PRIVATE:
			modifiers["confusion"] = -10
			modifiers["impulse"] = 10
		SceneType.PUBLIC:
			modifiers["anger"] = -10
			modifiers["impulse"] = -10
		SceneType.BOUNDARY:
			modifiers["confusion"] = 15
			modifiers["curiosity"] = 15
		SceneType.CRISIS:
			modifiers["fear"] = 20
			modifiers["impulse"] = 15
	
	# Weather effects
	match current_environment["weather"]:
		Weather.CLEAR:
			modifiers["joy"] = 10
			modifiers["sorrow"] = -5
		Weather.CLOUDY:
			# Neutral
			pass
		Weather.OVERCAST:
			modifiers["joy"] = -5
			modifiers["sorrow"] = 5
		Weather.LIGHT_RAIN:
			modifiers["sorrow"] = 10
			modifiers["nostalgia"] = 15
		Weather.HEAVY_RAIN:
			modifiers["fear"] = 5
			modifiers["sorrow"] = 15
		Weather.THUNDERSTORM:
			modifiers["fear"] = 15
			modifiers["impulse"] = 10
		Weather.FOGGY:
			modifiers["confusion"] = 15
			modifiers["awe"] = 10
		Weather.SNOWY:
			modifiers["nostalgia"] = 20
			modifiers["joy"] = 5
	
	# Time effects
	match current_environment["time"]:
		TimeOfDay.DAWN, TimeOfDay.DUSK:
			modifiers["awe"] = 15
			modifiers["hope"] = 10
		TimeOfDay.MORNING:
			modifiers["joy"] = 5
			modifiers["hope"] = 5
		TimeOfDay.NOON:
			# Neutral
			pass
		TimeOfDay.AFTERNOON:
			# Neutral
			pass
		TimeOfDay.EVENING:
			modifiers["nostalgia"] = 10
		TimeOfDay.NIGHT, TimeOfDay.MIDNIGHT:
			modifiers["confusion"] = 10
			modifiers["fear"] = 5
	
	return modifiers

# Check for special environment combinations
func check_special_combinations():
	var specials = []
	
	# Revelation moment: Boundary space + Dawn/Dusk
	if current_environment["scene_type"] == SceneType.BOUNDARY and (
		current_environment["time"] == TimeOfDay.DAWN or 
		current_environment["time"] == TimeOfDay.DUSK
	):
		specials.append({
			"name": "启示时刻",
			"effects": {
				"awe": 30,
				"hope": 25
			}
		})
	
	# Emotional storm: Private space + Thunderstorm/Heavy rain
	if current_environment["scene_type"] == SceneType.PRIVATE and (
		current_environment["weather"] == Weather.THUNDERSTORM or 
		current_environment["weather"] == Weather.HEAVY_RAIN
	):
		specials.append({
			"name": "情感风暴",
			"effects": {
				"emotion_intensity": 1.4,  # 40% stronger emotions
				"impulse": 25
			}
		})
	
	# Quiet reflection: Private space + Snowy/Night
	if current_environment["scene_type"] == SceneType.PRIVATE and (
		current_environment["weather"] == Weather.SNOWY or 
		current_environment["time"] == TimeOfDay.NIGHT
	):
		specials.append({
			"name": "静谧反思",
			"effects": {
				"nostalgia": 35,
				"confusion": -20
			}
		})
	
	# Crisis together: Crisis space + Extreme weather
	if current_environment["scene_type"] == SceneType.CRISIS and (
		current_environment["weather"] == Weather.THUNDERSTORM or
		current_environment["weather"] == Weather.HEAVY_RAIN or
		current_environment["weather"] == Weather.SNOWY
	):
		specials.append({
			"name": "危机共处",
			"effects": {
				"fear": 35,
				"dependence": 30
			}
		})
	
	return specials

# Apply environmental effects to a character's emotions
func apply_environment_effects(character_id):
	var modifiers = get_emotion_modifiers()
	var specials = check_special_combinations()
	var emotion_system = get_node("/root/EmotionSystem")
	
	# Apply base modifiers (small constant effects)
	for emotion_name in modifiers:
		match emotion_name:
			"joy":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.JOY, modifiers[emotion_name] * 0.1)
			"sorrow":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.SORROW, modifiers[emotion_name] * 0.1)
			"anger":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.ANGER, modifiers[emotion_name] * 0.1)
			"fear":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.FEAR, modifiers[emotion_name] * 0.1)
			"curiosity":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.CURIOSITY, modifiers[emotion_name] * 0.1)
			"confusion":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.CONFUSION, modifiers[emotion_name] * 0.1)
			"impulse":
				emotion_system.change_emotion(character_id, emotion_system.EmotionType.IMPULSE, modifiers[emotion_name] * 0.1)
	
	# Apply special combination effects (stronger, one-time effects)
	for special in specials:
		for effect_name in special.effects:
			match effect_name:
				"joy":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.JOY, special.effects[effect_name] * 0.1)
				"sorrow":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.SORROW, special.effects[effect_name] * 0.1)
				"anger":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.ANGER, special.effects[effect_name] * 0.1)
				"fear":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.FEAR, special.effects[effect_name] * 0.1)
				"curiosity":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.CURIOSITY, special.effects[effect_name] * 0.1)
				"confusion":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.CONFUSION, special.effects[effect_name] * 0.1)
				"impulse":
					emotion_system.change_emotion(character_id, emotion_system.EmotionType.IMPULSE, special.effects[effect_name] * 0.1)
				"hope", "awe", "nostalgia", "jealousy", "conflict":
					# Special handling for compound emotions may require custom logic
					pass
				"dependence":
					# This affects relationships rather than emotions
					var relationship_system = get_node("/root/RelationshipSystem")
					# Find all other characters and increase dependence
					for other_char in ["isa", "erika", "neil", "kai"]:
						if other_char != character_id:
							relationship_system.change_relationship(
								character_id, 
								other_char, 
								relationship_system.RelationshipDimension.DEPENDENCE, 
								special.effects[effect_name] * 0.1
							)