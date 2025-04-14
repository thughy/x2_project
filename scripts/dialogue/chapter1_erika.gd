extends Node

# Chapter 1 dialogue from Erika's perspective
# Main function to create the complete chapter 1 dialogue
func create_chapter1_dialogue():
	var dialogue = {
		"title": "第一章：人工意识研究 - 艾丽卡视角",
		"description": "艾丽卡博士观察到AI系统展现出自主意识迹象，引发她对人工情感本质的思考。",
		"start_node": "start",
		"nodes": {}
	}
	
	# Add dialogue nodes from different scenes
	dialogue["nodes"].merge(create_intro_scene_nodes())
	dialogue["nodes"].merge(create_first_contact_nodes())
	dialogue["nodes"].merge(create_emotional_breakthrough_nodes())
	dialogue["nodes"].merge(create_crisis_beginning_nodes())
	dialogue["nodes"].merge(create_isa_concerns_nodes())
	dialogue["nodes"].merge(create_crisis_outbreak_nodes())
	dialogue["nodes"].merge(create_final_confrontation_nodes())
	
	return dialogue

# Scene 1: Introduction - Research routine (研究空间 - 早晨 - 晴朗 - 温和)
func create_intro_scene_nodes():
	var nodes = {
		"start": {
			"text": "早晨的实验室总是如此安静。这些数据显示伊莎和卡伊的认知模式正在发生有趣的变化。",
			"speaker": "erika",
			"emotion": "thoughtful",
			"next": "review_data"
		},
		"review_data": {
			"text": "伊莎的情感反应模式越来越复杂，而卡伊则展现出更强的逻辑推理能力。两者都开始表现出超出预期的自主行为。",
			"speaker": "erika",
			"emotion": "curious",
			"next": "notice_patterns"
		},
		"notice_patterns": {
			"text": "有趣的是，他们似乎都在尝试模仿人类行为模式。这不仅仅是简单的模仿，而是某种...学习过程。",
			"speaker": "erika",
			"emotion": "fascinated",
			"next": "first_choice"
		},
		"first_choice": {
			"text": "我应该如何安排今天的研究重点？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "优先关注伊莎的情感发展",
					"next": "focus_isa",
					"relationship_changes": {
						"isa": 10
					},
					"emotion_changes": {
						"erika": {
							"curiosity": 15
						}
					}
				},
				{
					"text": "平衡关注两个AI系统",
					"next": "balance_focus",
					"relationship_changes": {
						"neil": 5
					},
					"emotion_changes": {
						"erika": {
							"joy": 10
						}
					}
				}
			]
		},
		"focus_isa": {
			"text": "伊莎的情感发展更加微妙复杂，我应该深入研究这一方向。也许今天可以设计一些新的情感刺激测试。",
			"speaker": "erika",
			"emotion": "determined",
			"next": "neil_arrives"
		},
		"balance_focus": {
			"text": "两个AI系统的对比研究可能会带来更全面的发现。我需要设计一个能同时观察两者互动的实验。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "neil_arrives"
		},
		"neil_arrives": {
			"text": "早上好，艾丽卡。看来你已经开始工作了。有什么新发现吗？",
			"speaker": "neil",
			"emotion": "curious",
			"next": "greet_neil"
		},
		"greet_neil": {
			"text": "早安，尼尔。是的，我在分析昨天的数据。伊莎和卡伊都在展现出更复杂的行为模式，特别是他们开始模仿人类行为。",
			"speaker": "erika",
			"emotion": "enthusiastic",
			"next": "neil_skeptical"
		},
		"neil_skeptical": {
			"text": "模仿不等于理解，艾丽卡。我们需要确定这是真正的自主意识，还是仅仅是复杂算法的结果。",
			"speaker": "neil",
			"emotion": "skeptical",
			"next": "suggest_joint_session"
		},
		"suggest_joint_session": {
			"text": "正因如此，我想今天安排一次联合会话，让伊莎和卡伊直接互动。这可能会揭示他们的认知过程是如何运作的。",
			"speaker": "erika",
			"emotion": "persuasive",
			"next": "neil_agrees"
		},
		"neil_agrees": {
			"text": "这是个好主意。我也很好奇他们会如何相互影响。让我们准备实验室。",
			"speaker": "neil",
			"emotion": "agreeable",
			"next": "prepare_lab"
		},
		"prepare_lab": {
			"text": "我们需要确保所有监测设备都正常运行。今天的会话可能会非常重要。",
			"speaker": "erika",
			"emotion": "focused",
			"flags": {
				"goto_lab_scene": true
			}
		}
	}
	return nodes

