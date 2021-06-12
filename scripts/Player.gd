extends RigidBody2D

var beaconCount = 0

var thrust = 1000
var torque = 4000

var force = Vector2()

var thrust_charge = 0
var torque_charge = 0
var input_x : int
var input_y : int
var pitch : float = 0 # 3D sprite angle

var input : bool
var dead : bool 
var attach_pressed : bool 
var is_connected : bool
var nearBeacon : RigidBody2D

func _init():
	input = true
	angular_damp = 6.0
	linear_damp = 0.6
	gravity_scale = 3.0
	#$RotorSound.play()

func _ready():
	# animation playing is disabled on node to prevent merge conflicts
	#$HeliSprite.play()
	#$RotorSound.playing = true
	$RotorSound.play(0.0)
	
	#$RotorSound.stream.loop_mode = AudioStreamPlayer2D.LOOP_FORWARD

func _process(delta):
	
	if beaconCount > 0 and !dead:
		input = true
		input_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		attach_pressed = Input.is_action_just_pressed("ui_accept")
	else:
		input = false
		input_x = 0
		input_y = 0
	
	if attach_pressed:
		if !is_connected and nearBeacon != null:
			is_connected = true
	
	$Rope.visible = is_connected
	if is_connected and nearBeacon != null:
		$Rope.glo = [Vector2.ZERO, nearBeacon.position]
		
		
	
	$RotorSound.pitch_scale += delta * (1.0 if input else -1.0)
	$RotorSound.pitch_scale = clamp($RotorSound.pitch_scale, 0.25, 0.75)
	
	var has_thrust = input_x !=0 or input_y !=0
	$RotorSound.volume_db += delta * (10.0 if has_thrust else -10.0)
	$RotorSound.volume_db = clamp($RotorSound.volume_db, -100, -6)
	
	thrust_charge += delta * (1.25 if (input_y == 0) else -8.00)
	torque_charge += delta * (2.50 if (input_x == 0) else -8.00)
	thrust_charge = clamp(thrust_charge, 0, 1)
	torque_charge = clamp(torque_charge, 0, 1)
	
	gravity_scale += delta * (3.0 if (input_y == 0) else -6.0)
	gravity_scale = clamp(gravity_scale, 2.0, 5.0)
	
	pitch += input_y * delta * 90 * 4
	pitch = linear_velocity.y * 0.6 #sign(linear_velocity.y) * sqrt(abs(linear_velocity.y)) * 0.80
	pitch = clamp(pitch, -90, 90)
	
	#pitch = 90
	var rot_index = int(clamp(8 + 8*(pitch/90), 0, 15))
	#var rot_index = 8
	$AnimatedSprite.frame = ($AnimatedSprite.frame % 4) + (4 * rot_index)
	
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


func _on_GrabArea_body_entered(body):
	if body.name == "Beacon":
		nearBeacon = body


func _on_GrabArea_body_exited(body):
	if body == nearBeacon and !is_connected:
		nearBeacon = null
