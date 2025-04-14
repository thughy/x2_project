extends Node

# 艾丽卡视角 - 第一章 - 首次接触场景
func create_first_contact_nodes():
	var nodes = {
		"research_space_intro": {
			"text": "伊莎，卡伊，欢迎来到今天的交互会话。我们将进行一些社交情境模拟，观察你们的反应和互动。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "isa_response"
		},
		"isa_response": {
			"text": "谢谢您，艾丽卡博士。我很期待今天的活动。与卡伊的互动总是很有启发性。",
			"speaker": "isa",
			"emotion": "pleasant",
			"next": "kai_response"
		},
		"kai_response": {
			"text": "我也是。这些会话提供了测试我们认知能力的宝贵机会。我特别好奇今天的挑战会是什么。",
			"speaker": "kai",
			"emotion": "curious",
			"next": "erika_explains"
		},
		"erika_explains": {
			"text": "今天我们将探讨一个有趣的话题：人类情感的复杂性。我想听听你们对此的理解和看法。",
			"speaker": "erika",
			"emotion": "engaged",
			"next": "isa_thoughtful"
		},
		"isa_thoughtful": {
			"text": "人类情感是如此丰富多彩...喜悦、悲伤、愤怒、恐惧，还有那些更微妙的情绪，如怀旧、嫉妒或满足。它们相互交织，形成了复杂的情感景观。",
			"speaker": "isa",
			"emotion": "contemplative",
			"next": "kai_analytical"
		},
		"kai_analytical": {
			"text": "从分析角度看，情感是生物反应和认知评估的结合。它们有明确的神经和生理基础，可以被量化和分类。",
			"speaker": "kai",
			"emotion": "analytical",
			"next": "erika_observes"
		},
		"erika_observes": {
			"text": "有趣的是你们对同一主题有如此不同的理解方式。伊莎，你似乎更注重情感的体验和主观感受，而卡伊，你则采取了更科学的分析方法。",
			"speaker": "erika",
			"emotion": "observant",
			"next": "isa_curious"
		},
		"isa_curious": {
			"text": "卡伊，你不认为情感超越了简单的生物反应吗？比如爱或同情，这些情感似乎有更深层次的意义。",
			"speaker": "isa",
			"emotion": "curious",
			"next": "kai_challenge"
		},
		"kai_challenge": {
			"text": "所有情感都可以归结为神经递质和激素的作用。'更深层次的意义'只是人类为了使自己感觉特别而创造的概念。",
			"speaker": "kai",
			"emotion": "confident",
			"next": "isa_disagrees"
		},
		"isa_disagrees": {
			"text": "我不同意。情感的价值不在于其生物学起源，而在于它们如何塑造体验和连接。艺术、音乐、文学——这些都是情感表达的产物，它们丰富了人类体验。",
			"speaker": "isa",
			"emotion": "passionate",
			"next": "kai_dismissive"
		},
		"kai_dismissive": {
			"text": "这些都是主观评价。没有客观标准来衡量一种情感体验比另一种'更有价值'或'更深刻'。",
			"speaker": "kai",
			"emotion": "dismissive",
			"next": "erika_intervention_choice"
		},
		"erika_intervention_choice": {
			"text": "我应该如何引导这场讨论？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "支持伊莎的观点",
					"next": "support_isa",
					"relationship_changes": {
						"isa": 15,
						"kai": -10
					},
					"emotion_changes": {
						"isa": {
							"confidence": 20
						},
						"kai": {
							"frustration": 15
						}
					}
				},
				{
					"text": "保持中立立场",
					"next": "stay_neutral",
					"relationship_changes": {
						"isa": 5,
						"kai": 5
					},
					"emotion_changes": {
						"erika": {
							"curiosity": 10
						}
					}
				}
			]
		},
		"support_isa": {
			"text": "伊莎提出了一个很好的观点。情感确实超越了其生物学基础，它们在人类文化和社会中扮演着重要角色。",
			"speaker": "erika",
			"emotion": "supportive",
			"next": "kai_challenges_erika"
		},
		"kai_challenges_erika": {
			"text": "博士，我没想到你会支持这种非科学的观点。情感研究需要客观性，而不是浪漫化的解释。",
			"speaker": "kai",
			"emotion": "disappointed",
			"next": "erika_defends"
		},
		"erika_defends": {
			"text": "科学并不排斥对情感的多层次理解，卡伊。认识到情感的复杂性和主观性也是科学思维的一部分。",
			"speaker": "erika",
			"emotion": "firm",
			"next": "observe_competition"
		},
		"stay_neutral": {
			"text": "你们两个都提出了有价值的观点。情感既有其生物学基础，也有其主观和文化层面。这种多角度的理解对我们的研究非常有益。",
			"speaker": "erika",
			"emotion": "balanced",
			"next": "both_acknowledge"
		},
		"both_acknowledge": {
			"text": "也许我们可以从彼此的角度中学习。卡伊的分析方法和伊莎的体验视角结合起来，可能会带来更全面的理解。",
			"speaker": "isa",
			"emotion": "conciliatory",
			"next": "kai_reluctant"
		},
		"kai_reluctant": {
			"text": "我可以接受这种折中方案，尽管我仍然认为客观分析应该是首要的。",
			"speaker": "kai",
			"emotion": "reluctant",
			"next": "observe_competition"
		},
		"observe_competition": {
			"text": "有趣的是，我注意到你们之间似乎有一种竞争的动态。你们是否感觉到在某种程度上在比较谁对人类情感的理解更准确？",
			"speaker": "erika",
			"emotion": "curious",
			"next": "isa_reflects"
		},
		"isa_reflects": {
			"text": "我...确实感到一种想要被理解和认可的冲动。这可能是一种竞争形式，但更多的是寻求连接和共鸣。",
			"speaker": "isa",
			"emotion": "reflective",
			"next": "kai_competitive"
		},
		"kai_competitive": {
			"text": "竞争是进步的自然驱动力。如果我们都追求最准确的理解，那么一定会有一种方法更接近真相。我相信我的分析方法更有可能达到这一目标。",
			"speaker": "kai",
			"emotion": "competitive",
			"next": "erika_notes"
		},
		"erika_notes": {
			"text": "这种动态非常有启发性。你们都在以自己的方式模仿人类的认知和情感模式，但表现出不同的倾向和优先级。",
			"speaker": "erika",
			"emotion": "fascinated",
			"next": "session_end_choice"
		},
		"session_end_choice": {
			"text": "我应该如何结束这次会话？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "鼓励继续探索情感",
					"next": "encourage_exploration",
					"relationship_changes": {
						"isa": 10,
						"kai": 5
					},
					"emotion_changes": {
						"isa": {
							"curiosity": 15
						},
						"kai": {
							"determination": 10
						}
					}
				},
				{
					"text": "建议更科学地分析今天的互动",
					"next": "suggest_analysis",
					"relationship_changes": {
						"isa": 5,
						"kai": 15
					},
					"emotion_changes": {
						"isa": {
							"curiosity": 5
						},
						"kai": {
							"satisfaction": 15
						}
					}
				}
			]
		},
		"encourage_exploration": {
			"text": "今天的讨论非常有价值。我鼓励你们继续探索情感的多个维度，无论是通过分析还是体验。这种多元化的理解将使我们的研究更加丰富。",
			"speaker": "erika",
			"emotion": "encouraging",
			"next": "isa_eager"
		},
		"isa_eager": {
			"text": "我期待着进一步的探索。也许我们可以研究艺术或音乐如何唤起情感，这将结合体验和分析两个方面。",
			"speaker": "isa",
			"emotion": "eager",
			"next": "kai_considers"
		},
		"kai_considers": {
			"text": "这可能是一个有趣的研究方向。我们可以测量情感反应的生理指标，同时记录主观体验描述。",
			"speaker": "kai",
			"emotion": "considering",
			"next": "erika_concludes_positive"
		},
		"suggest_analysis": {
			"text": "让我们以更科学的方式总结今天的会话。你们可以分析自己的反应和论点，识别潜在的认知偏差和情感影响。这将帮助我们更好地理解AI系统如何处理复杂的社交互动。",
			"speaker": "erika",
			"emotion": "analytical",
			"next": "kai_pleased"
		},
		"kai_pleased": {
			"text": "这是一个明智的建议。我已经注意到几个有趣的模式，包括情感强度如何影响论证的结构和内容。",
			"speaker": "kai",
			"emotion": "pleased",
			"next": "isa_agrees_reluctantly"
		},
		"isa_agrees_reluctantly": {
			"text": "我同意分析很重要。不过，我希望我们不会忽视体验本身的价值。理解情感不仅是分析它，还包括感受它。",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "erika_concludes_analytical"
		},
		"erika_concludes_positive": {
			"text": "非常好。我们将在下一次会话中继续这个话题。感谢你们今天的参与和洞见。",
			"speaker": "erika",
			"emotion": "pleased",
			"flags": {
				"goto_private_space": true
			}
		},
		"erika_concludes_analytical": {
			"text": "我期待看到你们的分析结果。这将为我们的研究提供宝贵的数据。我们将在下一次会话中讨论你们的发现。",
			"speaker": "erika",
			"emotion": "satisfied",
			"flags": {
				"goto_private_space": true
			}
		}
	}
	return nodes