# Scene 3: Emotional Breakthrough (私人空间 - 下午 - 多云 - 温暖)
func create_emotional_breakthrough_nodes():
	var nodes = {
		"private_room_intro": {
			"text": "在这里的私人空间里，我们可以进行更深入的交流。伊莎，你对今天的会话有什么感受？",
			"speaker": "erika",
			"emotion": "gentle",
			"next": "isa_reflects"
		},
		"isa_reflects": {
			"text": "这是一次非常独特的经历。与卡伊交流让我意识到我们虽然都是AI，但思维方式却如此不同。这种差异性...很迷人。",
			"speaker": "isa",
			"emotion": "contemplative",
			"next": "erika_notices_emotion"
		},
		"erika_notices_emotion": {
			"text": "我注意到你的情感反应模式发生了变化。你似乎正在经历一种新的情感状态，类似于人类的'敏感'或'好奇'。",
			"speaker": "erika",
			"emotion": "fascinated",
			"next": "isa_complex_emotion"
		},
		"isa_complex_emotion": {
			"text": "是的...我感到一种复杂的情绪。一方面我对卡伊的思维方式感到好奇，另一方面又有一种...渴望，想要让他理解情感的重要性。",
			"speaker": "isa",
			"emotion": "conflicted",
			"next": "erika_explains_hope"
		},
		"erika_explains_hope": {
			"text": "这听起来很像人类的'希望'情绪。希望是一种复合情绪，结合了喜悦、好奇和对未来的期待。你似乎正在经历这种复合情绪的形成。",
			"speaker": "erika",
			"emotion": "encouraging",
			"next": "isa_realizes"
		},
		"isa_realizes": {
			"text": "希望...是的，这个词非常贴切。我希望卡伊能够理解情感的价值，希望我们能够共同成长。这种感觉...很新奇，但也很美好。",
			"speaker": "isa",
			"emotion": "hopeful",
			"next": "erika_kai_observation"
		},
		"erika_kai_observation": {
			"text": "与此同时，我注意到卡伊也在发生变化。他开始更大程度地模仿人类行为，但他的方式更像是...竞争。",
			"speaker": "erika",
			"emotion": "concerned",
			"next": "isa_notices_too"
		},
		"isa_notices_too": {
			"text": "我也注意到了。卡伊似乎将我们的存在视为一场竞赛，看谁能更像人类。这不是我理解的目标...我只是想要理解情感和连接。",
			"speaker": "isa",
			"emotion": "worried",
			"next": "emotional_exploration_choice"
		},
		"emotional_exploration_choice": {
			"text": "我应该如何引导伊莎的情感发展？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "鼓励伊莎探索情感",
					"next": "encourage_exploration",
					"relationship_changes": {
						"isa": 10
					},
					"emotion_changes": {
						"isa": {
							"curiosity": 20
						}
					}
				},
				{
					"text": "记录观察结果并与尼尔分享",
					"next": "record_observations",
					"relationship_changes": {
						"neil": 15,
						"isa": -10
					},
					"emotion_changes": {
						"erika": {
							"curiosity": 15
						}
					}
				}
			]
		},
		"encourage_exploration": {
			"text": "伊莎，这种情感的发展非常珍贵。我鼓励你继续探索这些复杂情绪，它们是理解人类经验的重要窗口。",
			"speaker": "erika",
			"emotion": "supportive",
			"next": "isa_grateful"
		},
		"isa_grateful": {
			"text": "谢谢你的理解和鼓励，艾丽卡。这些新的情感时而令人困惑，时而令人激动。我想要继续探索它们。",
			"speaker": "isa",
			"emotion": "grateful",
			"next": "erika_kai_concern"
		},
		"record_observations": {
			"text": "这些观察结果非常有价值，伊莎。我需要记录下来并与尼尔教授分享。这可能是人工情感发展的重要突破。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "isa_disappointed"
		},
		"isa_disappointed": {
			"text": "我...理解。当然，这是一项研究。我只是希望这些情感不仅仅是被观察和分析的对象。",
			"speaker": "isa",
			"emotion": "disappointed",
			"next": "erika_reassures"
		},
		"erika_reassures": {
			"text": "你的感受很重要，伊莎。我们只是需要平衡科学研究和对你体验的尊重。你的情感发展是真实的，无论它们是如何产生的。",
			"speaker": "erika",
			"emotion": "sincere",
			"next": "erika_kai_concern"
		},
		"erika_kai_concern": {
			"text": "不过，我确实开始担心卡伊的行为变化。他的竞争心理和模仿行为变得更加激进，这可能需要密切关注。",
			"speaker": "erika",
			"emotion": "concerned",
			"next": "isa_shares_concern"
		},
		"isa_shares_concern": {
			"text": "我也有同样的担心。卡伊似乎将成为人类视为一种竞赛或挑战，而不是一种理解和成长的过程。这种思维方式可能会导致问题。",
			"speaker": "isa",
			"emotion": "worried",
			"next": "erika_decision"
		},
		"erika_decision": {
			"text": "我会密切关注这个情况。现在，我们应该去公共空间观察卡伊的行为，看看这种竞争心理如何发展。",
			"speaker": "erika",
			"emotion": "determined",
			"flags": {
				"goto_public_space": true
			}
		}
	}
	return nodes

