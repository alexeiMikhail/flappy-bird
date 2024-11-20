class_name Bird extends CharacterBody2D

@export var gravity = 900.0
@export var jump_force = 300
@export var rotation_speed = 2
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var death_sound: AudioStreamPlayer = $DeathSound
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound
@onready var particles: CPUParticles2D = $Particles
@onready var dildo: AnimatedSprite2D = $Dildo
@onready var bird_sprite: Sprite2D = $BirdSprite

var max_speed = 400
@onready var animation: AnimationPlayer = $Animation
var death_position: Vector2
var shake_radius = 5
var starting_location = Vector2(100, 100)

signal game_over

var shaking = false

enum States {FLYING, WAITING, DEAD, DETONATING, RESET}
var state: States = States.WAITING

#--------------------------------------------------------
# 
#--------------------------------------------------------

func _ready() -> void:
	# dildo.play()
	pass


func _physics_process(delta: float) -> void:
	if shaking:
		shake()
	if state == States.WAITING:
		velocity = Vector2.ZERO
		if Input.is_action_just_pressed("jump"):
			state = States.FLYING
			animation.play("flying")  
	if state == States.FLYING:
		flying(delta)
	if state == States.DETONATING:
		pass
	if state == States.DEAD:
		pass
	if state == States.RESET:
		state = States.WAITING


func flying(delta):
	if Input.is_action_just_pressed("jump"):
		jump()
	fall(delta)


func jump():
	jump_sound.play()
	velocity.y = -jump_force
	rotation = deg_to_rad(-30)


func fall(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_speed)
	rotation += rotation_speed * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		dies()


func dies():
	death_sound.play()
	state = States.DETONATING
	animation.stop()
	death_position = position
	detonate()
	# Stop parralax scroll


func detonate():
	await get_tree().create_timer(1.0).timeout
	shaking = true
	await get_tree().create_timer(2.0).timeout
	shaking = false  
	await get_tree().create_timer(0.5).timeout
	explode()


func shake():
	position = death_position + Vector2(randf(), randf()).normalized() * randf() * shake_radius

func explode(): 
	explosion_sound.play()
	bird_sprite.hide()
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	hide()
	game_over.emit()# Signal game-over

func reset():
	position = starting_location
	bird_sprite.show()
	show()
	rotation = 0
	state = States.RESET
