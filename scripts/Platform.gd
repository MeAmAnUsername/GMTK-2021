extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var rotations_per_second = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/Polygon2D.texture_scale *= self.scale
	pass # Replace with function body.

func _process(delta):
	self.rotation += delta * rotations_per_second * TAU
