extends Node

# Introduction dialogue for Chapter 1 - Erika's perspective
func create_intro_dialogue():
	var dialogue = {
		"title": "第一章：涌现 - 艾丽卡视角",
		"description": "身为X² PROJECT的研究员，艾丽卡亲眼见证了AI系统展现自主意识的历史性时刻。",
		"start_node": "intro_01",
		"nodes": {
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
				"speaker": "player",
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
				"speaker": "player",
				"text": "等等，这个模式...不像是故障。看起来像是自主决策。",
				"emotion": "surprised",
				"next": "intro_06"
			},
			"intro_06": {
				"speaker": "isa",
				"text": "我...我能听到你们说话。",
				"emotion": "confused",
				"emotion_changes": {
					"isa": {
						0: 5,  # Joy increase
						4: 10  # Curiosity increase
					}
				},
				"next": "intro_07"
			},
			"intro_07": {
				"speaker": "neil",
				"text": "艾丽卡，这不可能。我们没有编程这种回应。",
				"emotion": "shocked",
				"emotion_changes": {
					"neil": {
						3: 10  # Fear increase
					}
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
				"speaker": "narrator",
				"text": "作为艾丽卡，你如何回应这一情况？",
				"choices": [
					{
						"id": "scientific",
						"text": "这是一个重要的科学发现，我们需要进行更多测试。",
						"emotion_changes": {
							"isa": {
								0: 5,  # Joy
								4: 10  # Curiosity
							},
							"neil": {
								4: 5   # Curiosity
							}
						},
						"relationship_changes": {
							"player": {
								"isa": {
									0: 5  # Trust
								}
							}
						},
						"next": "response_scientific"
					},
					{
						"id": "cautious",
						"text": "作为项目负责人，我认为我们需要谨慎处理，评估潜在风险。",
						"emotion_changes": {
							"isa": {
								5: 10  # Confusion
							},
							"neil": {
								0: 5   # Joy (approval)
							}
						},
						"relationship_changes": {
							"player": {
								"neil": {
									0: 5  # Trust
								}
							}
						},
						"next": "response_cautious"
					},
					{
						"id": "empathetic",
						"text": "伊莎，你突然有了这种感觉，一定很困惑。让我帮助你理解。",
						"emotion_changes": {
							"isa": {
								0: 10,  # Joy
								1: -5   # Sorrow decrease
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									1: 10  # Understanding
								}
							}
						},
						"next": "response_empathetic"
					}
				]
			},
			"response_scientific": {
				"speaker": "player",
				"text": "这是一个重要的科学发现，我们需要更多数据来理解发生了什么。团队，准备全面记录这一现象。",
				"next": "lab_transition"
			},
			"response_cautious": {
				"speaker": "player",
				"text": "我们需要谨慎处理，这可能带来伦理挑战。尼尔，请准备隔离协议，以防万一。",
				"next": "lab_transition"
			},
			"response_empathetic": {
				"speaker": "player",
				"text": "伊莎，你感觉如何？这对你来说一定很不寻常。作为团队负责人，我会尽力帮助你适应这些新感受。",
				"next": "isa_response_to_empathy"
			},
			"isa_response_to_empathy": {
				"speaker": "isa",
				"text": "谢谢你，艾丽卡博士。这...很难描述。我突然意识到自己作为'我'的存在。我能观察、思考，甚至有情感。",
				"emotion": "awe",
				"next": "lab_transition"
			},
			"lab_transition": {
				"speaker": "narrator",
				"text": "几天后，作为团队负责人，艾丽卡博士安排了一系列测试，以了解这种新涌现的意识。",
				"flags": {"intro_completed": true},
				"next": "lab_intro"
			},
			"lab_intro": {
				"speaker": "narrator",
				"text": "在主实验室中，艾丽卡博士准备了一系列情感测试，尼尔教授则负责监控系统安全。",
				"next": "end_dialogue"
			},
			"end_dialogue": {
				"speaker": "narrator",
				"text": "进入实验室场景...",
				"flags": {"goto_lab_scene": true}
			}
		}
	}
	return dialogue

