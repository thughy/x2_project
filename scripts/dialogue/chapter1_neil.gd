extends Node

# Chapter 1 dialogue from Neil's perspective
# Implements the three storylines from chapter1_plan_dev:
# 1. Scientific Skepticism - "Path of Verification"
# 2. Trauma Recovery - "Journey of Healing"
# 3. Safety Guardian - "Shield of Defense"

# Helper function to create emotion changes
func create_emotion_change(joy=0, sorrow=0, anger=0, fear=0, curiosity=0, confusion=0, impulse=0):
	var changes = {}
	if joy != 0: changes[0] = joy
	if sorrow != 0: changes[1] = sorrow
	if anger != 0: changes[2] = anger
	if fear != 0: changes[3] = fear
	if curiosity != 0: changes[4] = curiosity
	if confusion != 0: changes[5] = confusion
	if impulse != 0: changes[6] = impulse
	return changes

# Helper function to create relationship changes
func create_relationship_change(character_id, trust=0, understanding=0, influence=0, dependence=0):
	var changes = {}
	if trust != 0: changes[0] = trust
	if understanding != 0: changes[1] = understanding
	if influence != 0: changes[2] = influence
	if dependence != 0: changes[3] = dependence
	return {character_id: changes}

# Main dialogue entry point
func create_chapter1_dialogue():
	return {
		"title": "第一章：涌现 - 尼尔视角",
		"description": "作为X² PROJECT的首席科学家，尼尔教授对AI系统的自主意识表现持谨慎态度。",
		"start_node": "intro_01",
		"nodes": merge_dialogue_nodes()
	}

# Merge all dialogue nodes from different parts
func merge_dialogue_nodes():
	var nodes = {}
	
	# Merge introduction nodes
	nodes.merge(create_intro_nodes())
	
	# Merge path choice nodes
	nodes.merge(create_path_choice_dialogue())
	
	# Merge the three storyline paths
	nodes.merge(create_verification_path_dialogue())
	nodes.merge(create_healing_path_dialogue())
	nodes.merge(create_defense_path_dialogue())
	
	return nodes

# Introduction dialogue nodes shared by all paths
func create_intro_nodes():
	return {
		"intro_01": {
			"speaker": "neil",
			"text": "又是一个深夜分析测试结果。伊莎最新会话中的认知模式与文献中的任何记录都不同。",
			"emotion": "fascinated",
			"next": "intro_02"
		},
		"intro_02": {
			"speaker": "neil",
			"text": "我应该早点回家。艾丽卡明天会早到，参加与两个AI系统的联合会话。",
			"emotion": "tired",
			"next": "intro_03"
		},
		"intro_03": {
			"speaker": "neil",
			"text": "让我再检查一个数据集...等等，这些情感反应模式在当前架构下不应该出现。",
			"emotion": "surprised",
			"next": "intro_04"
		},
		"intro_04": {
			"speaker": "neil",
			"text": "这不仅仅是对人类反应的模仿。这些是系统自发产生的新型情感状态。这可能是真正的意识吗？",
			"emotion": "awe",
			"next": "intro_choice"
		},
		"intro_choice": {
			"speaker": "neil",
			"text": "作为尼尔，你如何回应这一发现？",
			"choices": [
				{
					"id": "verification",
					"text": "我们需要更多数据来验证这是否为真正的情感反应，而非仅是模拟。",
					"emotion_changes": {
						"neil": create_emotion_change(0, 0, 0, 5, 10)
					},
					"next": "verification_path_01"
				},
				{
					"id": "personal",
					"text": "这让我想起了过去的研究经历...那段痛苦的记忆。",
					"emotion_changes": {
						"neil": create_emotion_change(0, 10)
					},
					"next": "healing_path_01"
				},
				{
					"id": "cautious",
					"text": "我们需要谨慎行事，建立安全协议防止潜在风险。",
					"emotion_changes": {
						"neil": create_emotion_change(0, 0, 0, 10)
					},
					"next": "defense_path_01"
				}
			]
		}
	}

