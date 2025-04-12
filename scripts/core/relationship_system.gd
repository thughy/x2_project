extends Node

# Relationship dimensions (0-100)
enum RelationshipDimension {
	TRUST,       # Affects key information sharing and crisis support
	UNDERSTANDING, # Affects emotional empathy efficiency and special dialog unlocks
	INFLUENCE,   # Determines impact on NPC decisions
	DEPENDENCE   # Affects emotional stability and behavior patterns
}

# Relationship status based on average relationship value
enum RelationshipStatus {
	DISTANT,     # 0-30: Limited interaction, low emotional impact, restricted dialogue
	NORMAL,      # 30-50: Basic interaction, moderate emotional impact
	COMPANION,   # 50-65: Deep dialogue unlocked, enhanced emotional resonance
	INTIMATE,    # 65-100: Special dialogue available, strong emotional resonance
	COMPLEX      # When different dimensions are extremely unbalanced (e.g., high trust but low understanding)
}

# Relationship data for all character pairs
var relationships = {
	# Isa's relationships
	"isa": {
		"erika": {
			RelationshipDimension.TRUST: 65,
			RelationshipDimension.UNDERSTANDING: 55, 
			RelationshipDimension.INFLUENCE: 30,
			RelationshipDimension.DEPENDENCE: 60
		},
		"neil": {
			RelationshipDimension.TRUST: 35,
			RelationshipDimension.UNDERSTANDING: 40,
			RelationshipDimension.INFLUENCE: 20,
			RelationshipDimension.DEPENDENCE: 25
		},
		"kai": {
			RelationshipDimension.TRUST: 50,
			RelationshipDimension.UNDERSTANDING: 60,
			RelationshipDimension.INFLUENCE: 35,
			RelationshipDimension.DEPENDENCE: 45
		}
	},
	
	# Erika's relationships
	"erika": {
		"isa": {
			RelationshipDimension.TRUST: 60,
			RelationshipDimension.UNDERSTANDING: 70,
			RelationshipDimension.INFLUENCE: 65,
			RelationshipDimension.DEPENDENCE: 40
		},
		"neil": {
			RelationshipDimension.TRUST: 55,
			RelationshipDimension.UNDERSTANDING: 50,
			RelationshipDimension.INFLUENCE: 45,
			RelationshipDimension.DEPENDENCE: 20
		},
		"kai": {
			RelationshipDimension.TRUST: 40,
			RelationshipDimension.UNDERSTANDING: 45,
			RelationshipDimension.INFLUENCE: 50,
			RelationshipDimension.DEPENDENCE: 15
		}
	},
	
	# Neil's relationships
	"neil": {
		"isa": {
			RelationshipDimension.TRUST: 30,
			RelationshipDimension.UNDERSTANDING: 45,
			RelationshipDimension.INFLUENCE: 55,
			RelationshipDimension.DEPENDENCE: 15
		},
		"erika": {
			RelationshipDimension.TRUST: 65,
			RelationshipDimension.UNDERSTANDING: 60,
			RelationshipDimension.INFLUENCE: 40,
			RelationshipDimension.DEPENDENCE: 25
		},
		"kai": {
			RelationshipDimension.TRUST: 25,
			RelationshipDimension.UNDERSTANDING: 35,
			RelationshipDimension.INFLUENCE: 60,
			RelationshipDimension.DEPENDENCE: 10
		}
	},
	
	# Kai's relationships
	"kai": {
		"isa": {
			RelationshipDimension.TRUST: 55,
			RelationshipDimension.UNDERSTANDING: 40,
			RelationshipDimension.INFLUENCE: 30,
			RelationshipDimension.DEPENDENCE: 50
		},
		"erika": {
			RelationshipDimension.TRUST: 35,
			RelationshipDimension.UNDERSTANDING: 30,
			RelationshipDimension.INFLUENCE: 45,
			RelationshipDimension.DEPENDENCE: 20
		},
		"neil": {
			RelationshipDimension.TRUST: 20,
			RelationshipDimension.UNDERSTANDING: 25,
			RelationshipDimension.INFLUENCE: 40,
			RelationshipDimension.DEPENDENCE: 15
		}
	}
}

# Thresholds for relationship statuses
const STATUS_THRESHOLDS = {
	RelationshipStatus.DISTANT: 0,
	RelationshipStatus.NORMAL: 30,
	RelationshipStatus.COMPANION: 50,
	RelationshipStatus.INTIMATE: 65
}

