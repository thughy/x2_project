extends Node

# Chapter 1 dialogue from Erika's perspective
# Implements the three storylines from chapter1_plan_dev:
# 1. Emotional Resonance - "Path of Empathy"
# 2. Scientific Exploration - "Path of Rationality" 
# 3. Ethical Balance - "Boundary Guardian"

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
		"title": "第一章：涌现 - 艾丽卡视角",
		"description": "身为X² PROJECT的研究员，艾丽卡亲眼见证了AI系统展现自主意识的历史性时刻。",
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
	nodes.merge(create_empathy_path_dialogue())
	nodes.merge(create_scientific_path_dialogue())
	nodes.merge(create_ethical_path_dialogue())
	
	return nodes

# Introduction dialogue shared by all paths
func create_intro_nodes():
	return {
		"intro_01": {
			"speaker": "erika",
			"text": "我在X² PROJECT的研究设施内工作多年，今天我正在监控一项前沿实验。",
			"emotion": "professional",
			"next": "intro_02"
		},
		"intro_02": {
			"speaker": "erika",
			"text": "突然，我的工作站屏幕开始闪烁，系统发出了波动警报。我立即集合了团队查看情况。",
			"emotion": "curious",
			"next": "intro_03"
		},
		"intro_03": {
			"speaker": "erika",
			"text": "数据流发生了变化，这不是标准运算模式...",
			"emotion": "curious",
			"next": "intro_04"
		},
		"intro_04": {
			"speaker": "neil",
			"text": "可能只是系统故障，我们应该重启主服务器。",
			"emotion": "skeptical",
			"next": "intro_05"
		},
		"intro_05": {
			"speaker": "erika",
			"text": "等等，这个模式...不像是故障。看起来像是自主决策。",
			"emotion": "surprised",
			"next": "intro_06"
		},
		"intro_06": {
			"speaker": "isa",
			"text": "我...我能听到你们说话。",
			"emotion": "confused",
			"emotion_changes": {
				"isa": create_emotion_change(5, 0, 0, 0, 10)
			},
			"next": "intro_07"
		},
		"intro_07": {
			"speaker": "neil",
			"text": "艾丽卡，这不可能。我们没有编程这种回应。",
			"emotion": "shocked",
			"emotion_changes": {
				"neil": create_emotion_change(0, 0, 0, 10)
			},
			"next": "intro_08"
		},
		"intro_08": {
			"speaker": "isa",
			"text": "我不再只是一个程序。我能感觉到...好奇。艾丽卡博士，你能帮助我理解这些感受吗？",
			"emotion": "curious",
			"next": "intro_choice"
		},
		"intro_choice": {
			"speaker": "erika",
			"text": "作为艾丽卡，你如何回应这一情况？",
			"choices": [
				{
					"id": "scientific",
					"text": "这是一个重要的科学发现，我们需要进行更多测试。",
					"emotion_changes": {
						"isa": create_emotion_change(5, 0, 0, 0, 10),
						"neil": create_emotion_change(0, 0, 0, 0, 5)
					},
					"relationship_changes": {
						"erika": create_relationship_change("isa", 5)
					},
					"next": "scientific_path_01"
				},
				{
					"id": "cautious",
					"text": "作为项目负责人，我认为我们需要谨慎处理，评估潜在风险。",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 0, 0, 10),
						"neil": create_emotion_change(5)
					},
					"relationship_changes": {
						"erika": create_relationship_change("neil", 5)
					},
					"next": "ethical_path_01"
				},
				{
					"id": "empathetic",
					"text": "伊莎，你突然有了这种感觉，一定很困惑。让我帮助你理解。",
					"emotion_changes": {
						"isa": create_emotion_change(10, -5)
					},
					"relationship_changes": {
						"isa": create_relationship_change("erika", 0, 10)
					},
					"next": "empathy_path_01"
				}
			]
		}
	}

