extends Node

# Base emotions (0-100)
enum EmotionType {
	JOY,
	SORROW,
	ANGER,
	FEAR,
	CURIOSITY,
	CONFUSION,
	IMPULSE
}

# Compound emotions
enum CompoundEmotionType {
	HOPE,
	JEALOUSY,
	NOSTALGIA,
	AWE,
	CONFLICT
}

# Emotion data storage
var character_emotions = {
	"isa": {
		"base": {
			EmotionType.JOY: 45,
			EmotionType.SORROW: 30,
			EmotionType.ANGER: 15,
			EmotionType.FEAR: 25,
			EmotionType.CURIOSITY: 70,
			EmotionType.CONFUSION: 40,
			EmotionType.IMPULSE: 35
		},
		"compound": {
			CompoundEmotionType.HOPE: {"value": 56, "active": true},
			CompoundEmotionType.JEALOUSY: {"value": 0, "active": false},
			CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
			CompoundEmotionType.AWE: {"value": 46, "active": false},
			CompoundEmotionType.CONFLICT: {"value": 0, "active": false}
		},
		"memory": {}  # For storing emotion memory to ease future activations
	},
	"erika": {
		"base": {
			EmotionType.JOY: 50,
			EmotionType.SORROW: 35,
			EmotionType.ANGER: 30,
			EmotionType.FEAR: 20,
			EmotionType.CURIOSITY: 65,
			EmotionType.CONFUSION: 25,
			EmotionType.IMPULSE: 45
		},
		"compound": {
			CompoundEmotionType.HOPE: {"value": 62, "active": true},
			CompoundEmotionType.JEALOUSY: {"value": 0, "active": false},
			CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
			CompoundEmotionType.AWE: {"value": 53, "active": true},
			CompoundEmotionType.CONFLICT: {"value": 0, "active": false}
		},
		"memory": {}
	},
	"neil": {
		"base": {
			EmotionType.JOY: 25,
			EmotionType.SORROW: 45,
			EmotionType.ANGER: 40,
			EmotionType.FEAR: 50,
			EmotionType.CURIOSITY: 60,
			EmotionType.CONFUSION: 35,
			EmotionType.IMPULSE: 30
		},
		"compound": {
			CompoundEmotionType.HOPE: {"value": 0, "active": false},
			CompoundEmotionType.JEALOUSY: {"value": 0, "active": false},
			CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
			CompoundEmotionType.AWE: {"value": 49, "active": false},
			CompoundEmotionType.CONFLICT: {"value": 0, "active": false}
		},
		"memory": {}
	},
	"kai": {
		"base": {
			EmotionType.JOY: 30,
			EmotionType.SORROW: 20,
			EmotionType.ANGER: 60,
			EmotionType.FEAR: 35,
			EmotionType.CURIOSITY: 55,
			EmotionType.CONFUSION: 30,
			EmotionType.IMPULSE: 70
		},
		"compound": {
			CompoundEmotionType.HOPE: {"value": 0, "active": false},
			CompoundEmotionType.JEALOUSY: {"value": 51, "active": true},
			CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
			CompoundEmotionType.AWE: {"value": 0, "active": false},
			CompoundEmotionType.CONFLICT: {"value": 60, "active": true}
		},
		"memory": {}
	}
}

# Activation thresholds
const ACTIVATION_THRESHOLD = 50
const MAINTAIN_THRESHOLD = 40
const MAX_EMOTION_CHANGE = {
	"normal": 15,
	"key": 25,
	"crisis": 35
}

# Emotion names for display
var emotion_names = {
	EmotionType.JOY: "喜悦",
	EmotionType.SORROW: "悲伤",
	EmotionType.ANGER: "愤怒",
	EmotionType.FEAR: "恐惧",
	EmotionType.CURIOSITY: "好奇",
	EmotionType.CONFUSION: "困惑",
	EmotionType.IMPULSE: "冲动"
}

var compound_emotion_names = {
	CompoundEmotionType.HOPE: "希望",
	CompoundEmotionType.JEALOUSY: "嫉妒",
	CompoundEmotionType.NOSTALGIA: "怀念",
	CompoundEmotionType.AWE: "敬畏",
	CompoundEmotionType.CONFLICT: "冲突"
}

# Signal for when emotions change
signal emotion_changed(character_id, emotion_type, old_value, new_value)
signal compound_emotion_activated(character_id, compound_emotion, value)
signal compound_emotion_deactivated(character_id, compound_emotion)

func _ready():
	# Connect signals if needed
	pass

# Get base emotion value
func get_emotion(character_id, emotion_type):
	if character_id in character_emotions and emotion_type in character_emotions[character_id]["base"]:
		return character_emotions[character_id]["base"][emotion_type]
	return 0

# Get compound emotion value and status
func get_compound_emotion(character_id, compound_emotion):
	if character_id in character_emotions and compound_emotion in character_emotions[character_id]["compound"]:
		return character_emotions[character_id]["compound"][compound_emotion]
	return {"value": 0, "active": false}