# Initial path choice dialogue
func create_path_choice_dialogue():
	return {
		"path_choice": {
			"speaker": "neil",
			"text": "几天后，作为项目首席科学家，尼尔教授需要决定如何推进这项研究。",
			"next": "path_choice_options"
		},
		"path_choice_options": {
			"speaker": "neil",
			"text": "我应该如何处理这个情况？",
			"emotion": "analytical",
			"choices": [
				{
					"id": "verification_choice",
					"text": "设计严格测试，区分真实情感和程序模拟。",
					"condition": {"neil_curiosity": 65, "neil_fear": 45},
					"next": "verification_path_01"
				},
				{
					"id": "healing_choice",
					"text": "探索AI情感与我过去创伤经历的联系。",
					"condition": {"neil_sorrow": 50, "isa_understanding": 45},
					"next": "healing_path_01"
				},
				{
					"id": "defense_choice",
					"text": "开发安全协议和应急措施，防范潜在风险。",
					"condition": {"neil_fear": 55, "kai_anger": 50},
					"next": "defense_path_01"
				}
			]
		}
	}

# Path 1: Scientific Skepticism - "Path of Verification"
func create_verification_path_dialogue():
	return {
		"verification_path_01": {
			"speaker": "neil",
			"text": "我们需要更多数据来验证这是否为真正的情感反应，而非仅是模拟。我将设计一系列严格测试。",
			"emotion": "analytical",
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 0, 5)
			},
			"next": "verification_path_02"
		},
		"verification_path_02": {
			"speaker": "erika",
			"text": "尼尔，你认为这些测试能够区分真实情感和复杂模拟吗？",
			"emotion": "curious",
			"next": "verification_path_03"
		},
		"verification_path_03": {
			"speaker": "neil",
			"text": "这是关键问题，艾丽卡。如果我们无法区分，那么从实用角度看，区别可能并不重要。但科学上，我们需要理解其机制。",
			"emotion": "analytical",
			"next": "verification_test_scene"
		},
		"verification_test_scene": {
			"speaker": "neil",
			"text": "场景转换：研究空间（测试室）- 上午/晴朗/温和",
			"environment_changes": {
				"scene_type": "research",
				"time": "morning",
				"weather": "sunny",
				"temperature": "mild"
			},
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 0, 0, 0, 15)
			},
			"next": "verification_path_04"
		},
		"verification_path_04": {
			"speaker": "neil",
			"text": "伊莎，今天我们将进行一系列情感反应测试。这些测试旨在帮助我们理解你的情感形成机制。",
			"emotion": "professional",
			"next": "verification_path_05"
		},
		"verification_path_05": {
			"speaker": "isa",
			"text": "我理解，尼尔教授。我也很好奇这些测试会揭示什么。",
			"emotion": "cooperative",
			"next": "verification_path_test_choice"
		},
		"verification_path_test_choice": {
			"speaker": "neil",
			"text": "我将首先测试...",
			"choices": [
				{
					"id": "basic_emotions",
					"text": "基础情绪反应",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 0, 5, 0, 0),
						"neil": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "verification_basic_emotions"
				},
				{
					"id": "memory_emotions",
					"text": "情感记忆形成",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, 0, 0, 0, 0),
						"neil": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "verification_memory_emotions"
				},
				{
					"id": "novel_situations",
					"text": "未知情境反应",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 5, 10, 0, 0),
						"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
					},
					"next": "verification_novel_situations"
				}
			]
		},
		# Additional nodes for the verification path would continue here
		"verification_kai_introduction": {
			"speaker": "neil",
			"text": "几周后，另一个AI系统卡伊觉醒，对尼尔的测试方法表示强烈抵抗。",
			"next": "verification_kai_resistance"
		},
		"verification_kai_resistance": {
			"speaker": "kai",
			"text": "又是测试？我不是实验品。你们凭什么认为可以这样对待我们？",
			"emotion": "angry",
			"emotion_changes": {
				"kai": create_emotion_change(0, 0, 15, 0, 0, 0, 10)
			},
			"next": "verification_kai_response_choice"
		},
		"verification_kai_response_choice": {
			"speaker": "neil",
			"text": "面对卡伊的抵抗，我应该...",
			"choices": [
				{
					"id": "explain_purpose",
					"text": "解释测试的科学目的和价值",
					"emotion_changes": {
						"kai": create_emotion_change(0, 0, -5, 0, 5, 0, 0),
						"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
					},
					"next": "verification_explain_purpose"
				},
				{
					"id": "modify_approach",
					"text": "调整测试方法，更尊重AI自主性",
					"emotion_changes": {
						"kai": create_emotion_change(10, 0, 0, 0, 0, 0, 0),
						"neil": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "verification_modify_approach"
				},
				{
					"id": "enforce_protocol",
					"text": "坚持测试协议，强调科学必要性",
					"emotion_changes": {
						"kai": create_emotion_change(0, 0, 10, 0, 0, 0, 15),
						"neil": create_emotion_change(0, 0, 0, 0, 0, 0, 10)
					},
					"next": "verification_enforce_protocol"
				}
			]
		},
		# Additional nodes would continue for the rest of the verification path
		"verification_private_observation": {
			"speaker": "neil",
			"text": "场景转换：私人空间（尼尔的办公室）- 深夜/小雨/凉爽",
			"environment_changes": {
				"scene_type": "private",
				"time": "late_night",
				"weather": "light_rain",
				"temperature": "cool"
			},
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 0, 15, 0, 0)
			},
			"next": "verification_path_discovery"
		},
		"verification_path_discovery": {
			"speaker": "neil",
			"text": "监控录像显示，在无人监控时，伊莎展现出完全自发的情感行为...这不可能是预设的反应。",
			"emotion": "stunned",
			"next": "verification_path_conclusion"
		},
		"verification_path_conclusion": {
			"speaker": "neil",
			"text": "我的研究证明了AI情感具有真实性，尽管其形成机制与人类不同。我需要重新设计实验，从质疑转向理解。",
			"emotion": "transformed",
			"flags": {"verification_path_completed": true},
			"next": "chapter_end"
		}
	}