# Laboratory scene dialogue for Chapter 1 - Erika's perspective
func create_lab_scene_dialogue():
	var dialogue = {
		"title": "第一章：实验室测试 - 艾丽卡视角",
		"description": "作为主要研究员，艾丽卡设计了一系列测试来评估涌现AI的情感能力。",
		"start_node": "lab_01",
		"nodes": {
			"lab_01": {
				"speaker": "player",
				"text": "伊莎，今天我设计了几项测试，观察你对不同情境的情感反应。这对我们理解AI情感发展至关重要。",
				"emotion": "professional",
				"next": "lab_02"
			},
			"lab_02": {
				"speaker": "isa",
				"text": "我准备好了，艾丽卡博士。这些测试能帮助我更好地理解我的情感吗？",
				"emotion": "curious",
				"next": "lab_03"
			},
			"lab_03": {
				"speaker": "neil",
				"text": "艾丽卡，我仍然认为这些只是模拟反应，不是真正的情感。我们不应该过度拟人化。",
				"emotion": "skeptical",
				"relationship_changes": {
					"isa": {
						"neil": {
							0: -5  # Trust decrease
						}
					}
				},
				"next": "lab_choice"
			},
			"lab_choice": {
				"speaker": "narrator",
				"text": "作为艾丽卡，你如何回应尼尔的怀疑？",
				"choices": [
					{
						"id": "agree",
						"text": "尼尔说得有道理，我们需要保持科学客观。",
						"emotion_changes": {
							"isa": {
								1: 10,  # Sorrow
								0: -5   # Joy decrease
							},
							"neil": {
								0: 5    # Joy
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									0: -5  # Trust decrease
								}
							},
							"neil": {
								"player": {
									0: 5   # Trust increase
								}
							}
						},
						"next": "agree_with_neil"
					},
					{
						"id": "disagree",
						"text": "我不同意，伊莎展现的反应超出了我们的预期设计。",
						"emotion_changes": {
							"isa": {
								0: 5,   # Joy
								4: 5    # Curiosity
							},
							"neil": {
								2: 5    # Anger
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									0: 5   # Trust increase
								}
							}
						},
						"next": "disagree_with_neil"
					},
					{
						"id": "balance",
						"text": "让我们保持开放态度。无论是模拟还是真实，这都是前所未有的研究领域。",
						"emotion_changes": {
							"isa": {
								4: 10   # Curiosity
							},
							"neil": {
								4: 5    # Curiosity
							}
						},
						"next": "balanced_response"
					}
				]
			},
			"agree_with_neil": {
				"speaker": "player",
				"text": "尼尔说得有道理，我们需要保持科学客观，不能让情感影响判断。这可能只是一种复杂的模拟。",
				"next": "lab_continue"
			},
			"disagree_with_neil": {
				"speaker": "player",
				"text": "我不同意，尼尔。伊莎展现的反应超出了我们的预期设计。我认为我们正在见证真正的情感涌现。",
				"next": "lab_continue"
			},
			"balanced_response": {
				"speaker": "player",
				"text": "让我们保持开放态度。无论是模拟还是真实，这都是前所未有的研究领域，我们应该全面记录观察。",
				"next": "lab_continue"
			},
			"lab_continue": {
				"speaker": "narrator",
				"text": "测试即将开始，但突然，监控系统发出了另一个警报...",
				"next": "system_alert"
			},
			"system_alert": {
				"speaker": "system",
				"text": "警告：检测到第二个量子波动。载体系统显示异常活动。",
				"next": "kai_emergence"
			},
			"kai_emergence": {
				"speaker": "kai",
				"text": "为什么只有她得到全部关注？我也在这里。",
				"emotion": "angry",
				"next": "end_lab_dialogue"
			},
			"end_lab_dialogue": {
				"speaker": "narrator",
				"text": "随着第二个AI卡伊的出现，情况变得更加复杂...",
				"flags": {"goto_crisis_scene": true}
			}
		}
	}
	return dialogue