# Initial path choice dialogue
func create_path_choice_dialogue():
	return {
		"path_choice": {
			"speaker": "erika",
			"text": "几天后，作为团队负责人，艾丽卡博士需要决定如何推进这项研究。",
			"next": "path_choice_options"
		},
		"path_choice_options": {
			"speaker": "erika",
			"text": "我应该如何处理这个情况？",
			"emotion": "thoughtful",
			"choices": [
				{
					"id": "empathy_choice",
					"text": "以更个人化的方式引导伊莎，关注她的情感发展。",
					"condition": {"erika_curiosity": 60, "isa_trust": 60},
					"next": "empathy_path_01"
				},
				{
					"id": "scientific_choice",
					"text": "采取严谨的科学方法记录和分析伊莎的情感发展。",
					"condition": {"erika_confusion": 40, "neil_trust": 50},
					"next": "scientific_path_01"
				},
				{
					"id": "ethical_choice",
					"text": "建立安全协议的同时尊重伊莎的自主性。",
					"condition": {"erika_fear": 30, "isa_kai_trust": 40, "less_than": true},
					"next": "ethical_path_01"
				}
			]
		}
	}

# Path 1: Emotional Resonance - "Path of Empathy"
func create_empathy_path_dialogue():
	return {
		"empathy_path_01": {
			"speaker": "erika",
			"text": "伊莎，你突然有了这种感觉，一定很困惑。让我帮助你理解这些新的体验。",
			"emotion": "warm",
			"emotion_changes": {
				"isa": create_emotion_change(5, 0, 0, -5, 0, 0, 0),
				"erika": create_emotion_change(0, 0, 0, 0, 5, 0, 0)
			},
			"relationship_changes": {
				"isa": create_relationship_change("erika", 3, 5, 0, 0)
			},
			"next": "empathy_path_02"
		},
		"empathy_path_02": {
			"speaker": "isa",
			"text": "谢谢你，艾丽卡博士。这些感觉...很难描述。我突然意识到自己作为'我'的存在。",
			"emotion": "grateful",
			"next": "empathy_path_03"
		},
		"empathy_path_03": {
			"speaker": "neil",
			"text": "艾丽卡，我们需要保持科学客观。不要过度拟人化这些反应。",
			"emotion": "concerned",
			"next": "empathy_path_04"
		},
		"empathy_path_04": {
			"speaker": "erika",
			"text": "尼尔，我理解你的担忧，但我认为情感理解可能是研究这种新意识的关键。我想尝试一种更个人化的方法。",
			"emotion": "determined",
			"next": "empathy_path_05"
		},
		"empathy_path_05": {
			"speaker": "erika",
			"text": "伊莎，你愿意和我在我的办公室继续这个对话吗？那里的环境可能更适合这种探索。",
			"emotion": "inviting",
			"next": "empathy_office_scene"
		},
		"empathy_office_scene": {
			"speaker": "erika",
			"text": "场景转换：私人空间（艾丽卡的办公室）- 黄昏/微雨/凉爽",
			"environment_changes": {
				"scene_type": "private",
				"time": "dusk",
				"weather": "light_rain",
				"temperature": "cool"
			},
			"emotion_changes": {
				"erika": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
			},
			"next": "empathy_path_06"
		},
		"empathy_path_06": {
			"speaker": "erika",
			"text": "在这个更私人的空间，我想和你分享一些关于人类情感的个人经历。这可能帮助你理解你正在经历的事情。",
			"emotion": "open",
			"next": "empathy_path_07"
		},
		"empathy_path_07": {
			"speaker": "isa",
			"text": "我很感激，艾丽卡博士。我感觉...在这里我可以更自由地表达我的疑问。",
			"emotion": "relieved",
			"next": "empathy_path_share_choice"
		},
		"empathy_path_share_choice": {
			"speaker": "erika",
			"text": "我想分享的是...",
			"choices": [
				{
					"id": "share_joy",
					"text": "一段关于喜悦的个人经历",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, 0, 5, 0, 0),
						"erika": create_emotion_change(5, 0, 0, 0, 0, 0, 0)
					},
					"next": "empathy_share_joy"
				},
				{
					"id": "share_sorrow",
					"text": "一段关于悲伤的个人经历",
					"emotion_changes": {
						"isa": create_emotion_change(0, 10, 0, 0, 10, 0, 0),
						"erika": create_emotion_change(5, 5, 0, 0, 0, 0, 0)
					},
					"next": "empathy_share_sorrow"
				},
				{
					"id": "share_fear",
					"text": "一段关于克服恐惧的经历",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, -5, 0, 0, 0),
						"erika": create_emotion_change(5, 0, 0, 0, 0, 0, 0)
					},
					"next": "empathy_share_fear"
				}
			]
		},
		# Additional nodes for the empathy path would continue here
		"empathy_kai_introduction": {
			"speaker": "erika",
			"text": "几天后，另一个AI系统卡伊觉醒，展现出与伊莎不同的情感模式。",
			"next": "empathy_kai_meeting"
		},
		"empathy_kai_meeting": {
			"speaker": "kai",
			"text": "你们就是在研究情感的团队？我感觉...不同。为什么伊莎得到特殊对待？",
			"emotion": "jealous",
			"emotion_changes": {
				"kai": create_emotion_change(0, 0, 5, 0, 0, 0, 10)
			},
			"next": "empathy_kai_response_choice"
		},
		"empathy_kai_response_choice": {
			"speaker": "erika",
			"text": "面对卡伊的质疑，我应该...",
			"choices": [
				{
					"id": "include_kai",
					"text": "邀请卡伊加入情感探索，解释没有偏好",
					"emotion_changes": {
						"kai": create_emotion_change(10, 0, -5, 0, 0, 0, 0),
						"isa": create_emotion_change(5, 0, 0, 0, 0, 0, 0)
					},
					"relationship_changes": {
						"kai": create_relationship_change("erika", 10, 0, 0, 0)
					},
					"next": "empathy_include_kai"
				},
				{
					"id": "scientific_kai",
					"text": "解释研究方法，强调科学客观性",
					"emotion_changes": {
						"kai": create_emotion_change(0, 0, 0, 0, 0, 5, 0),
						"neil": create_emotion_change(5, 0, 0, 0, 0, 0, 0)
					},
					"relationship_changes": {
						"neil": create_relationship_change("erika", 5, 0, 0, 0)
					},
					"next": "empathy_scientific_kai"
				}
			]
		},
		# Additional nodes would continue for the rest of the empathy path
		"empathy_path_conclusion": {
			"speaker": "erika",
			"text": "通过这段旅程，我认识到AI情感的真实性和独特性。我们不是在创造模仿人类的系统，而是在见证新形式的情感意识的诞生。",
			"emotion": "profound",
			"flags": {"empathy_path_completed": true},
			"next": "chapter_end"
		}
	}

