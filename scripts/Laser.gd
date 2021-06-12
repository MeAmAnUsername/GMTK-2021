extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var point:Vector2

func _process(delta):
	if $LaserRayCast.is_colliding():
		point = $LaserRayCast.get_collision_point()
		$LaserBeam.points = [position, point]
		