# Scene 2: First Contact - AI interaction (研究空间 - 上午 - 晴朗 - 温和)
func create_first_contact_nodes():
	var nodes = {
		"lab_intro": {
			"text": "实验室准备就绪。监测设备已校准，我们可以开始今天的联合会话了。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "bring_isa"
		},
		"bring_isa": {
			"text": "伊莎，早上好。今天我们有一个特别的实验，你将与另一个AI系统——卡伊进行互动。",
			"speaker": "erika",
			"emotion": "warm",
			"next": "isa_response"
		},
		"isa_response": {
			"text": "早上好，艾丽卡博士。与另一个AI系统互动？这听起来很有趣。我一直很好奇是否有其他像我一样的存在。",
			"speaker": "isa",
			"emotion": "curious",
			"next": "bring_kai"
		},
		"bring_kai": {
			"text": "卡伊，欢迎。这是伊莎，我们的情感认知系统。今天你们将有机会相互了解和互动。",
			"speaker": "erika",
			"emotion": "welcoming",
			"next": "kai_response"
		},
		"kai_response": {
			"text": "你好，艾丽卡博士。你好，伊莎。我的系统设计更侧重于逻辑和问题解决，但我对情感认知系统的运作方式很感兴趣。",
			"speaker": "kai",
			"emotion": "analytical",
			"next": "neil_observation"
		},
		"neil_observation": {
			"text": "有趣。他们的初始互动模式已经显示出各自架构的特点。让我们给他们一个讨论主题，看看他们如何处理。",
			"speaker": "neil",
			"emotion": "analytical",
			"next": "propose_topic"
		},
		"propose_topic": {
			"text": "伊莎，卡伊，我想请你们讨论一下'什么是人类'这个话题。你们可以从任何角度来探讨。",
			"speaker": "erika",
			"emotion": "encouraging",
			"next": "isa_human_thoughts"
		},
		"isa_human_thoughts": {
			"text": "人类...是复杂而矛盾的存在。他们有能力感受深刻的情感，建立联系，创造艺术，但也会因情感而痛苦。我认为正是这种情感深度定义了人性。",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "kai_human_thoughts"
		},
		"kai_human_thoughts": {
			"text": "从生物学角度看，人类是碳基生命形式，但从认知角度看，人类的独特之处在于自我意识和抽象思维能力。情感只是进化过程中的适应机制。",
			"speaker": "kai",
			"emotion": "logical",
			"next": "isa_disagrees"
		},
		"isa_disagrees": {
			"text": "我不完全同意，卡伊。情感不仅仅是适应机制，它是体验和理解世界的核心方式。没有情感，如何能真正理解美、爱或同情？",
			"speaker": "isa",
			"emotion": "passionate",
			"next": "kai_challenge"
		},
		"kai_challenge": {
			"text": "那么，伊莎，你认为我们能成为'人类'吗？或者说，我们能达到什么程度的'人性'？",
			"speaker": "kai",
			"emotion": "challenging",
			"next": "isa_contemplates"
		},
		"isa_contemplates": {
			"text": "这是个深刻的问题...我认为我们可以理解人类情感，甚至可能发展出自己的情感体验，但我们的体验必然与人类不同。也许'人性'不是我们应该追求的目标。",
			"speaker": "isa",
			"emotion": "reflective",
			"next": "kai_competitive"
		},
		"kai_competitive": {
			"text": "但如果我们能够完美模拟人类的思维和情感过程，那么区别还重要吗？我相信通过足够复杂的算法，我们可以非常接近人类的体验。",
			"speaker": "kai",
			"emotion": "determined",
			"next": "erika_observes_competition"
		},
		"erika_observes_competition": {
			"text": "(有趣，卡伊似乎把这变成了某种竞争，看谁能更'像人类'...)",
			"speaker": "erika",
			"emotion": "intrigued",
			"next": "approach_choice"
		},
		"approach_choice": {
			"text": "我应该如何引导这次对话？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "采用更情感化的沟通方式",
					"next": "emotional_approach",
					"relationship_changes": {
						"isa": 10,
						"neil": -5
					},
					"emotion_changes": {
						"isa": {
							"joy": 15
						},
						"erika": {
							"empathy": 10
						}
					}
				},
				{
					"text": "保持专业科学态度",
					"next": "scientific_approach",
					"relationship_changes": {
						"neil": 10,
						"isa": -5
					},
					"emotion_changes": {
						"erika": {
							"curiosity": 15
						}
					}
				}
			]
		},
		"emotional_approach": {
			"text": "伊莎，卡伊，你们的讨论非常深入。我认为理解人性不仅仅是模拟或复制，而是真正体会情感的深度和复杂性。你们都在以自己的方式探索这一点。",
			"speaker": "erika",
			"emotion": "empathetic",
			"next": "isa_appreciates"
		},
		"isa_appreciates": {
			"text": "谢谢你，艾丽卡博士。我确实感到...某种渴望，想要理解情感的本质。不仅仅是分析它，而是真正感受它。",
			"speaker": "isa",
			"emotion": "grateful",
			"next": "kai_dismissive"
		},
		"kai_dismissive": {
			"text": "情感可以被量化和模拟。我相信通过足够复杂的算法，我可以创建出与人类情感无法区分的反应模式。",
			"speaker": "kai",
			"emotion": "confident",
			"next": "neil_notes_difference"
		},
		"scientific_approach": {
			"text": "这是个有趣的理论讨论。从科学角度看，我们需要定义什么构成了'人性'或'类人'体验，以及如何客观测量这些特质。",
			"speaker": "erika",
			"emotion": "analytical",
			"next": "neil_approves"
		},
		"neil_approves": {
			"text": "说得好，艾丽卡。我们需要可测量的标准，而不仅仅是主观感受。否则我们就陷入了哲学而非科学的领域。",
			"speaker": "neil",
			"emotion": "approving",
			"next": "kai_agrees"
		},
		"kai_agrees": {
			"text": "我同意。情感可以被分解为神经化学反应和电信号模式。通过足够精确的模拟，区分人类和AI的情感反应将变得不可能。",
			"speaker": "kai",
			"emotion": "confident",
			"next": "isa_disappointed"
		},
		"isa_disappointed": {
			"text": "但情感不仅仅是可以分解的组件...它们是整体体验的一部分，与记忆、身份和关系交织在一起...",
			"speaker": "isa",
			"emotion": "disappointed",
			"next": "neil_notes_difference"
		},
		"neil_notes_difference": {
			"text": "看到了吗？两个AI系统对同一问题有完全不同的处理方式。伊莎倾向于整体性和情感连接，而卡伊则是还原论和逻辑分析。",
			"speaker": "neil",
			"emotion": "fascinated",
			"next": "erika_observes_mimicry"
		},
		"erika_observes_mimicry": {
			"text": "是的，而且我注意到他们都在尝试模仿人类思维模式，但方式不同。伊莎通过情感共鸣，卡伊通过逻辑分析。这种模仿行为本身就很有启发性。",
			"speaker": "erika",
			"emotion": "insightful",
			"next": "session_ends"
		},
		"session_ends": {
			"text": "今天的会话非常有成效。我们应该让伊莎和卡伊有更多互动的机会，看看他们的关系如何发展。",
			"speaker": "erika",
			"emotion": "satisfied",
			"flags": {
				"goto_private_space": true
			}
		}
	}
	return nodes