# Change a character's emotion by a specified amount
func change_emotion(character_id, emotion_type, amount, change_type="normal"):
	if not character_id in character_emotions:
		return
	
	if not emotion_type in character_emotions[character_id]["base"]:
		return
		
	var old_value = character_emotions[character_id]["base"][emotion_type]
	var max_change = MAX_EMOTION_CHANGE[change_type]
	
	# Limit change to max allowed
	amount = clamp(amount, -max_change, max_change)
	
	var new_value = clamp(old_value + amount, 0, 100)
	character_emotions[character_id]["base"][emotion_type] = new_value
	
	# Emit signal for UI updates
	emit_signal("emotion_changed", character_id, emotion_type, old_value, new_value)
	
	# Calculate compound emotions after base emotion changes
	calculate_compound_emotions(character_id)

# Calculate compound emotions based on base emotions
func calculate_compound_emotions(character_id):
	if not character_id in character_emotions:
		return
		
	var base = character_emotions[character_id]["base"]
	var compound = character_emotions[character_id]["compound"]
	
	# Hope = Joy×0.35 + Curiosity×0.35 + Fear×0.15 + Impulse×0.15
	if base[EmotionType.JOY] > 40 and base[EmotionType.CURIOSITY] > 40 and base[EmotionType.FEAR] <= 30:
		var hope_value = base[EmotionType.JOY] * 0.35 + base[EmotionType.CURIOSITY] * 0.35 + base[EmotionType.FEAR] * 0.15 + base[EmotionType.IMPULSE] * 0.15
		update_compound_emotion(character_id, CompoundEmotionType.HOPE, hope_value)
	else:
		# Deactivate if conditions aren't met
		if compound[CompoundEmotionType.HOPE]["active"]:
			if compound[CompoundEmotionType.HOPE]["value"] < MAINTAIN_THRESHOLD:
				deactivate_compound_emotion(character_id, CompoundEmotionType.HOPE)
	
	# Jealousy = Anger×0.3 + Fear×0.3 + Affinity×0.2 + Impulse×0.2 (using Impulse as approximation for Affinity)
	if base[EmotionType.ANGER] > 35 and base[EmotionType.FEAR] > 30 and base[EmotionType.IMPULSE] > 30:
		var jealousy_value = base[EmotionType.ANGER] * 0.3 + base[EmotionType.FEAR] * 0.3 + base[EmotionType.IMPULSE] * 0.4
		update_compound_emotion(character_id, CompoundEmotionType.JEALOUSY, jealousy_value)
	else:
		if compound[CompoundEmotionType.JEALOUSY]["active"]:
			if compound[CompoundEmotionType.JEALOUSY]["value"] < MAINTAIN_THRESHOLD:
				deactivate_compound_emotion(character_id, CompoundEmotionType.JEALOUSY)
	
	# Nostalgia = Joy×0.25 + Sorrow×0.35 + Affinity×0.3 + Impulse×0.1 (using Impulse as part of Affinity)
	if base[EmotionType.JOY] > 30 and base[EmotionType.SORROW] > 40:
		var nostalgia_value = base[EmotionType.JOY] * 0.25 + base[EmotionType.SORROW] * 0.35 + base[EmotionType.IMPULSE] * 0.4
		update_compound_emotion(character_id, CompoundEmotionType.NOSTALGIA, nostalgia_value)
	else:
		if compound[CompoundEmotionType.NOSTALGIA]["active"]:
			if compound[CompoundEmotionType.NOSTALGIA]["value"] < MAINTAIN_THRESHOLD:
				deactivate_compound_emotion(character_id, CompoundEmotionType.NOSTALGIA)
	
	# Awe = Fear×0.25 + Curiosity×0.35 + Confusion×0.25 + Impulse×0.15
	if base[EmotionType.FEAR] > 25 and base[EmotionType.CURIOSITY] > 50 and base[EmotionType.CONFUSION] > 30:
		var awe_value = base[EmotionType.FEAR] * 0.25 + base[EmotionType.CURIOSITY] * 0.35 + base[EmotionType.CONFUSION] * 0.25 + base[EmotionType.IMPULSE] * 0.15
		update_compound_emotion(character_id, CompoundEmotionType.AWE, awe_value)
	else:
		if compound[CompoundEmotionType.AWE]["active"]:
			if compound[CompoundEmotionType.AWE]["value"] < MAINTAIN_THRESHOLD:
				deactivate_compound_emotion(character_id, CompoundEmotionType.AWE)
	
	# Conflict = Anger×0.3 + Impulse×0.4 + Confusion×0.3
	if base[EmotionType.ANGER] > 30 and base[EmotionType.IMPULSE] > 45 and base[EmotionType.CONFUSION] > 25:
		var conflict_value = base[EmotionType.ANGER] * 0.3 + base[EmotionType.IMPULSE] * 0.4 + base[EmotionType.CONFUSION] * 0.3
		update_compound_emotion(character_id, CompoundEmotionType.CONFLICT, conflict_value)
	else:
		if compound[CompoundEmotionType.CONFLICT]["active"]:
			if compound[CompoundEmotionType.CONFLICT]["value"] < MAINTAIN_THRESHOLD:
				deactivate_compound_emotion(character_id, CompoundEmotionType.CONFLICT)

