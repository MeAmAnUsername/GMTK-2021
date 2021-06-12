extends Node2D

func change_scene(change_to):
	if change_to == null:
		push_error("Tried to change scene to null, not changing scene");
		return;
	Common.assert_OK(get_tree().change_scene_to(change_to), "Cannot change scene");
