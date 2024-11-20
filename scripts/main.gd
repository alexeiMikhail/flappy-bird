class_name Main extends Node2D

@onready var hud: HUD = %HUD
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var background: Background = $Background
@onready var bird: Bird = $Bird


enum States {GAMEOVER, RUN, WAIT}
var state: States = States.WAIT

func _ready() -> void:
	background_music.play()
	hud.hide_game_over()

func _process(_delta: float) -> void:
	if state == States.WAIT:
		waiting()
	if state == States.GAMEOVER:
		new_game()
	pass

func game_over():
	await get_tree().create_timer(1.0).timeout
	hud.show_game_over()
	state = States.GAMEOVER
	# background.stop_scrolling() # not currently implemented because of jerky stopping motion

func waiting():
	if Input.is_action_just_pressed("jump"):
		hud.hide_start_prompt()

func new_game():
	if Input.is_action_just_pressed("jump"):
		hud.hide_game_over()
		hud.show_start_prompt()
		bird.reset()
		state = States.WAIT
