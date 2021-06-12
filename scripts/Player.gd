extends RigidBody2D

var thrust = 1000
var torque = 4000

var force = Vector2()

var thrust_charge = 0
var torque_charge = 0
var input_x : int
var input_y : int

func _init():
	angular_damp = 6.0
	linear_damp = 0.6
	gravity_scale = 3.0

func _process(delta):
	input_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	# int(Input.is_action_pressed("ui_down")) - 
	input_y = -int(Input.is_action_pressed("ui_up"))
	
	thrust_charge += delta * (1.25 if (input_y == 0) else -8.00)
	torque_charge += delta * (2.50 if (input_x == 0) else -8.00)
	thrust_charge = clamp(thrust_charge, 0, 1)
	torque_charge = clamp(torque_charge, 0, 1)
	
	gravity_scale += delta * (3.0 if (input_y == 0) else -6.0)
	gravity_scale = clamp(gravity_scale, 2.0, 5.0)
	

func _physics_process(_delta):
	pass
	
func _integrate_forces(state):
	var desired_rotation = input_x * TAU*0.25
	applied_torque = input_x * (torque + torque_charge * 8000)
	
	# Try to stay upright
	var angle_dif = (-TAU*0.25 - rotation) / (TAU*0.25)
	if (abs(angle_dif) < 1):
		applied_torque += angle_dif * 3000
	
	var total_thrust = thrust_charge * 5000 + thrust
	applied_force = Vector2(0, total_thrust * input_y).rotated(rotation + TAU*0.25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
