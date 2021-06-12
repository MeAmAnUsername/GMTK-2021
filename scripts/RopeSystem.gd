extends Node2D

const pre_segment = preload("res://scenes/RopeSegment.tscn")

var rope_segments = 10
var rope_segment_length = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var previous = NodePath("../Player")
	var y = rope_segment_length
	
	for i in range(rope_segments):
		var seg : PhysicsBody2D = pre_segment.instance()
		seg.name = "segment"+str(i)
		seg.position.y = y
		y += rope_segment_length
		self.add_child(seg)
		
		var currJoint = DampedSpringJoint2D.new() #PinJoint2D
		currJoint.name = "joint"+str(i)
		currJoint.set_node_a(previous) #previous
		currJoint.set_node_b(NodePath("../" + seg.name))
		currJoint.bias = 0.9
		currJoint.stiffness = 100.0
		currJoint.length = rope_segment_length
		self.add_child(currJoint)
		
		
		#currJoint.node_b = NodePath("joint"+str(i))
		previous = "../" + seg.name
		

	#get_parent().add_child(seg)
	#seg.position.y = position.y + 100
	#seg.position.x = position.x + 10
	#seg.get_node("PinJoint2D").set_node_a(self.get_path())
	#seg.get_node("PinJoint2D").set_node_b(seg.get_node("segment").get_path())
