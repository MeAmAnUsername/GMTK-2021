extends Node

func assert_OK(err, msg):
	if err != OK:
		push_error("%s, error: %s (See https://docs.godotengine.org/en/stable/classes/class_%%40globalscope.html#enum-globalscope-error)" % [msg, str(err)]);
