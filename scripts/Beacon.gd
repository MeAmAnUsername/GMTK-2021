extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius:Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Radius_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		body.incrementBeacon()
	print("Enter", body.name)
	pass # Replace with function body.


func _on_Radius_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		body.decrementBeacon()
