extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var low = 0
export (int) var high = 100

var dir:int = 2
var angle:int = low



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(angle / 180 * PI)
	angle += dir
	if angle > high or angle < low:
		dir = -dir
	
