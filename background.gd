class_name Background extends Node2D

@onready var mountains: Parallax2D = %Mountains
@onready var ground: Parallax2D = $Ground

func stop_scrolling():
	pass  # not currently implemented because of jerky stopping motion
