extends Node2D

export (int) var top: int = 0;
export (int) var bottom: int;
export (int) var left: int = 0;
export (int) var right: int;

func _ready():
	print("Setting level sizes");
	LevelProperties.top = top;
	LevelProperties.bottom = bottom;
	LevelProperties.left = left;
	LevelProperties.right = right;
