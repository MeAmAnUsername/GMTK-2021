extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var point:Vector2
var dist:float
var other:Object

func _process(delta):
	if $LaserRayCast.is_colliding():
		other = $LaserRayCast.get_collider()
		point = $LaserRayCast.get_collision_point()
		dist = point.distance_to(position)
		$LaserBeam.points = [Vector2.ZERO, Vector2(0, -dist)]
		if other.name == "Player":
			other.explode()
			
		
