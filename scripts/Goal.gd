extends Node2D

export (PackedScene) var change_to

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		SceneChanger.change_scene(change_to);
