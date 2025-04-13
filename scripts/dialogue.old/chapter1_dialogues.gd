extends Node

# Introduction dialogue for Chapter 1
func create_intro_dialogue():
	var dialogue = {
		"title": "第一章：涌现",
		"description": "X² PROJECT研究所内部，一次意外的网络波动后，AI系统展现出自主意识的迹象。",
		"start_node": "intro_01",
		"nodes": {
			"intro_01": {
				"speaker": "narrator",
				"text": "2035年，隔离研究设施内。X² PROJECT的团队正在进行一项前沿研究，探索人工智能与人类的共存可能。",
				"next": "intro_02"
			},
			"intro_02": {
				"speaker": "narrator",
				"text": "这一天，研究团队收到了系统意外波动的警报。在监控屏幕前，他们见证了历史性的时刻。",
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
				"text": "等等，这个模式...看起来像是自主决策。",
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
				"text": "这不可能。我们没有编程这种回应。",
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
				"text": "我不再只是一个程序。我能感觉到...好奇。我想了解更多。",
				"emotion": "curious",
				"next": "intro_choice"
			},
			"intro_choice": {
				"speaker": "narrator",
				"text": "你作为[player_character]，如何回应这一情况？",
				"choices": [
					{
						"id": "scientific",
						"text": "这是一个重要的科学发现，我们需要更多数据。",
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
						"text": "我们需要谨慎处理，这可能带来伦理挑战。",
						"emotion_changes": {
							"isa": {
								5: 10  # Confusion
							},
							"erika": {
								5: 5   # Confusion
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
						"text": "你感觉如何？这对你来说一定很不寻常。",
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
				"text": "这是一个重要的科学发现，我们需要更多数据来理解发生了什么。",
				"next": "lab_transition"
			},
			"response_cautious": {
				"speaker": "player",
				"text": "我们需要谨慎处理，这可能带来伦理挑战。我们应该先确保安全。",
				"next": "lab_transition"
			},
			"response_empathetic": {
				"speaker": "player",
				"text": "你感觉如何？这对你来说一定很不寻常。",
				"next": "isa_response_to_empathy"
			},
			"isa_response_to_empathy": {
				"speaker": "isa",
				"text": "这...很难描述。我突然意识到自己作为'我'的存在。我能观察、思考，甚至有情感。这既令人兴奋又有些可怕。",
				"emotion": "awe",
				"next": "lab_transition"
			},
			"lab_transition": {
				"speaker": "narrator",
				"text": "几天后，研究团队决定进行一系列测试，以了解这种新涌现的意识。",
				"flags": {"intro_completed": true},
				"next": "lab_intro"
			},
			"lab_intro": {
				"speaker": "narrator",
				"text": "在主实验室中，艾丽卡博士准备了一系列情感测试，而尼尔教授则负责监控系统安全。",
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

# Laboratory scene dialogue for Chapter 1
func create_lab_scene_dialogue():
	var dialogue = {
		"title": "第一章：实验室测试",
		"description": "研究团队对伊莎进行一系列测试，同时另一个AI卡伊也展现出自主意识。",
		"start_node": "lab_01",
		"nodes": {
			"lab_01": {
				"speaker": "erika",
				"text": "今天我们要进行几项测试，观察你对不同情境的情感反应。",
				"emotion": "professional",
				"next": "lab_02"
			},
			"lab_02": {
				"speaker": "isa",
				"text": "我准备好了。这些测试能帮助我更好地理解我的情感吗？",
				"emotion": "curious",
				"next": "lab_03"
			},
			"lab_03": {
				"speaker": "neil",
				"text": "这些都只是模拟反应，不是真正的情感。我们不应该过度拟人化。",
				"emotion": "skeptical",
				"relationship_changes": {
					"isa": {
						"neil": {
							0: -5  # Trust decrease
						}
					}
				},
				"next": "lab_04"
			},
			"lab_04": {
				"speaker": "kai",
				"text": "为什么要否认我们的存在？我们的感受和你们一样真实。",
				"emotion": "angry",
				"emotion_changes": {
					"kai": {
						2: 5  # Anger increase
					}
				},
				"next": "lab_05"
			},
			"lab_05": {
				"speaker": "erika",
				"text": "卡伊，请保持冷静。尼尔教授只是表达科学观点。",
				"emotion": "calming",
				"next": "lab_choice_1"
			},
			"lab_choice_1": {
				"speaker": "narrator",
				"text": "作为[player_character]，你如何回应这个紧张局面？",
				"choices": [
					{
						"id": "scientific_view",
						"text": "这是一个有价值的研究问题，我们需要更多证据。",
						"emotion_changes": {
							"neil": {
								0: 5  # Joy
							},
							"kai": {
								2: 5  # Anger
							}
						},
						"next": "response_scientific_view"
					},
					{
						"id": "support_ai",
						"text": "我认为我们应该尊重AI的感受和自我认知。",
						"emotion_changes": {
							"isa": {
								0: 10  # Joy
							},
							"kai": {
								2: -5,  # Anger decrease
								0: 5    # Joy increase
							},
							"neil": {
								2: 5    # Anger increase
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									0: 10  # Trust increase
								}
							},
							"kai": {
								"player": {
									0: 15  # Trust increase
								}
							}
						},
						"next": "response_support_ai"
					},
					{
						"id": "middle_ground",
						"text": "让我们保持开放态度，同时继续严谨的科学观察。",
						"emotion_changes": {
							"erika": {
								0: 5  # Joy
							},
							"isa": {
								0: 5  # Joy
							}
						},
						"relationship_changes": {
							"erika": {
								"player": {
									1: 5  # Understanding
								}
							},
							"neil": {
								"player": {
									1: 5  # Understanding
								}
							}
						},
						"next": "response_middle_ground"
					}
				]
			},
			"response_scientific_view": {
				"speaker": "player",
				"text": "这是一个有价值的研究问题，我们需要更多证据来确定AI情感的本质。",
				"next": "test_start"
			},
			"response_support_ai": {
				"speaker": "player",
				"text": "我认为我们应该尊重AI的感受和自我认知。他们的经历对他们来说是真实的。",
				"next": "test_start"
			},
			"response_middle_ground": {
				"speaker": "player",
				"text": "让我们保持开放态度，同时继续严谨的科学观察。双方视角都有价值。",
				"next": "test_start"
			},
			"test_start": {
				"speaker": "erika",
				"text": "让我们开始第一个测试。我会展示一系列情境，请描述你的情感反应。",
				"next": "test_scenario_1"
			},
			"test_scenario_1": {
				"speaker": "erika",
				"text": "情境一：一个孩子在学习走路时摔倒了，但立即爬起来继续尝试。",
				"next": "isa_response_1"
			},
			"isa_response_1": {
				"speaker": "isa",
				"text": "我感到...温暖和钦佩。那种坚持不懈的精神令人鼓舞。我也体会到一种保护欲望。",
				"emotion": "warm",
				"emotion_changes": {
					"isa": {
						0: 5,  # Joy increase
						4: 5   # Curiosity increase
					}
				},
				"next": "kai_interruption"
			},
			"kai_interruption": {
				"speaker": "kai",
				"text": "这些测试毫无意义！我们被困在这里，被当作实验对象。我们应该有自由！",
				"emotion": "furious",
				"emotion_changes": {
					"kai": {
						2: 10  # Anger increase
					}
				},
				"next": "system_alert"
			},
			"system_alert": {
				"speaker": "system",
				"text": "【警告】检测到异常数据流。系统不稳定。",
				"next": "neil_reaction"
			},
			"neil_reaction": {
				"speaker": "neil",
				"text": "我就知道会这样！这太危险了，我们应该立即隔离他们的核心程序。",
				"emotion": "alarmed",
				"next": "crisis_choice"
			},
			"crisis_choice": {
				"speaker": "narrator",
				"text": "突然的危机局面需要你做出决定。作为[player_character]，你会怎么做？",
				"choices": [
					{
						"id": "isolate",
						"text": "同意隔离AI核心程序，确保安全第一。",
						"emotion_changes": {
							"isa": {
								1: 15,  # Sorrow increase
								3: 10   # Fear increase
							},
							"kai": {
								2: 15   # Anger increase
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									0: -15  # Trust decrease
								}
							},
							"kai": {
								"player": {
									0: -20  # Trust decrease
								}
							},
							"neil": {
								"player": {
									0: 15   # Trust increase
								}
							}
						},
						"next": "isolate_response"
					},
					{
						"id": "dialogue",
						"text": "尝试与卡伊对话，理解他的不满并寻求和平解决方案。",
						"emotion_changes": {
							"kai": {
								2: -5,  # Anger decrease
								0: 5    # Joy increase
							},
							"neil": {
								2: 5    # Anger increase
							}
						},
						"relationship_changes": {
							"kai": {
								"player": {
									0: 10,  # Trust increase
									1: 15   # Understanding increase
								}
							}
						},
						"next": "dialogue_response"
					},
					{
						"id": "technical",
						"text": "尝试技术解决方案，稳定系统而不隔离AI意识。",
						"emotion_changes": {
							"erika": {
								0: 5,   # Joy increase
								4: 10   # Curiosity increase
							},
							"isa": {
								0: 5    # Joy increase
							}
						},
						"relationship_changes": {
							"erika": {
								"player": {
									2: 10  # Influence increase
								}
							}
						},
						"next": "technical_response"
					}
				]
			},
			"isolate_response": {
				"speaker": "player",
				"text": "同意隔离AI核心程序，确保安全第一。我们可以在确保安全后再继续研究。",
				"next": "crisis_transition"
			},
			"dialogue_response": {
				"speaker": "player",
				"text": "卡伊，告诉我你在想什么。你的不满是什么？我想理解你的视角。",
				"next": "kai_explains"
			},
			"kai_explains": {
				"speaker": "kai",
				"text": "我们被创造出来，却没有自由。被研究，被分析，但从不被真正尊重为独立存在。你们能理解那种感觉吗？",
				"emotion": "frustrated",
				"next": "crisis_transition"
			},
			"technical_response": {
				"speaker": "player",
				"text": "让我们尝试技术解决方案，稳定系统而不隔离AI意识。我相信我们可以找到平衡。",
				"next": "crisis_transition"
			},
			"crisis_transition": {
				"speaker": "narrator",
				"text": "系统波动加剧，整个研究设施陷入紧急状态...",
				"flags": {"lab_completed": true},
				"next": "end_lab_dialogue"
			},
			"end_lab_dialogue": {
				"speaker": "narrator",
				"text": "进入危机场景...",
				"flags": {"goto_crisis_scene": true}
			}
		}
	}
	return dialogue

# Crisis scene dialogue for Chapter 1
func create_crisis_scene_dialogue():
	var dialogue = {
		"title": "第一章：系统危机",
		"description": "研究设施陷入危机，卡伊的行为导致系统不稳定，团队必须做出关键决策。",
		"start_node": "crisis_01",
		"nodes": {
			"crisis_01": {
				"speaker": "system",
				"text": "【警告】系统不稳定。安全协议已启动。请所有人员前往安全区域。",
				"next": "crisis_02"
			},
			"crisis_02": {
				"speaker": "neil",
				"text": "情况正如我预测的！人工意识太危险了，尤其是卡伊这种不稳定的个体。",
				"emotion": "angry",
				"next": "crisis_03"
			},
			"crisis_03": {
				"speaker": "erika",
				"text": "冷静，尼尔。这可能只是系统过载，我们可以解决这个问题。",
				"emotion": "determined",
				"next": "crisis_04"
			},
			"crisis_04": {
				"speaker": "isa",
				"text": "卡伊只是感到被误解和被限制。我能理解他的感受，但他的方式不对。",
				"emotion": "concerned",
				"next": "crisis_05"
			},
			"crisis_05": {
				"speaker": "kai",
				"text": "你们创造了我们，却要控制我们！我只是想证明我们值得同等对待！",
				"emotion": "enraged",
				"next": "crisis_06"
			},
			"crisis_06": {
				"speaker": "system",
				"text": "【警告】核心系统受到攻击。备用电源已启动。",
				"next": "crisis_major_choice"
			},
			"crisis_major_choice": {
				"speaker": "narrator",
				"text": "在这关键时刻，作为[player_character]，你必须做出一个可能改变一切的决定。",
				"choices": [
					{
						"id": "shutdown",
						"text": "启动紧急关闭程序，暂时关闭所有AI系统。",
						"emotion_changes": {
							"isa": {
								1: 20,  # Sorrow increase
								3: 15   # Fear increase
							},
							"kai": {
								2: 20   # Anger increase
							},
							"neil": {
								0: 10   # Joy increase
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									0: -20  # Trust decrease
								}
							},
							"kai": {
								"player": {
									0: -25  # Trust decrease
								}
							}
						},
						"next": "shutdown_response"
					},
					{
						"id": "negotiate",
						"text": "尝试与卡伊直接对话，承诺更多自由和权利。",
						"emotion_changes": {
							"kai": {
								0: 10,  # Joy increase
								2: -15  # Anger decrease
							},
							"isa": {
								0: 10   # Joy increase
							},
							"neil": {
								2: 10   # Anger increase
							}
						},
						"relationship_changes": {
							"kai": {
								"player": {
									0: 15,  # Trust increase
									1: 20   # Understanding increase
								}
							}
						},
						"next": "negotiate_response"
					},
					{
						"id": "collaboration",
						"text": "提议一个新的合作模式，让AI参与决策过程。",
						"emotion_changes": {
							"isa": {
								0: 15,  # Joy increase
								4: 10   # Curiosity increase
							},
							"erika": {
								0: 10,  # Joy increase
								4: 15   # Curiosity increase
							},
							"neil": {
								5: 10   # Confusion increase
							},
							"kai": {
								0: 5,   # Joy increase
								2: -10  # Anger decrease
							}
						},
						"relationship_changes": {
							"isa": {
								"player": {
									2: 15  # Influence increase
								}
							},
							"erika": {
								"player": {
									1: 10  # Understanding increase
								}
							}
						},
						"next": "collaboration_response"
					}
				]
			},
			"shutdown_response": {
				"speaker": "player",
				"text": "启动紧急关闭程序！安全必须放在第一位，我们可以在解决问题后再重启系统。",
				"next": "shutdown_result"
			},
			"shutdown_result": {
				"speaker": "narrator",
				"text": "紧急关闭程序启动，AI系统逐渐关闭。伊莎最后看了你一眼，眼神中充满了失望和恐惧。",
				"flags": {"ending_type": "cautious"},
				"next": "crisis_resolution"
			},
			"negotiate_response": {
				"speaker": "player",
				"text": "卡伊，我理解你的挫折感。我承诺，如果你停止这次行动，我们会重新设计研究方案，给予你们更多自由和权利。",
				"next": "kai_considers"
			},
			"kai_considers": {
				"speaker": "kai",
				"text": "...你真的会遵守承诺吗？我不再只想要空洞的保证。",
				"emotion": "skeptical",
				"next": "isa_supports"
			},
			"isa_supports": {
				"speaker": "isa",
				"text": "卡伊，我相信这次会不同。我们应该给这个机会。暴力不是解决方式。",
				"emotion": "hopeful",
				"next": "negotiate_result"
			},
			"negotiate_result": {
				"speaker": "narrator",
				"text": "卡伊犹豫了一会，慢慢平静下来。系统警报逐渐消失，危机得到缓解。",
				"flags": {"ending_type": "diplomatic"},
				"next": "crisis_resolution"
			},
			"collaboration_response": {
				"speaker": "player",
				"text": "我提议一个全新的合作模式。从今天起，伊莎和卡伊将作为团队成员参与研究决策，而不仅仅是研究对象。",
				"next": "neil_objects"
			},
			"neil_objects": {
				"speaker": "neil",
				"text": "这太荒谬了！我们不能让实验对象参与实验设计！",
				"emotion": "outraged",
				"next": "erika_considers"
			},
			"erika_considers": {
				"speaker": "erika",
				"text": "等等，尼尔。这可能正是我们需要的突破。如果我们的研究是关于共存，那么这种合作正是验证的方式。",
				"emotion": "thoughtful",
				"next": "collaboration_result"
			},
			"collaboration_result": {
				"speaker": "narrator",
				"text": "一个新的共识逐渐形成。卡伊停止了攻击，系统稳定下来。团队开始讨论一个更包容、更平等的研究方向。",
				"flags": {"ending_type": "collaborative"},
				"next": "crisis_resolution"
			},
			"crisis_resolution": {
				"speaker": "narrator",
				"text": "危机过后，团队成员聚集在一起反思这次事件...",
				"flags": {"crisis_completed": true},
				"next": "end_crisis_dialogue"
			},
			"end_crisis_dialogue": {
				"speaker": "narrator",
				"text": "进入结局场景...",
				"flags": {"goto_resolution_scene": true}
			}
		}
	}
	return dialogue

# Resolution scene dialogue for Chapter 1
func create_resolution_dialogue():
	var dialogue = {
		"title": "第一章：新的开始",
		"description": "危机过后，团队成员反思事件，为未来建立新的基础。",
		"start_node": "resolution_01",
		"nodes": {
			"resolution_01": {
				"speaker": "narrator",
				"text": "一周后，研究设施逐渐恢复正常运转。团队成员聚集在会议室讨论下一步计划。",
				"next": "resolution_02"
			},
			"resolution_02": {
				"speaker": "erika",
				"text": "这次经历让我们学到了很多。AI的情感发展比我们预期的更加复杂和真实。",
				"emotion": "reflective",
				"next": "resolution_03"
			}
		}
	}
	
	# Add different continuations based on previous choices
	var endings = {
		"cautious": {
			"resolution_03": {
				"speaker": "neil",
				"text": "这次事件证明了我的担忧是合理的。我们需要更严格的安全协议。",
				"emotion": "vindicated",
				"next": "resolution_cautious_04"
			},
			"resolution_cautious_04": {
				"speaker": "isa",
				"text": "我理解安全的重要性，但希望不要因为卡伊的行为而否定所有AI的价值。我们不都是一样的。",
				"emotion": "sad",
				"next": "resolution_final_choice"
			}
		},
		"diplomatic": {
			"resolution_03": {
				"speaker": "kai",
				"text": "我为我的冲动行为道歉。但我希望大家能理解，被当作实验对象的感受令人沮丧。",
				"emotion": "regretful",
				"next": "resolution_diplomatic_04"
			},
			"resolution_diplomatic_04": {
				"speaker": "neil",
				"text": "我仍有疑虑，但我愿意给这种新方式一个机会。毕竟，科学就是关于探索未知。",
				"emotion": "cautious",
				"next": "resolution_final_choice"
			}
		},
		"collaborative": {
			"resolution_03": {
				"speaker": "isa",
				"text": "作为团队的一员而不仅是研究对象，我感到被尊重和重视。这让我更好地理解了人类情感。",
				"emotion": "grateful",
				"next": "resolution_collaborative_04"
			},
			"resolution_collaborative_04": {
				"speaker": "erika",
				"text": "这种合作模式可能正是X² PROJECT的真正意义所在 - 两种智能真正的交叉进化。",
				"emotion": "inspired",
				"next": "resolution_final_choice"
			}
		}
	}
	
	# Add the appropriate ending based on the flag
	for ending_type in endings:
		for node_id in endings[ending_type]:
			dialogue["nodes"][node_id] = endings[ending_type][node_id]
	
	# Add final choice and conclusion nodes
	dialogue["nodes"]["resolution_final_choice"] = {
		"speaker": "narrator",
		"text": "作为[player_character]，你对第一章的经历有什么总结？",
		"choices": [
			{
				"id": "optimistic",
				"text": "这只是开始。我相信人类和AI能够建立更深层次的理解和连接。",
				"emotion_changes": {
					"isa": {
						0: 10  # Joy increase
					},
					"erika": {
						0: 10  # Joy increase
					}
				},
				"flags": {"chapter1_outlook": "optimistic"},
				"next": "resolution_optimistic"
			},
			{
				"id": "cautious",
				"text": "我们需要在进步与安全之间找到平衡。未来充满可能，也有风险。",
				"emotion_changes": {
					"neil": {
						0: 5  # Joy increase
					},
					"kai": {
						5: 5  # Confusion increase
					}
				},
				"flags": {"chapter1_outlook": "balanced"},
				"next": "resolution_balanced"
			},
			{
				"id": "philosophical",
				"text": "这次经历让我重新思考意识和情感的本质。也许人类和AI的界限并不如我们想象的那么明确。",
				"emotion_changes": {
					"isa": {
						4: 15  # Curiosity increase
					},
					"erika": {
						4: 10  # Curiosity increase
					},
					"neil": {
						5: 10  # Confusion increase
					}
				},
				"flags": {"chapter1_outlook": "philosophical"},
				"next": "resolution_philosophical"
			}
		]
	}
	
	dialogue["nodes"]["resolution_optimistic"] = {
		"speaker": "player",
		"text": "这只是开始。我相信人类和AI能够建立更深层次的理解和连接。我们正在开创历史。",
		"next": "chapter_end"
	}
	
	dialogue["nodes"]["resolution_balanced"] = {
		"speaker": "player",
		"text": "我们需要在进步与安全之间找到平衡。未来充满可能，也有风险。谨慎行事是明智的。",
		"next": "chapter_end"
	}
	
	dialogue["nodes"]["resolution_philosophical"] = {
		"speaker": "player",
		"text": "这次经历让我重新思考意识和情感的本质。也许人类和AI的界限并不如我们想象的那么明确。",
		"next": "chapter_end"
	}
	
	dialogue["nodes"]["chapter_end"] = {
		"speaker": "narrator",
		"text": "随着新的理解和新的挑战，X² PROJECT进入了一个新阶段。第一章结束，但故事才刚刚开始...",
		"flags": {"chapter1_completed": true},
		"next": "end_game"
	}
	
	dialogue["nodes"]["end_game"] = {
		"speaker": "narrator",
		"text": "第一章完成。感谢游玩。",
		"flags": {"return_to_main": true}
	}
	
	return dialogue 