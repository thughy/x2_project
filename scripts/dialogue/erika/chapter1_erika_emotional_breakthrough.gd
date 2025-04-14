extends Node

# 艾丽卡视角 - 第一章 - 情感突破场景
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
