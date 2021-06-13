extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var low = 270
export (float) var high = 280

var dir:float = 0.2
var angle:float

func _ready():
	rotate(low / 180 * PI)
	angle = low



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(dir / 180 * PI)
	angle += dir
	if angle > high or angle < low:
		dir = -dir
