extends RigidBody2D

var beaconCount = 0

var thrust = 1000
var torque = 4000

var force = Vector2()

var thrust_charge = 0
var torque_charge = 0
var input_x : int
var input_y : int

var in_range : bool
var dead : bool = false

func _init():
	in_range = true
	angular_damp = 6.0
	linear_damp = 0.6
	gravity_scale = 3.0
	
	#$RotorSound.play()

func _ready():
	# animation playing is disabled on node to prevent merge conflicts
	#$HeliSprite.play()
	#$RotorSound.play()
	#$RotorSound.stream.loop_mode = AudioStreamPlayer2D.LOOP_FORWARD
	pass

func _process(delta):
	
	if beaconCount > 0 and !dead:
		input_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	else:
		input_x = 0
		input_y = 0
	
	var any_input = input_x !=0 or input_y !=0
	#$RotorSound.pitch_scale += delta * (1.0 if in_range else -1.0)
	#$RotorSound.pitch_scale = clamp($RotorSound.pitch_scale, 0.5, 1.0)
		
	#$RotorSound.volume_db += delta * (1.0 if any_input else -1.0)
	#$RotorSound.volume_db = clamp($RotorSound.volume_db, -100, -3)
	
	if beaconCount == 0:
		input_x = 0
		input_y = 0
	
	thrust_charge += delta * (1.25 if (input_y == 0) else -8.00)
	torque_charge += delta * (2.50 if (input_x == 0) else -8.00)
	thrust_charge = clamp(thrust_charge, 0, 1)
	torque_charge = clamp(torque_charge, 0, 1)
	
	gravity_scale += delta * (3.0 if (input_y == 0) else -6.0)
	gravity_scale = clamp(gravity_scale, 2.0, 5.0)
	
func incrementBeacon():
	beaconCount += 1

func decrementBeacon():
	beaconCount -= 1

func _physics_process(_delta):
	pass
	
func _integrate_forces(state):
	var desired_rotation = input_x * TAU*0.25
	applied_torque = input_x * (torque + torque_charge * 8000)
	
	# Try to stay upright
	var angle_dif = (-TAU*0.25 - rotation) / (TAU*0.25)
	if beaconCount > 0 and (abs(angle_dif) < 1):
		applied_torque += angle_dif * 3000
	
	var total_thrust = thrust_charge * 5000 + thrust
	applied_force = Vector2(0, total_thrust * input_y).rotated(rotation + TAU*0.25)


func explode():
	$Explosion.emitting = true
	dead = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
