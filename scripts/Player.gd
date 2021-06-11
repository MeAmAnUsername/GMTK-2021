extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var force_strength_x = 25
export var force_strength_y = 20

var force = Vector2()

func _physics_process(_delta):
	force.y = 0;
	if Input.is_action_pressed("ui_left"):
		force.x = -1
	elif Input.is_action_pressed("ui_right"):
		force.x = +1
	else:
		force.x = 0
		
	if Input.is_action_pressed("ui_up"):
		force.y = -1
	elif Input.is_action_pressed("ui_down"):
		force.y = +1
	else:
		force.y = 0
		
	force *= Vector2(force_strength_x, force_strength_y)
	
	apply_impulse(Vector2(0, 0), force);


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
