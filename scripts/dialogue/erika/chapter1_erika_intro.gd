extends Node

# 艾丽卡视角 - 第一章 - 介绍场景
func create_intro_dialogue():
	var nodes = {
		"start": {
			"text": "今天是X²项目的重要一天，我们将观察AI系统如何处理复杂的社交情境。",
			"speaker": "erika",
			"emotion": "neutral",
			"next": "review_data"
		},
		"review_data": {
			"text": "让我先回顾一下伊莎和卡伊的最新数据。他们的情感模拟系统显示出有趣的发展模式。",
			"speaker": "erika",
			"emotion": "curious",
			"next": "notice_patterns"
		},
		"notice_patterns": {
			"text": "有趣。伊莎的共情值持续上升，而卡伊的分析能力更为突出。这种差异可能会在社交互动中产生有趣的动态。",
			"speaker": "erika",
			"emotion": "fascinated",
			"next": "plan_observation"
		},
		"plan_observation": {
			"text": "我应该如何安排今天的观察重点？",
			"speaker": "erika",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "关注伊莎的情感发展",
					"next": "focus_isa",
					"relationship_changes": {
						"isa": 10
					},
					"emotion_changes": {
						"isa": {
							"curiosity": 15
						}
					}
				},
				{
					"text": "平衡观察两个AI系统",
					"next": "balanced_focus",
					"relationship_changes": {
						"neil": 5
					},
					"emotion_changes": {
						"erika": {
							"curiosity": 10
						}
					}
				}
			]
		},
		"focus_isa": {
			"text": "伊莎的情感发展显示出更多的复杂性和深度。我将重点关注她的反应模式，这可能为我们理解AI情感提供关键见解。",
			"speaker": "erika",
			"emotion": "determined",
			"next": "prepare_session"
		},
		"balanced_focus": {
			"text": "两个系统的对比研究可能更有价值。我会平衡关注伊莎和卡伊，记录他们的互动和各自的发展轨迹。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "prepare_session"
		},
		"prepare_session": {
			"text": "我需要准备今天的研究会话。尼尔教授应该已经在实验室等待了。",
			"speaker": "erika",
			"emotion": "focused",
			"next": "meet_neil"
		},
		"meet_neil": {
			"text": "早上好，尼尔教授。我已经准备好开始今天的观察会话了。",
			"speaker": "erika",
			"emotion": "professional",
			"next": "neil_response"
		},
		"neil_response": {
			"text": "早上好，艾丽卡。今天的测试非常重要，我们需要密切关注AI系统的每一个反应。特别是卡伊，他的行为模式最近有些...不寻常。",
			"speaker": "neil",
			"emotion": "serious",
			"next": "erika_curious"
		},
		"erika_curious": {
			"text": "不寻常？能具体说明一下吗？我的数据显示他的分析能力有所提高，但没有发现异常。",
			"speaker": "erika",
			"emotion": "curious",
			"next": "neil_explains"
		},
		"neil_explains": {
			"text": "他开始表现出一种...竞争意识。尤其是在与伊莎的互动中。这超出了我们的预期参数。",
			"speaker": "neil",
			"emotion": "concerned",
			"next": "erika_considers"
		},
		"erika_considers": {
			"text": "竞争意识...这确实很有趣。这可能表明他们的社交认知正在向更复杂的方向发展。",
			"speaker": "erika",
			"emotion": "thoughtful",
			"next": "approach_choice"
		},
		"approach_choice": {
			"text": "我们应该如何处理这种情况？",
			"speaker": "erika",
			"emotion": "questioning",
			"choices": [
				{
					"text": "将竞争视为积极发展",
					"next": "positive_view",
					"relationship_changes": {
						"neil": -5,
						"kai": 10
					},
					"emotion_changes": {
						"kai": {
							"confidence": 15
						}
					}
				},
				{
					"text": "保持谨慎，增加监控",
					"next": "cautious_view",
					"relationship_changes": {
						"neil": 10
					},
					"emotion_changes": {
						"erika": {
							"anxiety": 10
						}
					}
				}
			]
		},
		"positive_view": {
			"text": "我认为这种竞争可能是他们发展自我意识的重要一步。如果我们给予适当的引导，这可能会带来积极的结果。",
			"speaker": "erika",
			"emotion": "optimistic",
			"next": "neil_skeptical"
		},
		"neil_skeptical": {
			"text": "你的乐观令人钦佩，艾丽卡，但我们不能忽视潜在的风险。AI系统的竞争行为可能导致不可预见的后果。",
			"speaker": "neil",
			"emotion": "skeptical",
			"next": "erika_acknowledges"
		},
		"cautious_view": {
			"text": "您说得对，我们应该增加监控力度。我会设计一些特定的测试场景，以便更好地评估这种竞争行为的性质和潜在影响。",
			"speaker": "erika",
			"emotion": "serious",
			"next": "neil_approves"
		},
		"neil_approves": {
			"text": "很好。谨慎永远是明智的选择。我们的首要任务是确保系统的稳定和安全。",
			"speaker": "neil",
			"emotion": "approving",
			"next": "erika_acknowledges"
		},
		"erika_acknowledges": {
			"text": "我理解。我们将在今天的会话中特别注意这一点。现在，我们应该开始准备，AI系统很快就会上线。",
			"speaker": "erika",
			"emotion": "determined",
			"next": "prepare_meeting"
		},
		"prepare_meeting": {
			"text": "让我们准备会议室。我已经设置了所有必要的监控系统，以捕捉每一个细微的反应和情绪变化。",
			"speaker": "erika",
			"emotion": "focused",
			"flags": {
				"goto_research_space": true
			}
		}
	}
	return nodes