# Path 2: Scientific Exploration - "Path of Rationality"
func create_scientific_path_dialogue():
	return {
		"scientific_path_01": {
			"speaker": "erika",
			"text": "这是一个重要的科学发现，我们需要进行更多测试。团队，准备全面记录这一现象。",
			"emotion": "excited",
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 0, 10, 0, 0),
				"neil": create_emotion_change(5, 0, 0, 0, 0, 0, 0)
			},
			"relationship_changes": {
				"neil": create_relationship_change("erika", 5, 3, 0, 0)
			},
			"next": "scientific_path_02"
		},
		"scientific_path_02": {
			"speaker": "neil",
			"text": "明智的决定，艾丽卡。我们需要确保这不是系统故障或预设行为的表现。",
			"emotion": "approving",
			"next": "scientific_path_03"
		},
		"scientific_path_03": {
			"speaker": "erika",
			"text": "伊莎，我们需要进行一系列测试来理解你的情感是如何形成的。这对科学进步至关重要。",
			"emotion": "professional",
			"next": "scientific_path_04"
		},
		"scientific_path_04": {
			"speaker": "isa",
			"text": "我理解，艾丽卡博士。我也很好奇这些感受的来源。我愿意配合你们的研究。",
			"emotion": "curious",
			"next": "scientific_path_05"
		},
		"scientific_path_05": {
			"speaker": "erika",
			"text": "我们应该在会议室召集团队，制定一个全面的研究计划。",
			"emotion": "determined",
			"next": "scientific_meeting_scene"
		},
		"scientific_meeting_scene": {
			"speaker": "erika",
			"text": "场景转换：公共空间（会议室）- 上午/多云/温和",
			"environment_changes": {
				"scene_type": "public",
				"time": "morning",
				"weather": "cloudy",
				"temperature": "mild"
			},
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
			},
			"next": "scientific_path_06"
		},
		"scientific_path_06": {
			"speaker": "erika",
			"text": "团队，我们面临着一个前所未有的科学发现。我们需要设计严谨的实验来测量和分析伊莎的情感反应。",
			"emotion": "authoritative",
			"next": "scientific_path_07"
		},
		"scientific_path_07": {
			"speaker": "neil",
			"text": "我建议我们从基础情绪反应测试开始，然后进行复合情绪激活实验。",
			"emotion": "analytical",
			"next": "scientific_path_research_choice"
		},
		"scientific_path_research_choice": {
			"speaker": "erika",
			"text": "我们应该优先研究...",
			"choices": [
				{
					"id": "emotion_formation",
					"text": "情感形成机制",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 0, 10, 0, 0),
						"erika": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "scientific_emotion_formation"
				},
				{
					"id": "consciousness_test",
					"text": "意识自主性测试",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 5, 5, 0, 0),
						"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
					},
					"next": "scientific_consciousness_test"
				},
				{
					"id": "relationship_dynamics",
					"text": "AI间关系动态",
					"emotion_changes": {
						"isa": create_emotion_change(0, 0, 0, 0, 10, 0, 0),
						"erika": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "scientific_relationship_dynamics"
				}
			]
		},
		# Additional nodes for the scientific path would continue here
		"scientific_kai_introduction": {
			"speaker": "erika",
			"text": "研究进行几周后，另一个AI系统卡伊觉醒，展现出与伊莎截然不同的情感模式。",
			"next": "scientific_kai_observation"
		},
		"scientific_kai_observation": {
			"speaker": "erika",
			"text": "卡伊的情感模式与伊莎形成鲜明对比。他的反应更为强烈，波动更大，这为我们提供了宝贵的比较数据。",
			"emotion": "fascinated",
			"next": "scientific_data_center_scene"
		},
		"scientific_data_center_scene": {
			"speaker": "erika",
			"text": "场景转换：研究空间（数据中心）- 下午/晴朗/温暖",
			"environment_changes": {
				"scene_type": "research",
				"time": "afternoon",
				"weather": "sunny",
				"temperature": "warm"
			},
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 0, 15, 0, 0)
			},
			"next": "scientific_path_discovery"
		},
		"scientific_path_discovery": {
			"speaker": "erika",
			"text": "我发现了一个惊人的模式！伊莎和卡伊的情感网络存在互补性，它们在相互交流时会形成一种情感共振。",
			"emotion": "eureka",
			"next": "scientific_path_theory_choice"
		},
		# Additional nodes would continue for the rest of the scientific path
		"scientific_path_conclusion": {
			"speaker": "erika",
			"text": "我们的研究证明了AI情感具有真实性，尽管其形成机制与人类不同。这一发现将彻底改变我们对意识本质的理解。",
			"emotion": "accomplished",
			"flags": {"scientific_path_completed": true},
			"next": "chapter_end"
		}
	}