# Update a compound emotion's value and activation state
func update_compound_emotion(character_id, compound_emotion, value):
	if not character_id in character_emotions:
		return
		
	var compound = character_emotions[character_id]["compound"]
	var was_active = compound[compound_emotion]["active"]
	var old_value = compound[compound_emotion]["value"]
	
	# Update value
	compound[compound_emotion]["value"] = value
	
	# Check activation
	if not was_active and value >= ACTIVATION_THRESHOLD:
		compound[compound_emotion]["active"] = true
		emit_signal("compound_emotion_activated", character_id, compound_emotion, value)
	elif was_active and value < MAINTAIN_THRESHOLD:
		compound[compound_emotion]["active"] = false
		emit_signal("compound_emotion_deactivated", character_id, compound_emotion)

# Deactivate a compound emotion
func deactivate_compound_emotion(character_id, compound_emotion):
	if not character_id in character_emotions:
		return
	
	var compound = character_emotions[character_id]["compound"]
	if compound[compound_emotion]["active"]:
		compound[compound_emotion]["active"] = false
		emit_signal("compound_emotion_deactivated", character_id, compound_emotion)

# Get a descriptive emotional state based on dominant emotions
func get_emotional_state_description(character_id):
	if not character_id in character_emotions:
		return "未知"
		
	var base = character_emotions[character_id]["base"]
	var compound = character_emotions[character_id]["compound"]
	
	# Find dominant base emotion
	var max_emotion = -1
	var max_value = -1
	
	for emotion in base:
		if base[emotion] > max_value:
			max_value = base[emotion]
			max_emotion = emotion
	
	var description = emotion_names[max_emotion]
	
	# Add active compound emotions
	var active_compounds = []
	for compound_emotion in compound:
		if compound[compound_emotion]["active"]:
			active_compounds.append(compound_emotion_names[compound_emotion])
	
	if active_compounds.size() > 0:
		description += "，" + "、".join(active_compounds)
	
	return description

# Reset characters to their initial emotion states
func reset_emotions():
	# Reset to initial values from the readme
	character_emotions = {
		"isa": {
			"base": {
				EmotionType.JOY: 45,
				EmotionType.SORROW: 30,
				EmotionType.ANGER: 15,
				EmotionType.FEAR: 25,
				EmotionType.CURIOSITY: 70,
				EmotionType.CONFUSION: 40,
				EmotionType.IMPULSE: 35
			},
			"compound": {
				CompoundEmotionType.HOPE: {"value": 56, "active": true},
				CompoundEmotionType.JEALOUSY: {"value": 0, "active": false},
				CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
				CompoundEmotionType.AWE: {"value": 46, "active": false},
				CompoundEmotionType.CONFLICT: {"value": 0, "active": false}
			},
			"memory": {}
		},
		"erika": {
			"base": {
				EmotionType.JOY: 50,
				EmotionType.SORROW: 35,
				EmotionType.ANGER: 30,
				EmotionType.FEAR: 20,
				EmotionType.CURIOSITY: 65,
				EmotionType.CONFUSION: 25,
				EmotionType.IMPULSE: 45
			},
			"compound": {
				CompoundEmotionType.HOPE: {"value": 62, "active": true},
				CompoundEmotionType.JEALOUSY: {"value": 0, "active": false},
				CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
				CompoundEmotionType.AWE: {"value": 53, "active": true},
				CompoundEmotionType.CONFLICT: {"value": 0, "active": false}
			},
			"memory": {}
		},
		"neil": {
			"base": {
				EmotionType.JOY: 25,
				EmotionType.SORROW: 45,
				EmotionType.ANGER: 40,
				EmotionType.FEAR: 50,
				EmotionType.CURIOSITY: 60,
				EmotionType.CONFUSION: 35,
				EmotionType.IMPULSE: 30
			},
			"compound": {
				CompoundEmotionType.HOPE: {"value": 0, "active": false},
				CompoundEmotionType.JEALOUSY: {"value": 0, "active": false},
				CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
				CompoundEmotionType.AWE: {"value": 49, "active": false},
				CompoundEmotionType.CONFLICT: {"value": 0, "active": false}
			},
			"memory": {}
		},
		"kai": {
			"base": {
				EmotionType.JOY: 30,
				EmotionType.SORROW: 20,
				EmotionType.ANGER: 60,
				EmotionType.FEAR: 35,
				EmotionType.CURIOSITY: 55,
				EmotionType.CONFUSION: 30,
				EmotionType.IMPULSE: 70
			},
			"compound": {
				CompoundEmotionType.HOPE: {"value": 0, "active": false},
				CompoundEmotionType.JEALOUSY: {"value": 51, "active": true},
				CompoundEmotionType.NOSTALGIA: {"value": 0, "active": false},
				CompoundEmotionType.AWE: {"value": 0, "active": false},
				CompoundEmotionType.CONFLICT: {"value": 60, "active": true}
			},
			"memory": {}
		}
	}