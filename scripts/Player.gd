extends RigidBody2D

var thrust = 2000
var torque = 4000

var force = Vector2()

func _init():
	angular_damp = 4
	linear_damp = 2.5

func _physics_process(_delta):
	pass
	
func _integrate_forces(state):
	force.y = 0;
	
	var rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
		
	if Input.is_action_pressed("ui_up"):
		force.y = -1
	elif Input.is_action_pressed("ui_down"):
		force.y = +1
	else:
		force.y = 0
	
	var desired_rotation = rotation_dir * TAU*0.25
	
	applied_torque = rotation_dir * torque
	applied_force = thrust * Vector2(0, force.y).rotated(rotation + TAU*0.25)

	#transform.get_rotation()
	#apply_impulse(Vector2(0, 0), force);
	#apply_torque_impulse()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