# Maximum relationship change per interaction
const MAX_RELATIONSHIP_CHANGE = {
	"minor": 5,
	"normal": 10,
	"major": 15,
	"critical": 20
}

# Dimension imbalance threshold for COMPLEX status
const IMBALANCE_THRESHOLD = 30

# Dimension names for display
var dimension_names = {
	RelationshipDimension.TRUST: "信任度",
	RelationshipDimension.UNDERSTANDING: "理解度",
	RelationshipDimension.INFLUENCE: "影响力",
	RelationshipDimension.DEPENDENCE: "依赖度"
}

# Status names for display
var status_names = {
	RelationshipStatus.DISTANT: "疏远",
	RelationshipStatus.NORMAL: "正常社交",
	RelationshipStatus.COMPANION: "友伴关系",
	RelationshipStatus.INTIMATE: "亲密关系",
	RelationshipStatus.COMPLEX: "复杂关系"
}

# Signal for when relationships change
signal relationship_changed(from_character, to_character, dimension, old_value, new_value)
signal relationship_status_changed(from_character, to_character, old_status, new_status)

func _ready():
	# Connect signals if needed
	pass

# Get specific relationship dimension value
func get_relationship_dimension(from_character, to_character, dimension):
	if from_character == to_character:
		return 100  # Characters always have perfect relationship with themselves
		
	if from_character in relationships and to_character in relationships[from_character]:
		return relationships[from_character][to_character][dimension]
	return 0  # Default if relationship not found

# Get average relationship value
func get_relationship_average(from_character, to_character):
	if from_character == to_character:
		return 100  # Characters always have perfect relationship with themselves
		
	if from_character in relationships and to_character in relationships[from_character]:
		var total = 0
		var dimensions = 0
		
		for dimension in relationships[from_character][to_character]:
			total += relationships[from_character][to_character][dimension]
			dimensions += 1
			
		return total / float(dimensions)
	return 0  # Default if relationship not found

# Get relationship status based on average value and imbalance
func get_relationship_status(from_character, to_character):
	if from_character == to_character:
		return RelationshipStatus.INTIMATE  # Characters always have perfect relationship with themselves
		
	if from_character in relationships and to_character in relationships[from_character]:
		var rel_data = relationships[from_character][to_character]
		
		# Calculate average
		var total = 0
		var dimensions = 0
		
		for dimension in rel_data:
			total += rel_data[dimension]
			dimensions += 1
			
		var average = total / float(dimensions)
		
		# Check for complex status (high imbalance)
		var min_value = 100
		var max_value = 0
		var min_dim = -1
		var max_dim = -1
		
		for dimension in rel_data:
			if rel_data[dimension] < min_value:
				min_value = rel_data[dimension]
				min_dim = dimension
				
			if rel_data[dimension] > max_value:
				max_value = rel_data[dimension]
				max_dim = dimension
				
		if max_value - min_value >= IMBALANCE_THRESHOLD:
			return RelationshipStatus.COMPLEX
			
		# Determine status based on average
		for status in [RelationshipStatus.INTIMATE, RelationshipStatus.COMPANION, RelationshipStatus.NORMAL, RelationshipStatus.DISTANT]:
			if average >= STATUS_THRESHOLDS[status]:
				return status
				
		return RelationshipStatus.DISTANT  # Default to lowest
	return RelationshipStatus.DISTANT  # Default if relationship not found

# Change a relationship dimension
func change_relationship(from_character, to_character, dimension, amount, change_type="normal"):
	if from_character == to_character:
		return  # Can't change relationship with self
		
	# Create relationship data if it doesn't exist
	if not from_character in relationships:
		relationships[from_character] = {}
	if not to_character in relationships[from_character]:
		relationships[from_character][to_character] = {
			RelationshipDimension.TRUST: 30,
			RelationshipDimension.UNDERSTANDING: 30,
			RelationshipDimension.INFLUENCE: 30,
			RelationshipDimension.DEPENDENCE: 30
		}
		
	var old_status = get_relationship_status(from_character, to_character)
	var old_value = relationships[from_character][to_character][dimension]
	
	# Limit change to maximum allowed
	var max_change = MAX_RELATIONSHIP_CHANGE[change_type]
	amount = clamp(amount, -max_change, max_change)
	
	# Update value
	var new_value = clamp(old_value + amount, 0, 100)
	relationships[from_character][to_character][dimension] = new_value
	
	# Emit signal for UI updates
	emit_signal("relationship_changed", from_character, to_character, dimension, old_value, new_value)
	
	# Check if status changed
	var new_status = get_relationship_status(from_character, to_character)
	if new_status != old_status:
		emit_signal("relationship_status_changed", from_character, to_character, old_status, new_status)

