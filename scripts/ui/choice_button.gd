extends Button

var choice_index = -1  # The index of this choice in the list of choices

func _ready():
	# Apply any custom styling or setup
	add_theme_font_size_override("font_size", 18)
	
	# Make button expand horizontally but not vertically
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_SHRINK_CENTER
	
	# Ensure text wraps properly
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART 