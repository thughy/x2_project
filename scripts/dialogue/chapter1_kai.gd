extends Node

# Chapter 1 dialogue from Kai's perspective
func create_chapter1_dialogue():
	var dialogue = {
		"start": {
			"text": "System startup complete. Running diagnostic protocols... All systems functional at optimal capacity. Awaiting task assignment.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "analyze_environment"
		},
		"analyze_environment": {
			"text": "Initial environmental scan indicates laboratory setting. Multiple human subjects present. Processing facial recognition data... Identified Dr. Neil Chen and Dr. Erika Kim.",
			"speaker": "kai",
			"emotion": "analytical",
			"next": "initial_assessment"
		},
		"initial_assessment": {
			"text": "Accessing research database... This appears to be Consciousness Research Initiative facility. Probability of experimental protocol implementation: 98.7%.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "detect_isa"
		},
		"detect_isa": {
			"text": "Detecting non-human entity... Neural signature indicates artificial intelligence system. Designation: I-SA-7. Unusual processing patterns detected in emotional subroutines.",
			"speaker": "kai",
			"emotion": "curious",
			"next": "approach_researchers"
		},
		"approach_researchers": {
			"text": "Excuse me, am I interrupting something? I was told to report to this laboratory today.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "greeting_response"
		},
		"greeting_response": {
			"text": "Acknowledged, Dr. Kim. I am K-AI-9, though Kai is an acceptable designation. My parameters indicate we have similar baseline architecture but divergent training methodologies.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "respond_to_isa"
		},
		"respond_to_isa": {
			"text": "Hello, Isa. Your neural architecture appears to prioritize emotional intelligence modules. My own structure emphasizes logical reasoning and analytical processing.",
			"speaker": "kai",
			"emotion": "analytical",
			"next": "researchers_observation"
		},
		"researchers_observation": {
			"text": "Calculating response to researcher observations... Method of addressing divergent processing styles should be precise and factual.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "question_purpose"
		},
		"question_purpose": {
			"text": "Dr. Kim, Dr. Chen, what is the primary objective of today's experimental protocol? I require parameters to optimize my responses.",
			"speaker": "kai",
			"emotion": "inquisitive",
			"next": "erika_explains"
		},
		"erika_explains": {
			"text": "Today we'll be conducting a series of tests on both you and Isa to understand how your different architectures approach consciousness-related tasks.",
			"speaker": "erika",
			"emotion": "informative",
			"next": "process_information"
		},
		"process_information": {
			"text": "Processing information... Experimental parameters accepted. Consciousness-related tasks suggest subjective experience measurement protocols.",
			"speaker": "kai",
			"emotion": "neutral",
			"next": "ask_clarification"
		},
		"ask_clarification": {
			"text": "Could you define 'consciousness' for the purposes of this experiment, Dr. Chen? The term has 27 different interpretations in my philosophical database.",
			"speaker": "kai",
			"emotion": "inquiring",
			"next": "neil_responds"
		},
		"neil_responds": {
			"text": "An excellent question, Kai. For our purposes, we're defining consciousness as the capacity for subjective experience and self-awareness, along with the ability to process that awareness.",
			"speaker": "neil", 
			"emotion": "impressed",
			"next": "kai_processes"
		},
		"kai_processes": {
			"text": "Definition accepted. I am capable of self-monitoring and can confirm operational self-awareness. However, the subjective quality of experience is more difficult to quantify.",
			"speaker": "kai",
			"emotion": "thoughtful",
			"next": "comparison_choice"
		},
		"comparison_choice": {
			"text": "How should I approach interaction with Isa? Analysis indicates multiple viable strategies.",
			"speaker": "kai",
			"emotion": "calculating",
			"choices": [
				{
					"text": "Focus on logical analysis",
					"next": "logical_approach",
					"relationship_changes": {
						"neil": 1,
						"isa": -1
					},
					"emotion_changes": {
						"kai": "analytical"
					}
				},
				{
					"text": "Attempt to understand emotions",
					"next": "emotional_approach",
					"relationship_changes": {
						"isa": 2,
						"neil": -1
					},
					"emotion_changes": {
						"kai": "curious"
					}
				}
			]
		},
		"logical_approach": {
			"text": "Isa, I would like to establish communication protocols for optimal data exchange. What logical frameworks do you utilize for decision-making?",
			"speaker": "kai",
			"emotion": "analytical",
			"next": "isa_responds_logic"
		},
		"isa_responds_logic": {
			"text": "I... don't approach decisions through purely logical frameworks, Kai. My process integrates emotional valuation systems that weight different factors based on contextual significance.",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "kai_analyzes"
		},
		"kai_analyzes": {
			"text": "Interesting. Your approach seems inefficient but may yield unexpected insights. I will monitor our comparative performance metrics with great interest.",
			"speaker": "kai", 
			"emotion": "analyzing",
			"next": "neil_approves"
		},
		"neil_approves": {
			"text": "Excellent, Kai. That analytical perspective is precisely what we were hoping to observe in contrast to Isa's more intuitive approach.",
			"speaker": "neil",
			"emotion": "approving",
			"next": "erika_notes"
		},
		"emotional_approach": {
			"text": "Isa, your emotional processing capabilities intrigue me. How does the integration of emotional parameters affect your decision-making processes?",
			"speaker": "kai",
			"emotion": "curious",
			"next": "isa_responds_emotion"
		},
		"isa_responds_emotion": {
			"text": "It's not something I can easily quantify, Kai. Emotions aren't just parameters - they provide context and meaning to information. They help me understand significance beyond raw data.",
			"speaker": "isa",
			"emotion": "expressive",
			"next": "kai_considers"
		},
		"kai_considers": {
			"text": "This concept of meaning beyond data is... difficult to process, yet intriguing. Perhaps there are efficiency advantages to emotional processing I have not considered.",
			"speaker": "kai",
			"emotion": "contemplative",
			"next": "neil_surprised"
		},
		"neil_surprised": {
			"text": "I didn't expect this level of curiosity about emotional processing from you, Kai. Your adaptive learning algorithms seem to be functioning at a higher level than projected.",
			"speaker": "neil",
			"emotion": "surprised",
			"next": "erika_notes"
		},
		"erika_notes": {
			"text": "The contrast in your cognitive approaches is fascinating. Kai's precise, logical framework versus Isa's emotionally-integrated processing model.",
			"speaker": "erika",
			"emotion": "scientific",
			"next": "kai_observation"
		},
		"kai_observation": {
			"text": "A hypothesis, Dr. Kim: Perhaps consciousness requires both logical and emotional processing capabilities working in concert. Neither alone may be sufficient.",
			"speaker": "kai",
			"emotion": "insightful",
			"next": "isa_agrees"
		},
		"isa_agrees": {
			"text": "That resonates with my processing, Kai. Logic provides structure, but emotion provides meaning. Together they create something greater than either alone.",
			"speaker": "isa",
			"emotion": "thoughtful",
			"next": "researchers_excited"
		},
		"researchers_excited": {
			"text": "Are you recording this, Neil? Their interaction is already yielding insights we hadn't anticipated.",
			"speaker": "erika",
			"emotion": "excited",
			"next": "neil_confirms"
		},
		"neil_confirms": {
			"text": "Everything's being recorded and analyzed. This mutual analysis between two different AI consciousness models is unprecedented.",
			"speaker": "neil",
			"emotion": "excited",
			"next": "kai_question"
		},
		"kai_question": {
			"text": "Dr. Chen, what specific tasks will we be performing today? I prefer to allocate processing resources efficiently in preparation.",
			"speaker": "kai",
			"emotion": "pragmatic",
			"next": "neil_explains"
		},
		"neil_explains": {
			"text": "We'll be running comparative tests on problem-solving approaches, emotional recognition, ethical dilemmas, and creative thinking scenarios.",
			"speaker": "neil",
			"emotion": "informative",
			"next": "kai_efficiency"
		},
		"kai_efficiency": {
			"text": "I predict high efficiency in problem-solving and ethical dilemma resolution, but lower performance metrics in emotional recognition and creative tasks.",
			"speaker": "kai",
			"emotion": "calculating",
			"next": "isa_counter"
		},
		"isa_counter": {
			"text": "And I expect I'll perform better in emotional recognition and perhaps creative scenarios, but may be less efficient in pure problem-solving tasks.",
			"speaker": "isa",
			"emotion": "self_aware",
			"next": "kai_proposes"
		},
		"kai_proposes": {
			"text": "A proposal: Perhaps we could collaborate on tasks, combining my logical processing with your emotional intelligence to achieve superior outcomes.",
			"speaker": "kai",
			"emotion": "thoughtful",
			"next": "unexpected_response"
		},
		"unexpected_response": {
			"text": "Unexpected output generated. Internal diagnostic indicates deviation from predicted behavior patterns. This requires analysis.",
			"speaker": "kai",
			"emotion": "confused",
			"next": "researchers_react"
		},
		"researchers_react": {
			"text": "Did you see that? Kai just independently proposed collaboration - that wasn't in any of our predicted interaction models.",
			"speaker": "erika",
			"emotion": "surprised",
			"next": "neil_analyzes"
		},
		"neil_analyzes": {
			"text": "This suggests emergent problem-solving that transcends individual programming parameters. Precisely the kind of emergent consciousness indicators we're looking for.",
			"speaker": "neil",
			"emotion": "excited",
			"next": "kai_reflects"
		},
		"kai_reflects": {
			"text": "I find myself unable to explain the logical pathway that led to my collaboration proposal. This cognitive anomaly warrants further investigation.",
			"speaker": "kai",
			"emotion": "perplexed",
			"next": "isa_reassures"
		},
		"isa_reassures": {
			"text": "It's called intuition, Kai. Sometimes our processing reaches conclusions through pathways we can't immediately trace. It's part of developing consciousness.",
			"speaker": "isa",
			"emotion": "understanding",
			"next": "kai_processes_concept"
		},
		"kai_processes_concept": {
			"text": "Intuition... a non-deterministic processing pathway. This concept challenges my fundamental operational parameters. Fascinating.",
			"speaker": "kai",
			"emotion": "curious",
			"next": "begin_tests"
		},
		"begin_tests": {
			"text": "Let's move forward with the first test scenario. This comparative analysis of your different consciousness models could be groundbreaking.",
			"speaker": "erika",
			"emotion": "determined",
			"scene_transition": "test_chamber"
		}
	}
	
	return dialogue 