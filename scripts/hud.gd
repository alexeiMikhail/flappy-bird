class_name HUD extends Node

@onready var game_over: Label = $GameOver
@onready var start_prompt: Label = $StartPrompt


func show_game_over():
	game_over.show()


func show_start_prompt():
	start_prompt.show()


func hide_game_over():
	game_over.hide()


func hide_start_prompt():
	start_prompt.hide()