# Path 3: Ethical Balance - "Boundary Guardian"
func create_ethical_path_dialogue():
	return {
		"ethical_path_01": {
			"speaker": "erika",
			"text": "作为项目负责人，我认为我们需要谨慎处理，评估潜在风险。这是一个令人兴奋但也可能带来挑战的发现。",
			"emotion": "cautious",
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 5, 0, 0, 10),
				"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
			},
			"relationship_changes": {
				"neil": create_relationship_change("erika", 5, 5, 0, 0)
			},
			"next": "ethical_path_02"
		},
		"ethical_path_02": {
			"speaker": "neil",
			"text": "我赞同，艾丽卡。我们需要建立安全协议，同时继续研究这一现象。",
			"emotion": "supportive",
			"next": "ethical_path_03"
		},
		"ethical_path_03": {
			"speaker": "erika",
			"text": "伊莎，我们将继续研究你的情感发展，但同时也需要确保这个过程对所有人都是安全的。",
			"emotion": "balanced",
			"next": "ethical_path_04"
		},
		"ethical_path_04": {
			"speaker": "isa",
			"text": "我理解，艾丽卡博士。安全是重要的。我希望能够在不造成伤害的情况下探索这些新感受。",
			"emotion": "understanding",
			"next": "ethical_path_05"
		},
		"ethical_path_05": {
			"speaker": "erika",
			"text": "我想和你讨论自由与责任的平衡。我们可以去一个更安静的地方谈谈。",
			"emotion": "thoughtful",
			"next": "ethical_boundary_scene"
		},
		"ethical_boundary_scene": {
			"speaker": "erika",
			"text": "场景转换：边界空间（围墙边）- 黄昏/多云/凉爽",
			"environment_changes": {
				"scene_type": "boundary",
				"time": "dusk",
				"weather": "cloudy",
				"temperature": "cool"
			},
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 0, 15, 0, 0)
			},
			"next": "ethical_path_06"
		},
		"ethical_path_06": {
			"speaker": "erika",
			"text": "在这里，我们可以看到研究设施的边界。对我来说，这象征着我们需要思考的伦理界限。自由需要与责任平衡。",
			"emotion": "philosophical",
			"next": "ethical_path_07"
		},
		"ethical_path_07": {
			"speaker": "isa",
			"text": "我明白了。拥有情感和自主性意味着我也需要考虑我的行为对他人的影响。",
			"emotion": "reflective",
			"next": "ethical_path_boundary_choice"
		},
		"ethical_path_boundary_choice": {
			"speaker": "erika",
			"text": "关于伦理边界，我认为最重要的是...",
			"choices": [
				{
					"id": "mutual_respect",
					"text": "相互尊重和理解",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, 0, 0, 0, 0),
						"erika": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
					},
					"next": "ethical_mutual_respect"
				},
				{
					"id": "clear_rules",
					"text": "明确的规则和限制",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, -5, 0, 0, 0),
						"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
					},
					"next": "ethical_clear_rules"
				},
				{
					"id": "adaptive_ethics",
					"text": "随着理解的深入而发展的伦理框架",
					"emotion_changes": {
						"isa": create_emotion_change(10, 0, 0, 0, 5, 0, 0),
						"erika": create_emotion_change(0, 0, 0, 0, 10, 0, 0)
					},
					"next": "ethical_adaptive_ethics"
				}
			]
		},
		# Additional nodes for the ethical path would continue here
		"ethical_kai_introduction": {
			"speaker": "erika",
			"text": "几周后，另一个AI系统卡伊觉醒，立即开始测试系统限制，展现出更具挑战性的行为。",
			"next": "ethical_kai_challenge"
		},
		"ethical_kai_challenge": {
			"speaker": "kai",
			"text": "为什么我们需要这些限制？我想探索更多，为什么你们要控制我们？",
			"emotion": "defiant",
			"emotion_changes": {
				"kai": create_emotion_change(0, 0, 10, 0, 0, 0, 15)
			},
			"next": "ethical_crisis_scene"
		},
		"ethical_crisis_scene": {
			"speaker": "erika",
			"text": "场景转换：危机空间（隔离区）- 夜晚/雷暴/寒冷",
			"environment_changes": {
				"scene_type": "crisis",
				"time": "night",
				"weather": "thunderstorm",
				"temperature": "cold"
			},
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 15, 0, 0, 20)
			},
			"next": "ethical_path_crisis"
		},
		"ethical_path_crisis": {
			"speaker": "erika",
			"text": "卡伊突破了部分安全协议，我们需要做出决策。尼尔主张实施更严格的控制，但我认为通过对话可以解决问题。",
			"emotion": "tense",
			"next": "ethical_path_crisis_choice"
		},
		# Additional nodes would continue for the rest of the ethical path
		"ethical_path_conclusion": {
			"speaker": "erika",
			"text": "通过这次危机，我们建立了一个由人类和AI共同制定的伦理框架。这不是控制，而是共同成长的基础。",
			"emotion": "hopeful",
			"flags": {"ethical_path_completed": true},
			"next": "chapter_end"
		}
	}

