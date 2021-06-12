extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius:Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = get_node("RigidBody2D/Radius")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(radius.get_overlapping_bodies())
