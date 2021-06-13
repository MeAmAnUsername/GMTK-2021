extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (linear_velocity.length() > 15):
		$RollingSound.volume_db = -30 + clamp(linear_velocity.length() * 0.1, 0, 30)
	else:
		$RollingSound.volume_db = -100
	pass


func _on_Radius_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		body.incrementBeacon()
	print("Enter", body.name)
	pass # Replace with function body.


func _on_Radius_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		body.decrementBeacon()


func _on_Beacon_body_entered(body):
	if (linear_velocity.length() > 20):
		$ImpactSound.play()
	$RollingSound.play()
	
func _on_Beacon_body_exited(body):
	$RollingSound.stop()
