extends Camera2D

func _ready():
	print("Setting camera limits");
	if LevelProperties.bottom == 0:
		push_warning("PlayerCamera: LevelProperties may not have been set yet. Load a LevelPropertiesRegisterer before the Player");
	limit_top    = LevelProperties.top;
	limit_bottom = LevelProperties.bottom;
	limit_left   = LevelProperties.left;
	limit_right  = LevelProperties.right;