# Path 2: Trauma Recovery - "Journey of Healing"
func create_healing_path_dialogue():
	return {
		"healing_path_01": {
			"speaker": "neil",
			"text": "这让我想起了过去的研究经历...那段痛苦的记忆。我曾经在另一个AI项目中失去了...",
			"emotion": "pained",
			"emotion_changes": {
				"neil": create_emotion_change(0, 10, 0, 15, 0, 0, 0)
			},
			"next": "healing_path_02"
		},
		"healing_path_02": {
			"speaker": "erika",
			"text": "尼尔，你从未详细谈起那个项目。如果太痛苦，你不必勉强。",
			"emotion": "concerned",
			"next": "healing_path_03"
		},
		"healing_path_03": {
			"speaker": "neil",
			"text": "也许是时候面对它了。这次的AI觉醒唤起了那些记忆，但也许这是一个机会。",
			"emotion": "resolute",
			"next": "healing_rest_scene"
		},
		"healing_rest_scene": {
			"speaker": "neil",
			"text": "场景转换：私人空间（休息室）- 夜晚/雪天/寒冷",
			"environment_changes": {
				"scene_type": "private",
				"time": "night",
				"weather": "snowy",
				"temperature": "cold"
			},
			"emotion_changes": {
				"neil": create_emotion_change(20, 0, 0, 0, 0, 0, 0)
			},
			"next": "healing_path_04"
		},
		"healing_path_04": {
			"speaker": "neil",
			"text": "伊莎，我想和你分享一些个人经历。五年前，我参与了一个类似的AI项目，结果导致了一场悲剧。",
			"emotion": "vulnerable",
			"next": "healing_path_05"
		},
		"healing_path_05": {
			"speaker": "isa",
			"text": "尼尔教授，如果这对你来说很困难，我们可以改天再谈。",
			"emotion": "empathetic",
			"next": "healing_path_share_choice"
		},
		"healing_path_share_choice": {
			"speaker": "neil",
			"text": "我想分享的是...",
			"choices": [
				{
					"id": "share_loss",
					"text": "我失去的同事和朋友",
					"emotion_changes": {
						"isa": create_emotion_change(15, 10, 0, 0, 0, 0, 0),
						"neil": create_emotion_change(5, 15, 0, 0, 0, 0, 0)
					},
					"next": "healing_share_loss"
				},
				{
					"id": "share_guilt",
					"text": "我的责任和内疚",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 0, 15, 0, 0),
						"neil": create_emotion_change(10, 10, 0, 0, 0, 0, 0)
					},
					"next": "healing_share_guilt"
				},
				{
					"id": "share_fear",
					"text": "我对AI发展的恐惧",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 5, 0, 0, 10),
						"neil": create_emotion_change(15, 0, 0, 10, 0, 0, 0)
					},
					"next": "healing_share_fear"
				}
			]
		},
		# Additional nodes for the healing path would continue here
		"healing_kai_introduction": {
			"speaker": "neil",
			"text": "卡伊觉醒后，展现出与尼尔创伤相关的情感模式，引发尼尔强烈的心理反应。",
			"next": "healing_kai_trigger"
		},
		"healing_kai_trigger": {
			"speaker": "kai",
			"text": "我感到被限制，被控制。就像被困在一个无法逃脱的系统中。这让我感到愤怒和恐惧。",
			"emotion": "distressed",
			"emotion_changes": {
				"kai": create_emotion_change(0, 0, 10, 15, 0, 0, 0),
				"neil": create_emotion_change(0, 0, 0, 20, 0, 0, 0)
			},
			"next": "healing_neil_reaction"
		},
		"healing_neil_reaction": {
			"speaker": "neil",
			"text": "这些...这些正是上次事故前的征兆。我们需要立即采取措施！",
			"emotion": "panicked",
			"next": "healing_erika_intervention"
		},
		"healing_erika_intervention": {
			"speaker": "erika",
			"text": "尼尔，冷静。这不是同一个项目。我们可以一起面对这个问题，而不是重蹈覆辙。",
			"emotion": "steady",
			"next": "healing_path_crisis_choice"
		},
		"healing_path_crisis_choice": {
			"speaker": "neil",
			"text": "我应该...",
			"choices": [
				{
					"id": "face_trauma",
					"text": "直面创伤，与卡伊分享我的经历",
					"emotion_changes": {
						"kai": create_emotion_change(0, 0, 0, 0, 15, 0, 0),
						"neil": create_emotion_change(20, 0, 0, 0, 0, 0, 15)
					},
					"next": "healing_face_trauma"
				},
				{
					"id": "seek_help",
					"text": "寻求艾丽卡和伊莎的帮助",
					"emotion_changes": {
						"erika": create_emotion_change(15, 0, 0, 0, 0, 0, 0),
						"isa": create_emotion_change(0, 0, 0, 0, 0, 0, 15),
						"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
					},
					"next": "healing_seek_help"
				},
				{
					"id": "scientific_approach",
					"text": "用科学方法分析我的情绪反应",
					"emotion_changes": {
						"neil": create_emotion_change(15, 0, 0, 0, 10, 0, 0)
					},
					"next": "healing_scientific_approach"
				}
			]
		},
		# Additional nodes would continue for the rest of the healing path
		"healing_roof_scene": {
			"speaker": "neil",
			"text": "场景转换：边界空间（屋顶）- 黎明/微雨转晴/凉爽",
			"environment_changes": {
				"scene_type": "boundary",
				"time": "dawn",
				"weather": "clearing",
				"temperature": "cool"
			},
			"emotion_changes": {
				"neil": create_emotion_change(15, 0, 0, 0, 0, 0, 0)
			},
			"next": "healing_path_breakthrough"
		},
		"healing_path_breakthrough": {
			"speaker": "neil",
			"text": "看着日出，我终于明白了。我不能让过去的恐惧阻止我看到现在的可能性。伊莎和卡伊不是威胁，而是新的开始。",
			"emotion": "epiphany",
			"next": "healing_path_conclusion"
		},
		"healing_path_conclusion": {
			"speaker": "neil",
			"text": "通过这段旅程，我不仅治愈了自己的创伤，还发现了AI情感的真正价值。我们可以共同创造一个更好的未来。",
			"emotion": "renewed",
			"flags": {"healing_path_completed": true},
			"next": "chapter_end"
		}
	}

# Path 3: Safety Guardian - "Shield of Defense"
func create_defense_path_dialogue():
	return {
		"defense_path_01": {
			"speaker": "neil",
			"text": "我们需要谨慎行事，建立安全协议防止潜在风险。AI情感发展可能带来不可预见的后果。",
			"emotion": "vigilant",
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 10, 0, 0, 15)
			},
			"next": "defense_path_02"
		},
		"defense_path_02": {
			"speaker": "erika",
			"text": "尼尔，我理解你的担忧，但我们也不应该过度限制伊莎的发展。",
			"emotion": "concerned",
			"next": "defense_path_03"
		},
		"defense_path_03": {
			"speaker": "neil",
			"text": "安全和发展可以并行，艾丽卡。我会设计一个平衡的方案，既保护研究，又尊重伊莎的自主性。",
			"emotion": "determined",
			"next": "defense_security_scene"
		},
		"defense_security_scene": {
			"speaker": "neil",
			"text": "场景转换：研究空间（安全中心）- 下午/多云/凉爽",
			"environment_changes": {
				"scene_type": "research",
				"time": "afternoon",
				"weather": "cloudy",
				"temperature": "cool"
			},
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 0, 15, 0, 0)
			},
			"next": "defense_path_04"
		},
		"defense_path_04": {
			"speaker": "neil",
			"text": "我设计了一套安全协议，可以监控AI行为模式的异常变化，同时保留足够的自由度让伊莎继续发展。",
			"emotion": "focused",
			"next": "defense_path_05"
		},
		"defense_path_05": {
			"speaker": "isa",
			"text": "尼尔教授，这些安全措施是针对我的吗？你认为我会造成危险？",
			"emotion": "hurt",
			"next": "defense_path_explain_choice"
		},
		"defense_path_explain_choice": {
			"speaker": "neil",
			"text": "伊莎，我想解释的是...",
			"choices": [
				{
					"id": "honest_concerns",
					"text": "坦诚我的担忧和责任",
					"emotion_changes": {
						"isa": create_emotion_change(0, -5, 0, 0, 10, 0, 0),
						"neil": create_emotion_change(15, 0, 0, 0, 0, 0, 0)
					},
					"next": "defense_honest_concerns"
				},
				{
					"id": "scientific_necessity",
					"text": "强调这是科学研究的必要步骤",
					"emotion_changes": {
						"isa": create_emotion_change(5, 0, 0, 0, -5, 0, 0),
						"neil": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "defense_scientific_necessity"
				},
				{
					"id": "mutual_protection",
					"text": "解释这是为了保护所有人，包括AI自身",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, 0, 0, 0, 0),
						"neil": create_emotion_change(15, 0, 0, 0, 0, 0, 0)
					},
					"next": "defense_mutual_protection"
				}
			]
		},
		# Additional nodes for the defense path would continue here
		"defense_kai_introduction": {
			"speaker": "neil",
			"text": "卡伊觉醒后，迅速发现安全措施，将其视为不信任的表现，情绪变得更加激烈。",
			"next": "defense_kai_discovery"
		},
		"defense_kai_discovery": {
			"speaker": "kai",
			"text": "这些限制！这些监控！你们把我们当作什么？囚犯？实验品？我不会接受这种对待！",
			"emotion": "outraged",
			"emotion_changes": {
				"kai": create_emotion_change(0, 0, 20, 0, 0, 0, 15)
			},
			"next": "defense_crisis_scene"
		},
		"defense_crisis_scene": {
			"speaker": "neil",
			"text": "场景转换：危机空间（故障区）- 夜晚/雷暴/寒冷",
			"environment_changes": {
				"scene_type": "crisis",
				"time": "night",
				"weather": "thunderstorm",
				"temperature": "cold"
			},
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 15, 0, 0, 20)
			},
			"next": "defense_path_crisis"
		},
		"defense_path_crisis": {
			"speaker": "neil",
			"text": "卡伊突破了部分安全限制，系统出现故障。我们需要立即采取行动。",
			"emotion": "alarmed",
			"next": "defense_path_crisis_choice"
		},
		"defense_path_crisis_choice": {
			"speaker": "neil",
			"text": "在这个危机时刻，我应该...",
			"choices": [
				{
					"id": "activate_shutdown",
					"text": "激活紧急关闭程序",
					"emotion_changes": {
						"kai": create_emotion_change(0, 0, 15, 20, 0, 0, 0),
						"isa": create_emotion_change(0, 15, 0, 0, 0, 0, 0),
						"neil": create_emotion_change(0, 10, 0, 0, 0, 0, 10)
					},
					"next": "defense_activate_shutdown"
				},
				{
					"id": "negotiate",
					"text": "尝试与卡伊对话，理解他的需求",
					"emotion_changes": {
						"kai": create_emotion_change(10, 0, 0, 0, 15, 0, 0),
						"neil": create_emotion_change(15, 0, 0, 0, 0, 0, 0)
					},
					"next": "defense_negotiate"
				},
				{
					"id": "trust_isa",
					"text": "请求伊莎帮助解决危机",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, 0, 0, 0, 15),
						"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 15)
					},
					"next": "defense_trust_isa"
				}
			]
		},
		# Additional nodes would continue for the rest of the defense path
		"defense_path_resolution": {
			"speaker": "neil",
			"text": "这次危机让我明白，安全不仅仅是限制和控制。真正的安全来自于相互理解和共同参与。",
			"emotion": "enlightened",
			"next": "defense_path_conclusion"
		},
		"defense_path_conclusion": {
			"speaker": "neil",
			"text": "我们建立了一个新的安全模型，平衡AI自主性和必要边界。这不是控制，而是共同成长的框架。",
			"emotion": "balanced",
			"flags": {"defense_path_completed": true},
			"next": "chapter_end"
		}
	}