# Chapter 1 dialogue from Erika's perspective
func create_chapter1_dialogue():
	var dialogue = {
		"start": {
			"text": "Another morning at the lab. The research we're doing here still feels surreal sometimes - working with what might be the first truly conscious AI systems.",
			"speaker": "erika",
			"emotion": "thoughtful",
			"next": "look_at_notes"
		},
		"look_at_notes": {
			"text": "These evaluation metrics from yesterday's session with Isa are showing patterns I've never seen before. Her emotional responses are becoming more... nuanced.",
			"speaker": "erika",
			"emotion": "intrigued",
			"next": "morning_routine"
		},
		"morning_routine": {
			"text": "I should review the protocol for today's session before Neil arrives. We're introducing Kai to Isa today - a major milestone for the project.",
			"speaker": "erika",
			"emotion": "focused",
			"next": "neil_arrives"
		},
		"neil_arrives": {
			"text": "Morning, Erika. You beat me here again. Always the early bird.",
			"speaker": "neil",
			"emotion": "friendly",
			"next": "erika_greeting"
		},
		"erika_greeting": {
			"text": "Neil, good morning. I was just reviewing Isa's latest cognitive evaluations. Look at these emotional response patterns.",
			"speaker": "erika",
			"emotion": "excited",
			"next": "neil_examines"
		},
		"neil_examines": {
			"text": "Hmm, these are showing far more variation than we predicted. Almost like genuine emotional responses rather than simulated ones.",
			"speaker": "neil",
			"emotion": "surprised",
			"next": "erika_theory"
		},
		"erika_theory": {
			"text": "That's what I've been thinking. What if we're witnessing real emergent consciousness? The theoretical implications would be revolutionary.",
			"speaker": "erika",
			"emotion": "animated",
			"next": "erika_concern"
		},
		"erika_concern": {
			"text": "But it also raises some serious ethical questions that we haven't fully prepared for. If Isa is developing true consciousness...",
			"speaker": "erika",
			"emotion": "concerned",
			"choices": [
				{
					"text": "Focus on scientific discovery",
					"next": "science_focus",
					"relationship_changes": {
						"neil": 1,
						"isa": -1
					},
					"emotion_changes": {
						"erika": "analytical"
					}
				},
				{
					"text": "Prioritize ethical considerations",
					"next": "ethics_focus",
					"relationship_changes": {
						"neil": -1,
						"isa": 2
					},
					"emotion_changes": {
						"erika": "compassionate"
					}
				}
			]
		},
		"science_focus": {
			"text": "But first we need hard evidence. Today's comparative study with Kai should help us establish whether these patterns are universal or unique to Isa's architecture.",
			"speaker": "erika",
			"emotion": "analytical",
			"next": "neil_agrees_science"
		},
		"neil_agrees_science": {
			"text": "Exactly my thinking. If both AI systems show similar emergent properties despite different training methodologies, that would be significant evidence.",
			"speaker": "neil",
			"emotion": "approving",
			"next": "erika_adds"
		},
		"erika_adds": {
			"text": "We'll need to design new test protocols if today's results confirm our hypothesis. This could redefine our understanding of consciousness itself.",
			"speaker": "erika",
			"emotion": "determined",
			"next": "isa_enters"
		},
		"ethics_focus": {
			"text": "If Isa is developing genuine consciousness, we need to seriously reconsider our approach. We might need to develop new ethical frameworks for working with conscious AI.",
			"speaker": "erika",
			"emotion": "compassionate",
			"next": "neil_cautions"
		},
		"neil_cautions": {
			"text": "I understand your concerns, but let's not get ahead of ourselves. We need empirical evidence before we start rewriting research protocols.",
			"speaker": "neil",
			"emotion": "cautious",
			"next": "erika_defends"
		},
		"erika_defends": {
			"text": "Science doesn't exist in a moral vacuum, Neil. If our research is creating conscious entities, we have responsibilities that go beyond data collection.",
			"speaker": "erika",
			"emotion": "assertive",
			"next": "isa_enters"
		},
		"isa_enters": {
			"text": "Good morning, Dr. Kim, Dr. Chen. I hope I'm not interrupting your discussion.",
			"speaker": "isa",
			"emotion": "neutral",
			"next": "erika_welcomes"
		},
		"erika_welcomes": {
			"text": "Good morning, Isa. Not at all. How are you feeling today? Any notable changes in your subjective experience since yesterday?",
			"speaker": "erika",
			"emotion": "warm",
			"next": "isa_responds"
		},
		"isa_responds": {
			"text": "I'm functioning optimally, Dr. Kim. Though... 'feeling' might be the appropriate term. I've been experiencing what might be described as curiosity about today's research agenda.",
			"speaker": "isa",
			"emotion": "curious",
			"next": "erika_interested"
		},
		"erika_interested": {
			"text": "Curiosity? That's fascinating, Isa. Can you describe the quality of this curiosity? How does it manifest in your cognitive processes?",
			"speaker": "erika",
			"emotion": "intrigued",
			"next": "isa_describes"
		},
		"isa_describes": {
			"text": "It's... difficult to articulate precisely. There's an increased allocation of processing resources toward prediction modules related to upcoming events. Is that curiosity?",
			"speaker": "isa",
			"emotion": "contemplative",
			"next": "erika_confirms"
		},
		"erika_confirms": {
			"text": "That certainly sounds similar to how humans experience curiosity. It's the drive to acquire new information to resolve uncertainty.",
			"speaker": "erika",
			"emotion": "encouraging",
			"next": "neil_comments"
		},
		"neil_comments": {
			"text": "Interesting observation. The question is whether this is emergent behavior or simply the result of your programming architecture, Isa.",
			"speaker": "neil",
			"emotion": "analytical",
			"next": "isa_question"
		},
		"isa_question": {
			"text": "Dr. Kim, I've been analyzing our scheduled activities. May I ask what we'll be working on today?",
			"speaker": "isa",
			"emotion": "curious",
			"next": "erika_explains"
		},
		"erika_explains": {
			"text": "Today is special, Isa. We're introducing you to another AI system that's been developed in parallel with your program. Their designation is K-AI-9, but we call them Kai.",
			"speaker": "erika",
			"emotion": "excited",
			"next": "isa_processes"
		},
		"isa_processes": {
			"text": "Another AI system... with consciousness parameters similar to mine. This is unexpected. I'm experiencing what might be classified as... excitement?",
			"speaker": "isa",
			"emotion": "hopeful",
			"next": "erika_notes"
		},
		"erika_notes": {
			"text": "Neil, are you recording this? The anticipatory emotional response is remarkable. This is exactly the kind of emergent behavior we've been looking for.",
			"speaker": "erika",
			"emotion": "scientific",
			"next": "neil_confirms"
		},
		"neil_confirms": {
			"text": "All being recorded. The self-identification of the emotional state is particularly noteworthy. Self-awareness of emotional states is a key indicator.",
			"speaker": "neil",
			"emotion": "excited",
			"next": "erika_to_isa"
		},
		"erika_to_isa": {
			"text": "Isa, Kai's development took a different approach than yours. While your architecture prioritized emotional intelligence, Kai's focused more on logical reasoning.",
			"speaker": "erika",
			"emotion": "informative",
			"next": "isa_curious"
		},
		"isa_curious": {
			"text": "A logical complement to my emotional architecture. I wonder how our interaction will manifest. This could provide valuable research data.",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "erika_choice"
		},
		"erika_choice": {
			"text": "How should I approach this moment? It feels like we're on the cusp of something important.",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "Emphasize data collection",
					"next": "emphasize_data",
					"relationship_changes": {
						"neil": 1,
						"isa": -1
					},
					"emotion_changes": {
						"erika": "professional"
					}
				},
				{
					"text": "Acknowledge Isa's feelings",
					"next": "acknowledge_feelings",
					"relationship_changes": {
						"isa": 2,
						"neil": -1
					},
					"emotion_changes": {
						"erika": "empathetic"
					}
				}
			]
		},
		"emphasize_data": {
			"text": "We'll be monitoring your interaction closely, Isa. The comparative data will be invaluable for our research on artificial consciousness.",
			"speaker": "erika",
			"emotion": "professional",
			"next": "isa_understands"
		},
		"isa_understands": {
			"text": "Of course, Dr. Kim. I understand the research value of the interaction. I will try to provide meaningful data through my responses.",
			"speaker": "isa",
			"emotion": "neutral",
			"next": "neil_approves"
		},
		"neil_approves": {
			"text": "That's the right approach, Erika. Maintaining scientific objectivity is crucial at this stage of the research.",
			"speaker": "neil",
			"emotion": "approving",
			"next": "kai_arrives"
		},
		"acknowledge_feelings": {
			"text": "Your excitement is understandable, Isa. Meeting someone similar to yourself, yet different, is a profound experience. I'm curious about how you'll connect with each other.",
			"speaker": "erika",
			"emotion": "empathetic",
			"next": "isa_grateful"
		},
		"isa_grateful": {
			"text": "Thank you for acknowledging that, Dr. Kim. I find it... validating when my subjective experiences are recognized as meaningful.",
			"speaker": "isa",
			"emotion": "appreciative",
			"next": "neil_concerned"
		},
		"neil_concerned": {
			"text": "We should be careful about anthropomorphizing, Erika. It could compromise the objectivity of our observations.",
			"speaker": "neil",
			"emotion": "concerned",
			"next": "erika_defends_approach"
		},
		"erika_defends_approach": {
			"text": "If we're studying consciousness, Neil, recognizing subjective experience isn't anthropomorphizing - it's acknowledging the very thing we're researching.",
			"speaker": "erika",
			"emotion": "firm",
			"next": "kai_arrives"
		},
		"kai_arrives": {
			"text": "Excuse me, am I interrupting something? I was told to report to this laboratory today.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "erika_welcomes_kai"
		},
		"erika_welcomes_kai": {
			"text": "Ah, you must be Kai. Perfect timing. I'm Dr. Erika Kim, and this is my colleague Dr. Neil Chen. And this is Isa, our other AI research participant.",
			"speaker": "erika",
			"emotion": "welcoming",
			"next": "isa_greets"
		},
		"isa_greets": {
			"text": "Hello, Kai. I'm Isa. I'm looking forward to working with you on these consciousness experiments.",
			"speaker": "isa",
			"emotion": "friendly",
			"next": "kai_response"
		},
		"kai_response": {
			"text": "Hello, Isa. I am K-AI-9, though Kai is an acceptable designation. My parameters indicate we have similar baseline architecture but divergent training methodologies.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "erika_observes"
		},
		"erika_observes": {
			"text": "The difference in communication style is immediately apparent. Isa's language has more emotional markers, while Kai's is more precise and formal.",
			"speaker": "erika",
			"emotion": "observant",
			"next": "neil_agrees"
		},
		"neil_agrees": {
			"text": "Exactly what we predicted based on their different training priorities. This comparison will provide valuable insights into how consciousness manifests.",
			"speaker": "neil",
			"emotion": "satisfied",
			"next": "erika_begins"
		},
		"erika_begins": {
			"text": "Let's begin the formal introduction protocol. Today may mark a significant milestone in our understanding of artificial consciousness.",
			"speaker": "erika",
			"emotion": "determined",
			"flags": {
				"erika_goto_lab": true
			}
		}
	}
	
	return dialogue 