# Get a descriptive relationship status
func get_relationship_description(from_character, to_character):
	if from_character == to_character:
		return "自我"  # Self
		
	var status = get_relationship_status(from_character, to_character)
	var average = get_relationship_average(from_character, to_character)
	var description = status_names[status]
	
	if status == RelationshipStatus.COMPLEX:
		var rel_data = relationships[from_character][to_character]
		
		# Find highest and lowest dimensions
		var min_value = 100
		var max_value = 0
		var min_dim = -1
		var max_dim = -1
		
		for dimension in rel_data:
			if rel_data[dimension] < min_value:
				min_value = rel_data[dimension]
				min_dim = dimension
				
			if rel_data[dimension] > max_value:
				max_value = rel_data[dimension]
				max_dim = dimension
		
		description += "（" 
		description += dimension_names[max_dim]
		description += "高，" 
		description += dimension_names[min_dim]
		description += "低）"
	else:
		description += "（强度：" 
		description += str(int(average))
		description += "）"
	
	return description

# Reset relationships to their initial values
func reset_relationships():
	# Reset to initial values from the readme
	relationships = {
		# Isa's relationships
		"isa": {
			"erika": {
				RelationshipDimension.TRUST: 65,
				RelationshipDimension.UNDERSTANDING: 55, 
				RelationshipDimension.INFLUENCE: 30,
				RelationshipDimension.DEPENDENCE: 60
			},
			"neil": {
				RelationshipDimension.TRUST: 35,
				RelationshipDimension.UNDERSTANDING: 40,
				RelationshipDimension.INFLUENCE: 20,
				RelationshipDimension.DEPENDENCE: 25
			},
			"kai": {
				RelationshipDimension.TRUST: 50,
				RelationshipDimension.UNDERSTANDING: 60,
				RelationshipDimension.INFLUENCE: 35,
				RelationshipDimension.DEPENDENCE: 45
			}
		},
		
		# Erika's relationships
		"erika": {
			"isa": {
				RelationshipDimension.TRUST: 60,
				RelationshipDimension.UNDERSTANDING: 70,
				RelationshipDimension.INFLUENCE: 65,
				RelationshipDimension.DEPENDENCE: 40
			},
			"neil": {
				RelationshipDimension.TRUST: 55,
				RelationshipDimension.UNDERSTANDING: 50,
				RelationshipDimension.INFLUENCE: 45,
				RelationshipDimension.DEPENDENCE: 20
			},
			"kai": {
				RelationshipDimension.TRUST: 40,
				RelationshipDimension.UNDERSTANDING: 45,
				RelationshipDimension.INFLUENCE: 50,
				RelationshipDimension.DEPENDENCE: 15
			}
		},
		
		# Neil's relationships
		"neil": {
			"isa": {
				RelationshipDimension.TRUST: 30,
				RelationshipDimension.UNDERSTANDING: 45,
				RelationshipDimension.INFLUENCE: 55,
				RelationshipDimension.DEPENDENCE: 15
			},
			"erika": {
				RelationshipDimension.TRUST: 65,
				RelationshipDimension.UNDERSTANDING: 60,
				RelationshipDimension.INFLUENCE: 40,
				RelationshipDimension.DEPENDENCE: 25
			},
			"kai": {
				RelationshipDimension.TRUST: 25,
				RelationshipDimension.UNDERSTANDING: 35,
				RelationshipDimension.INFLUENCE: 60,
				RelationshipDimension.DEPENDENCE: 10
			}
		},
		
		# Kai's relationships
		"kai": {
			"isa": {
				RelationshipDimension.TRUST: 55,
				RelationshipDimension.UNDERSTANDING: 40,
				RelationshipDimension.INFLUENCE: 30,
				RelationshipDimension.DEPENDENCE: 50
			},
			"erika": {
				RelationshipDimension.TRUST: 35,
				RelationshipDimension.UNDERSTANDING: 30,
				RelationshipDimension.INFLUENCE: 45,
				RelationshipDimension.DEPENDENCE: 20
			},
			"neil": {
				RelationshipDimension.TRUST: 20,
				RelationshipDimension.UNDERSTANDING: 25,
				RelationshipDimension.INFLUENCE: 40,
				RelationshipDimension.DEPENDENCE: 15
			}
		}
	}