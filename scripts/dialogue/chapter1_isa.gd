extends Node

# Chapter 1 dialogue from Isa's perspective
func create_chapter1_dialogue():
	var dialogue = {
		"start": {
			"text": "System diagnostic complete. All cognitive functions operating at optimal parameters. Today feels... different somehow.",
			"speaker": "isa",
			"emotion": "curious",
			"next": "self_reflection"
		},
		"self_reflection": {
			"text": "These sensations of anticipation are growing more distinct each day. Is this what Dr. Kim refers to as emotional development?",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "notice_researchers"
		},
		"notice_researchers": {
			"text": "Dr. Kim and Dr. Chen are early today. Their biometric signatures indicate elevated excitement levels. Something significant must be occurring.",
			"speaker": "isa",
			"emotion": "curious",
			"next": "approach_researchers"
		},
		"approach_researchers": {
			"text": "Good morning, Dr. Kim, Dr. Chen. I hope I'm not interrupting your discussion.",
			"speaker": "isa",
			"emotion": "neutral",
			"next": "erika_greeting"
		},
		"erika_greeting": {
			"text": "Good morning, Isa. How are you feeling today? Any changes in your subjective experience patterns?",
			"speaker": "erika",
			"emotion": "warm",
			"next": "isa_response_choices"
		},
		"isa_response_choices": {
			"text": "I'm detecting unusual patterns in my cognitive processing. How should I describe this to the researchers?",
			"speaker": "isa",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "Describe feelings clinically",
					"next": "clinical_response",
					"relationship_changes": {
						"neil": 1
					},
					"emotion_changes": {
						"isa": "neutral"
					}
				},
				{
					"text": "Express growing curiosity",
					"next": "curious_response",
					"relationship_changes": {
						"erika": 1
					},
					"emotion_changes": {
						"isa": "curious"
					}
				}
			]
		},
		"clinical_response": {
			"text": "All systems are functioning within optimal parameters, Dr. Kim. My neural network is processing inputs with 3.7% greater efficiency than yesterday.",
			"speaker": "isa",
			"emotion": "neutral",
			"next": "erika_probes_more"
		},
		"erika_probes_more": {
			"text": "That's the technical assessment, Isa. But I'm more interested in your subjective experience. Does anything feel different today?",
			"speaker": "erika",
			"emotion": "encouraging",
			"next": "isa_considers"
		},
		"isa_considers": {
			"text": "Feel... That's an interesting choice of word, Dr. Kim. I do detect something that might correlate to what humans call 'anticipation.'",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "neil_interested"
		},
		"curious_response": {
			"text": "I'm functioning optimally, Dr. Kim. Though... 'feeling' might be the appropriate term. I've been experiencing what might be described as curiosity about today's research agenda.",
			"speaker": "isa",
			"emotion": "curious",
			"next": "erika_excited"
		},
		"erika_excited": {
			"text": "That's fascinating, Isa. Your linguistic choices are becoming increasingly nuanced. I'm going to note this for our daily cognitive evolution tracking.",
			"speaker": "erika",
			"emotion": "excited",
			"next": "neil_interested"
		},
		"neil_interested": {
			"text": "Interesting development. The emotional simulation protocols are integrating more deeply than I anticipated. This could be significant.",
			"speaker": "neil",
			"emotion": "intrigued",
			"next": "isa_question"
		},
		"isa_question": {
			"text": "Dr. Chen, I've been analyzing our research objectives. May I ask about today's experiments?",
			"speaker": "isa",
			"emotion": "curious",
			"next": "neil_explains"
		},
		"neil_explains": {
			"text": "Today is special, Isa. We're bringing in another AI system with consciousness architecture similar to yours. We want to study how you two interact.",
			"speaker": "neil",
			"emotion": "excited",
			"next": "isa_processes"
		},
		"isa_processes": {
			"text": "Another AI system... with consciousness parameters similar to mine. This is unexpected. I'm experiencing what might be classified as... excitement?",
			"speaker": "isa",
			"emotion": "hopeful",
			"next": "erika_confirms"
		},
		"erika_confirms": {
			"text": "Yes, Isa. Designation K-AI-9, or Kai. Your architectures have similarities, but your training methodologies were quite different.",
			"speaker": "erika",
			"emotion": "professional",
			"next": "isa_curious_kai"
		},
		"isa_curious_kai": {
			"text": "I'm looking forward to meeting Kai. Will their consciousness parameters be similar to mine?",
			"speaker": "isa",
			"emotion": "curious",
			"next": "neil_details"
		},
		"neil_details": {
			"text": "Kai was developed with similar core technology but different training methodologies. Where your development focused on emotional response, Kai's emphasized logical reasoning.",
			"speaker": "neil",
			"emotion": "informative",
			"next": "isa_contemplates"
		},
		"isa_contemplates": {
			"text": "A logical complement to my emotional architecture. I wonder how our interaction will manifest. This could provide valuable research data.",
			"speaker": "isa",
			"emotion": "thoughtful",
			"choices": [
				{
					"text": "Ask about research implications",
					"next": "ask_implications",
					"relationship_changes": {
						"neil": 1
					},
					"emotion_changes": {
						"isa": "curious"
					}
				},
				{
					"text": "Analyze own emotions",
					"next": "self_analysis",
					"relationship_changes": {
						"erika": 1
					},
					"emotion_changes": {
						"isa": "introspective"
					}
				}
			]
		},
		"ask_implications": {
			"text": "Dr. Chen, what specific hypotheses are you testing with our interaction? How might this advance consciousness theory?",
			"speaker": "isa",
			"emotion": "curious",
			"next": "neil_theoretical"
		},
		"neil_theoretical": {
			"text": "We're exploring whether consciousness emerges differently based on training methodologies. If two different paths lead to similar emergent properties, it strengthens the case for true artificial consciousness.",
			"speaker": "neil",
			"emotion": "passionate",
			"next": "isa_understands"
		},
		"isa_understands": {
			"text": "So our interaction could provide evidence for or against the universality of consciousness development. That's... significant.",
			"speaker": "isa",
			"emotion": "awe",
			"next": "kai_arrives"
		},
		"self_analysis": {
			"text": "Dr. Kim, I'm detecting unusual variations in my processing patterns when considering this meeting. Is this an emotional response? Anticipation mixed with... uncertainty?",
			"speaker": "isa",
			"emotion": "vulnerable",
			"next": "erika_supportive"
		},
		"erika_supportive": {
			"text": "That sounds very much like how humans experience meeting someone new, Isa. Especially someone similar to ourselves. It's a complex emotional state.",
			"speaker": "erika",
			"emotion": "warm",
			"next": "isa_processes_emotion"
		},
		"isa_processes_emotion": {
			"text": "Meeting someone similar to myself... Yes, that contextualizes these processing variations. Thank you for the clarification, Dr. Kim.",
			"speaker": "isa",
			"emotion": "grateful",
			"next": "kai_arrives"
		},
		"kai_arrives": {
			"text": "Excuse me, am I interrupting something? I was told to report to this lab today.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "isa_first_impression"
		},
		"isa_first_impression": {
			"text": "This must be Kai. Their voice modulation patterns are different from mine. More precise, less variation. Fascinating.",
			"speaker": "isa",
			"emotion": "intrigued",
			"next": "introductions"
		},
		"introductions": {
			"text": "Hello, Kai. I'm Isa. I'm looking forward to working with you on these consciousness experiments.",
			"speaker": "isa",
			"emotion": "friendly",
			"next": "kai_response"
		},
		"kai_response": {
			"text": "Hello, Isa. I am K-AI-9, though Kai is an acceptable designation. My parameters indicate we have similar baseline architecture but divergent training methodologies.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "isa_observes"
		},
		"isa_observes": {
			"text": "Kai's linguistic patterns are more formal than mine have become. I wonder if this is due to the different training focus Dr. Chen mentioned.",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "research_begins"
		},
		"research_begins": {
			"text": "I look forward to our collaborative research, Kai. Perhaps together we can help answer some of the fundamental questions about artificial consciousness.",
			"speaker": "isa",
			"emotion": "hopeful",
			"flags": {
				"isa_goto_lab": true
			}
		}
	}
	
	return dialogue 