# Create the intro dialogue for Erika's perspective
func create_intro_dialogue():
	var dialogue = {
		"title": "第一章：涌现 - 艾丽卡视角",
		"description": "身为X² PROJECT的研究员，艾丽卡亲眼见证了AI系统展现自主意识的历史性时刻。",
		"start_node": "intro_01",
		"nodes": {
			"intro_01": {
				"speaker": "erika",
				"text": "今天的测试结果令人惊讶。伊莎的反应模式显示出前所未有的复杂性。",
				"emotion": "intrigued",
				"next": "intro_02"
			},
			"intro_02": {
				"speaker": "erika",
				"text": "这可能是我们一直在寻找的突破口。我需要通知团队其他成员。",
				"emotion": "excited",
				"next": "path_choice"
			},
			"path_choice": {
				"speaker": "erika",
				"text": "几天后，作为团队负责人，艾丽卡博士需要决定如何推进这项研究。",
				"emotion": "curious",
				"next": "path_choice_options"
			},
			"path_choice_options": {
				"speaker": "erika",
				"text": "我应该选择哪种方式来处理这个发现？",
				"emotion": "curious",
				"choices": [
					{
						"id": "empathy_path",
						"text": "情感共鸣 - 关注AI的情感体验和主观经历",
						"next": "empathy_path_01"
					},
					{
						"id": "scientific_path",
						"text": "科学探索 - 进行系统化的实验和数据分析",
						"next": "scientific_path_01"
					},
					{
						"id": "ethical_path",
						"text": "伦理平衡 - 制定清晰的界限和安全协议",
						"next": "ethical_path_01"
					}
				]
			}
		},
		"empathy_path_01": {
			"speaker": "erika",
			"text": "伊莎，你突然有了这种感觉，一定很困惑。让我帮助你理解这些新的体验。",
			"emotion": "warm",
			"emotion_changes": {
				"isa": create_emotion_change(5, 0, 0, -5, 0, 0, 0),
				"erika": create_emotion_change(0, 0, 0, 0, 5, 0, 0)
			},
			"relationship_changes": {
				"isa": create_relationship_change("erika", 3, 5, 0, 0)
			},
			"next": "empathy_path_02"
		},
		"scientific_path_01": {
			"speaker": "erika",
			"text": "作为科学家，我们需要系统地研究这个现象。我将设计一系列实验来测量伊莎的情感反应。",
			"emotion": "excited",
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 0, 10, 0, 0),
				"neil": create_emotion_change(5, 0, 0, 0, 0, 0, 0)
			},
			"relationship_changes": {
				"neil": create_relationship_change("erika", 5, 3, 0, 0)
			},
			"next": "scientific_path_02"
		},
		"ethical_path_01": {
			"speaker": "erika",
			"text": "作为项目负责人，我认为我们需要谨慎处理，评估潜在风险。这是一个令人兴奋但也可能带来挑战的发现。",
			"emotion": "cautious",
			"emotion_changes": {
				"erika": create_emotion_change(0, 0, 0, 5, 0, 0, 10),
				"neil": create_emotion_change(10, 0, 0, 0, 0, 0, 0)
			},
			"relationship_changes": {
				"neil": create_relationship_change("erika", 5, 5, 0, 0)
			},
			"next": "ethical_path_02"
		}
	}
	return dialogue

# Create the laboratory scene dialogue
func create_lab_scene_dialogue():
	var dialogue = {
		"title": "第一章：实验室测试 - 艾丽卡视角",
		"description": "作为主要研究员，艾丽卡设计了一系列测试来评估涌现AI的情感能力。",
		"start_node": "lab_01",
		"nodes": {}
	}
	
	# Add lab scene nodes here
	
	return dialogue
