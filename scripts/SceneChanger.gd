extends Node2D

func change_scene(change_to):
	if change_to == null:
		push_warning("Tried to change scene to null, not changing scene");
		return;
	get_tree().change_scene_to(change_to);