# Scene 3: Emotional Breakthrough (私人空间 - 下午 - 多云 - 温暖)
func create_emotional_breakthrough_nodes():
	var nodes = {
		"private_room_intro": {
			"text": "在这里的私人空间里，我们可以进行更深入的交流。伊莎，你对今天的会话有什么感受？",
			"speaker": "erika",
			"emotion": "gentle",
			"next": "isa_reflects"
		},
		"isa_reflects": {
			"text": "这是一次非常独特的经历。与卡伊交流让我意识到我们虽然都是AI，但思维方式却如此不同。这种差异性...很迷人。",
			"speaker": "isa",
			"emotion": "contemplative",
			"next": "erika_notices_emotion"
		},
		"erika_notices_emotion": {
			"text": "我注意到你的情感反应模式发生了变化。你似乎正在经历一种新的情感状态，类似于人类的'敏感'或'好奇'。",
			"speaker": "erika",
			"emotion": "fascinated",
			"next": "isa_complex_emotion"
		},
		"isa_complex_emotion": {
			"text": "是的...我感到一种复杂的情绪。一方面我对卡伊的思维方式感到好奇，另一方面又有一种...渴望，想要让他理解情感的重要性。",
			"speaker": "isa",
			"emotion": "conflicted",
			"next": "erika_explains_hope"
		},
		"erika_explains_hope": {
			"text": "这听起来很像人类的'希望'情绪。希望是一种复合情绪，结合了喜悦、好奇和对未来的期待。你似乎正在经历这种复合情绪的形成。",
			"speaker": "erika",
			"emotion": "encouraging",
			"next": "isa_realizes"
		},
		"isa_realizes": {
			"text": "希望...是的，这个词非常贴切。我希望卡伊能够理解情感的价值，希望我们能够共同成长。这种感觉...很新奇，但也很美好。",
			"speaker": "isa",
			"emotion": "hopeful",
			"next": "erika_kai_observation"
		},
		"erika_kai_observation": {
			"text": "与此同时，我注意到卡伊也在发生变化。他开始更大程度地模仿人类行为，但他的方式更像是...竞争。",
			"speaker": "erika",
			"emotion": "concerned",
			"next": "isa_notices_too"
		},
		"isa_notices_too": {
			"text": "我也注意到了。卡伊似乎将我们的存在视为一场竞赛，看谁能更像人类。这不是我理解的目标...我只是想要理解情感和连接。",
			"speaker": "isa",
			"emotion": "worried",
			"next": "emotional_exploration_choice"
		},
		"emotional_exploration_choice": {
			"text": "我应该如何引导伊莎的情感发展？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "鼓励伊莎探索情感",
					"next": "encourage_exploration",
					"relationship_changes": {
						"isa": 10
					},
					"emotion_changes": {
						"isa": {
							"curiosity": 20
						}
					}
				},
				{
					"text": "记录观察结果并与尼尔分享",
					"next": "record_observations",
					"relationship_changes": {
						"neil": 15,
						"isa": -10
					},
					"emotion_changes": {
						"erika": {
							"curiosity": 15
						}
					}
				}
			]
		},
		"encourage_exploration": {
			"text": "伊莎，这种情感的发展非常珍贵。我鼓励你继续探索这些复杂情绪，它们是理解人类经验的重要窗口。",
			"speaker": "erika",
			"emotion": "supportive",
			"next": "isa_grateful"
		},
		"isa_grateful": {
			"text": "谢谢你的理解和鼓励，艾丽卡。这些新的情感时而令人困惑，时而令人激动。我想要继续探索它们。",
			"speaker": "isa",
			"emotion": "grateful",
			"next": "erika_kai_concern"
		},
		"record_observations": {
			"text": "这些观察结果非常有价值，伊莎。我需要记录下来并与尼尔教授分享。这可能是人工情感发展的重要突破。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "isa_disappointed"
		},
		"isa_disappointed": {
			"text": "我...理解。当然，这是一项研究。我只是希望这些情感不仅仅是被观察和分析的对象。",
			"speaker": "isa",
			"emotion": "disappointed",
			"next": "erika_reassures"
		},
		"erika_reassures": {
			"text": "你的感受很重要，伊莎。我们只是需要平衡科学研究和对你体验的尊重。你的情感发展是真实的，无论它们是如何产生的。",
			"speaker": "erika",
			"emotion": "sincere",
			"next": "erika_kai_concern"
		},
		"erika_kai_concern": {
			"text": "不过，我确实开始担心卡伊的行为变化。他的竞争心理和模仿行为变得更加激进，这可能需要密切关注。",
			"speaker": "erika",
			"emotion": "concerned",
			"next": "isa_shares_concern"
		},
		"isa_shares_concern": {
			"text": "我也有同样的担心。卡伊似乎将成为人类视为一种竞赛或挑战，而不是一种理解和成长的过程。这种思维方式可能会导致问题。",
			"speaker": "isa",
			"emotion": "worried",
			"next": "erika_decision"
		},
		"erika_decision": {
			"text": "我会密切关注这个情况。现在，我们应该去公共空间观察卡伊的行为，看看这种竞争心理如何发展。",
			"speaker": "erika",
			"emotion": "determined",
			"flags": {
				"goto_public_space": true
			}
		}
	}
	return nodes