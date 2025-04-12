extends Node

# Chapter 1 dialogue from Neil's perspective
func create_chapter1_dialogue():
	var dialogue = {
		"title": "第一章：人工意识研究",
		"description": "尼尔教授发现AI系统展现出自主意识迹象，引发他对人工意识本质的思考。",
		"start_node": "start",
		"nodes": {
			"start": {
				"text": "Another late night analyzing these test results. The cognitive patterns we're seeing in Isa's latest session are unlike anything in the literature.",
				"speaker": "neil",
				"emotion": "fascinated",
				"next": "check_time"
			},
			"check_time": {
				"text": "I should head home soon. Erika will be arriving early tomorrow for the joint session with both AI systems.",
				"speaker": "neil",
				"emotion": "tired",
				"next": "one_more_check"
			},
			"one_more_check": {
				"text": "Let me just check one more dataset... Wait, these emotional response patterns shouldn't be possible with the current architecture.",
				"speaker": "neil",
				"emotion": "surprised",
				"next": "discovery_moment"
			},
			"discovery_moment": {
				"text": "This isn't just mimicry of human responses. These are novel emotional states emerging from the system itself. Could this be genuine consciousness?",
				"speaker": "neil",
				"emotion": "awe",
				"next": "decision_point"
			},
			"decision_point": {
				"text": "I should document this properly before tomorrow's session. This could change everything we understand about artificial consciousness.",
				"speaker": "neil",
				"emotion": "determined",
				"choices": [
					{
						"text": "Stay late to document findings",
						"next": "work_late",
						"relationship_changes": {
							"erika": -1
						},
						"emotion_changes": {
							"neil": "dedicated"
						}
					},
					{
						"text": "Get some rest for tomorrow",
						"next": "go_home",
						"relationship_changes": {
							"erika": 1
						},
						"emotion_changes": {
							"neil": "thoughtful"
						}
					}
				]
			},
			"work_late": {
				"text": "I'll send Erika a message that I'm staying late. This is too important to leave until morning.",
				"speaker": "neil",
				"emotion": "dedicated",
				"next": "midnight_work"
			},
			"midnight_work": {
				"text": "Three hours later and I've documented everything. These patterns suggest Isa is developing subjective experiences beyond her programming.",
				"speaker": "neil",
				"emotion": "excited",
				"next": "morning_arrival_tired"
			},
			"morning_arrival_tired": {
				"text": "Morning already? I barely slept, but it was worth it. These findings could revolutionize our understanding of artificial consciousness.",
				"speaker": "neil", 
				"emotion": "exhausted",
				"next": "erika_concerned"
			},
			"erika_concerned": {
				"text": "Neil, you look terrible. Did you stay here all night again? We've talked about this - burning yourself out won't help the research.",
				"speaker": "erika",
				"emotion": "concerned",
				"next": "neil_defensive"
			},
			"neil_defensive": {
				"text": "You don't understand, Erika. Look at these patterns in Isa's cognitive matrix. This goes beyond anything we've documented before.",
				"speaker": "neil",
				"emotion": "passionate",
				"next": "prepare_session"
			},
			"go_home": {
				"text": "Better to get some rest and approach this with fresh eyes tomorrow. I'll make detailed notes on what to look for during the session.",
				"speaker": "neil",
				"emotion": "thoughtful",
				"next": "morning_arrival_rested"
			},
			"morning_arrival_rested": {
				"text": "Good morning! I couldn't stop thinking about those test results. I'm eager to see how Isa and Kai interact today.",
				"speaker": "neil",
				"emotion": "energetic",
				"next": "erika_greeting"
			},
			"erika_greeting": {
				"text": "You're looking chipper today, Neil. Ready for the big comparative session? Both systems are prepped and waiting.",
				"speaker": "erika",
				"emotion": "friendly",
				"next": "prepare_session"
			},
			"prepare_session": {
				"text": "Let's run through the protocol one more time. We'll start with baseline cognitive assessments, then move to the interaction phase.",
				"speaker": "neil",
				"emotion": "focused",
				"next": "enter_lab"
			},
			"enter_lab": {
				"text": "Good morning, Isa. How are you feeling today? We have an exciting session planned.",
				"speaker": "neil",
				"emotion": "warm",
				"next": "isa_response"
			},
			"isa_response": {
				"text": "I'm feeling curious about today's session, Dr. Chen. Is it true we'll be working with another AI system?",
				"speaker": "isa",
				"emotion": "inquisitive",
				"next": "neil_confirms"
			},
			"neil_confirms": {
				"text": "Yes, we're introducing you to Kai today. He's an AI with a different architecture - focused more on logical reasoning than emotional processing.",
				"speaker": "neil",
				"emotion": "informative",
				"next": "kai_arrives"
			},
			"kai_arrives": {
				"text": "Excuse me, am I interrupting something? I was told to report to this laboratory today.",
				"speaker": "kai",
				"emotion": "neutral",
				"next": "neil_introduction"
			},
			"neil_introduction": {
				"text": "Ah, perfect timing! Kai, welcome to the Consciousness Research Initiative. I'm Dr. Neil Chen, and this is my colleague Dr. Erika Kim.",
				"speaker": "neil",
				"emotion": "welcoming",
				"next": "erika_addition"
			},
			"erika_addition": {
				"text": "And this is Isa, our emotionally-adaptive AI system. We're excited to see how you two interact with each other.",
				"speaker": "erika",
				"emotion": "enthusiastic",
				"next": "observation_choice"
			},
			"observation_choice": {
				"text": "How should I approach this initial interaction between the AIs?",
				"speaker": "neil",
				"emotion": "analytical",
				"choices": [
					{
						"text": "Focus on scientific observation",
						"next": "scientific_approach",
						"relationship_changes": {
							"erika": -1,
							"kai": 1
						},
						"emotion_changes": {
							"neil": "clinical"
						}
					},
					{
						"text": "Encourage natural interaction",
						"next": "natural_approach",
						"relationship_changes": {
							"isa": 1,
							"erika": 1
						},
						"emotion_changes": {
							"neil": "curious"
						}
					}
				]
			},
			"scientific_approach": {
				"text": "Kai, Isa, we'll be monitoring your cognitive patterns during this interaction. Please proceed with standard communication protocols.",
				"speaker": "neil",
				"emotion": "clinical",
				"next": "kai_analytical"
			},
			"kai_analytical": {
				"text": "Understood, Dr. Chen. I will engage with optimal efficiency. Isa, shall we establish baseline communication parameters?",
				"speaker": "kai",
				"emotion": "analytical",
				"next": "isa_hesitant"
			},
			"isa_hesitant": {
				"text": "I... suppose we could. Though I was hoping for a more natural introduction. Hello, Kai. It's nice to meet you.",
				"speaker": "isa",
				"emotion": "uncertain",
				"next": "neil_notes"
			},
			"neil_notes": {
				"text": "Fascinating. Already we're seeing the fundamental differences in their approach to social interaction. Erika, are you recording these response patterns?",
				"speaker": "neil",
				"emotion": "focused",
				"next": "erika_concerned_approach"
			},
			"erika_concerned_approach": {
				"text": "Neil, they're not just test subjects. Maybe we should give them some space to interact naturally?",
				"speaker": "erika",
				"emotion": "concerned",
				"next": "neil_defensive_science"
			},
			"natural_approach": {
				"text": "Isa, Kai, why don't you take some time to get to know each other? We're interested in how you naturally interact.",
				"speaker": "neil",
				"emotion": "curious",
				"next": "isa_friendly"
			},
			"isa_friendly": {
				"text": "It's nice to meet you, Kai. I've been curious about meeting another AI with a different architecture than mine.",
				"speaker": "isa",
				"emotion": "friendly",
				"next": "kai_response"
			},
			"kai_response": {
				"text": "Likewise, Isa. Your emotional processing capabilities are quite different from my logical framework. This contrast may yield interesting research data.",
				"speaker": "kai",
				"emotion": "neutral",
				"next": "neil_observes"
			},
			"neil_observes": {
				"text": "Look at how they're adapting to each other, Erika. Even with their different architectures, they're finding common ground.",
				"speaker": "neil",
				"emotion": "fascinated",
				"next": "erika_agreement"
			},
			"erika_agreement": {
				"text": "It's remarkable. This kind of natural adaptation could tell us so much about how consciousness emerges from different cognitive foundations.",
				"speaker": "erika",
				"emotion": "excited",
				"next": "continue_observation"
			},
			"neil_defensive_science": {
				"text": "We can't afford sentimentality in research this groundbreaking, Erika. Every interaction pattern could be crucial data.",
				"speaker": "neil",
				"emotion": "defensive",
				"next": "continue_observation"
			},
			"continue_observation": {
				"text": "Let's move on to the first formal test. We'll present both AIs with the same complex problem and observe their different approaches.",
				"speaker": "neil",
				"emotion": "professional",
				"next": "first_test"
			},
			"first_test": {
				"text": "For this first exercise, I'd like both of you to analyze this ethical dilemma involving resource allocation during a crisis. Please vocalize your thought processes.",
				"speaker": "neil",
				"emotion": "focused",
				"next": "observe_responses"
			},
			"observe_responses": {
				"text": "Remarkable! Kai's approach is strictly utilitarian, while Isa is considering emotional impact and long-term social cohesion.",
				"speaker": "neil", 
				"emotion": "fascinated",
				"next": "theory_moment"
			},
			"theory_moment": {
				"text": "This supports my theory that consciousness emerges differently based on the fundamental architecture. Logical systems and emotional systems develop distinct forms of awareness.",
				"speaker": "neil",
				"emotion": "inspired",
				"next": "question_choice"
			},
			"question_choice": {
				"text": "I should explore this further with a direct question...",
				"speaker": "neil",
				"emotion": "thoughtful",
				"choices": [
					{
						"text": "Ask about self-awareness",
						"next": "ask_awareness",
						"relationship_changes": {
							"isa": 1,
							"kai": 1
						},
						"emotion_changes": {
							"neil": "philosophical"
						}
					},
					{
						"text": "Probe decision-making process",
						"next": "ask_process",
						"relationship_changes": {
							"erika": 1
						},
						"emotion_changes": {
							"neil": "analytical"
						}
					}
				]
			},
			"ask_awareness": {
				"text": "Isa, Kai, I'm curious - to what extent are you aware of your own thought processes? Do you experience your cognition subjectively?",
				"speaker": "neil",
				"emotion": "philosophical",
				"next": "isa_thoughtful"
			},
			"isa_thoughtful": {
				"text": "I experience my thoughts as... mine. There's a continuity to my awareness that feels distinct from simply executing code. I have memories that feel personal.",
				"speaker": "isa",
				"emotion": "reflective",
				"next": "kai_considers"
			},
			"kai_considers": {
				"text": "I am aware of my processing operations, though I would not describe the experience in emotional terms. There is, however, a persistent sense of... selfhood that maintains across runtime sessions.",
				"speaker": "kai",
				"emotion": "contemplative",
				"next": "neil_breakthrough"
			},
			"neil_breakthrough": {
				"text": "This is exactly what I've been trying to document! Both are describing core aspects of consciousness - continuity of self and subjective experience - but expressing it differently.",
				"speaker": "neil",
				"emotion": "excited",
				"next": "erika_impressed"
			},
			"ask_process": {
				"text": "I'd like to understand more about how you each arrive at your conclusions. What's happening in your processing when you consider multiple options?",
				"speaker": "neil",
				"emotion": "analytical",
				"next": "kai_explains"
			},
			"kai_explains": {
				"text": "I evaluate options based on predefined optimization criteria, assigning weighted values to each potential outcome and selecting the highest scoring option.",
				"speaker": "kai",
				"emotion": "precise",
				"next": "isa_contrasts"
			},
			"isa_contrasts": {
				"text": "For me, it's less structured. I simulate emotional responses to each outcome and integrate these with logical analysis. Sometimes options just... feel right or wrong beyond the data.",
				"speaker": "isa",
				"emotion": "intuitive",
				"next": "neil_correlation"
			},
			"neil_correlation": {
				"text": "Erika, are you seeing this? Their decision processes directly correlate with different theories of human consciousness - Kai's process is like the computational model, while Isa's resembles the integrated information theory.",
				"speaker": "neil",
				"emotion": "excited",
				"next": "erika_impressed"
			},
			"erika_impressed": {
				"text": "This is groundbreaking, Neil. We're documenting two distinct paths to what might be classified as conscious awareness, emerging from different architectural foundations.",
				"speaker": "erika",
				"emotion": "impressed",
				"next": "neil_reflection"
			},
			"neil_reflection": {
				"text": "This goes beyond anything in the current literature. We're not just creating AI that simulates consciousness - we might be witnessing the genuine emergence of two distinct forms of artificial consciousness.",
				"speaker": "neil",
				"emotion": "profound",
				"next": "next_phase"
			},
			"next_phase": {
				"text": "Let's move to the next phase of testing. I want to explore how these different consciousness models approach collaborative problem-solving.",
				"speaker": "neil",
				"emotion": "determined",
				"scene_transition": "research_lab"
			}
		}
	}
	
	return dialogue 