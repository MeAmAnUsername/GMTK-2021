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

var rope_pre = preload( "res://scenes/Rope.tscn" )
var rope

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
	rope = rope_pre.instance()
	get_tree().get_root().call_deferred("add_child",rope)
	$AnimatedSprite.play()
	
	#$RotorSound.stream.loop_mode = AudioStreamPlayer2D.LOOP_FORWARD

func _process(delta):
	
	if Input.is_action_just_pressed("ui_restart"):
		Common.assert_OK(get_tree().reload_current_scene(), "Cannot restart level");

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
		print(is_connected, nearBeacon)
		if !is_connected and nearBeacon != null:
			is_connected = true
			$RopeSpring.node_b = NodePath(nearBeacon.get_path())
		elif is_connected and nearBeacon != null:
			$RopeSpring.node_b = ""
			is_connected = false
			nearBeacon = null


	rope.visible = is_connected
	if is_connected and nearBeacon != null:
		#rope.points = [Vector2.ZERO, position.direction_to(nearBeacon.position) * position.distance_to(nearBeacon.position)]
		nearBeacon.modulate = Color.white
		rope.position = position
		rope.points = [Vector2.ZERO, nearBeacon.position-self.position ]
		print(rope.points)
	
	$RotorSound.pitch_scale += delta * (1.0 if input else -1.0)
	$RotorSound.pitch_scale = clamp($RotorSound.pitch_scale, 0.25, 0.75)
	
	var has_thrust = input_x !=0 or input_y !=0
	$RotorSound.volume_db += delta * (20.0 if has_thrust else -20.0)
	$RotorSound.volume_db = clamp($RotorSound.volume_db, -20, -6)
	
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
	if dead:
		applied_torque = 0
		applied_force = Vector2.ZERO
		return
	applied_torque = input_x * (torque + torque_charge * 8000)
	
	# Try to stay upright
	var angle_dif = (-TAU*0.25 - rotation) / (TAU*0.25)
	if beaconCount > 0 and (abs(angle_dif) < 1):
		applied_torque += angle_dif * 4000
	
	var total_thrust = thrust_charge * 5000 + thrust
	applied_force = Vector2(0, total_thrust * input_y).rotated(rotation + TAU*0.25)


func explode():
	if not dead:
		$Explosion.emitting = true
		$Explosion/ExplosionSound.play()
		dead = true
		apply_torque_impulse(8000)
		#gravity_scale = 40
		$AnimatedSprite.modulate = Color.black
		$SmokeEmitter.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_GrabArea_body_entered(body):
	if !is_connected:
		nearBeacon = body
		body.modulate = Color.bisque

func _on_GrabArea_body_exited(body):
	body.modulate = Color.white
	if body == nearBeacon and !is_connected:
		nearBeacon = null

func _on_Player_body_entered(body):
	$ImpactSound.play()
	$ImpactSound.volume_db = -20 + clamp(linear_velocity.length() * 0.05, 0, 16)