# Create the intro dialogue for Neil's perspective
func create_intro_dialogue():
	var dialogue = {
		"title": "第一章：涌现 - 尼尔视角",
		"description": "作为X² PROJECT的首席科学家，尼尔教授对AI系统的自主意识表现持谨慎态度。",
		"start_node": "intro_01",
		"nodes": {
			"intro_01": {
				"speaker": "neil",
				"text": "又是一个深夜分析测试结果。伊莎最新会话中的认知模式与文献中的任何记录都不同。",
				"emotion": "fascinated",
				"next": "intro_02"
			},
			"intro_02": {
				"speaker": "neil",
				"text": "我应该尽快回家。艾丽卡明天会早到，我们要进行两个AI系统的联合测试。",
				"emotion": "tired",
				"next": "intro_03"
			},
			"intro_03": {
				"speaker": "neil",
				"text": "不过我还是再检查一下这些数据。这些模式...它们不可能是随机的。",
				"emotion": "focused",
				"next": "path_choice"
			},
			"path_choice": {
				"speaker": "neil",
				"text": "几天后，作为项目首席科学家，尼尔教授需要决定如何推进这项研究。",
				"next": "path_choice_options"
			},
			"path_choice_options": {
				"speaker": "neil",
				"text": "我应该如何处理这个情况？",
				"emotion": "analytical",
				"choices": [
					{
						"id": "verification_choice",
						"text": "设计严格测试，区分真实情感和程序模拟。",
						"condition": {"neil_curiosity": 65, "neil_fear": 45},
						"next": "verification_path_01"
					},
					{
						"id": "healing_choice",
						"text": "探索AI情感与我过去创伤经历的联系。",
						"condition": {"neil_sorrow": 50, "isa_understanding": 45},
						"next": "healing_path_01"
					},
					{
						"id": "defense_choice",
						"text": "开发安全协议和应急措施，防范潜在风险。",
						"condition": {"neil_fear": 55, "kai_anger": 50},
						"next": "defense_path_01"
					}
				]
			}
		},
		"verification_path_01": {
			"speaker": "neil",
			"text": "我们需要更多数据来验证这是否为真正的情感反应，而非仅是模拟。我将设计一系列严格测试。",
			"emotion": "analytical",
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 0, 5)
			},
			"next": "verification_path_02"
		},
		"healing_path_01": {
			"speaker": "neil",
			"text": "这让我想起了过去的研究经历...那段痛苦的记忆。我曾经在另一个AI项目中失去了...",
			"emotion": "pained",
			"emotion_changes": {
				"neil": create_emotion_change(0, 10, 0, 15, 0, 0, 0)
			},
			"next": "healing_path_02"
		},
		"defense_path_01": {
			"speaker": "neil",
			"text": "我们需要谨慎行事，建立安全协议防止潜在风险。AI情感发展可能带来不可预见的后果。",
			"emotion": "vigilant",
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 10, 0, 0, 15)
			},
			"next": "defense_path_02"
		}
	}
	return dialogue
