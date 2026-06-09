extends CharacterBody2D

@onready var visuals = $Visuals
@onready var animated_sprite = $Visuals/AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound

const SPEED = 120.0
const SPRINT_MULTIPLIER = 1.50
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var sprint_jump = false

func _ready():
	animated_sprite.play("idle")
	await get_tree().process_frame
	animated_sprite.play("run")
	await get_tree().process_frame
	animated_sprite.play("jump")
	await get_tree().process_frame
	animated_sprite.play("idle")

func _physics_process(delta):
	if is_dead:
		velocity.x = 0
		velocity.y += gravity * 0.35 * delta
		move_and_slide()
		return
	if is_on_floor():
		sprint_jump = false
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprint_jump = Input.is_action_pressed("sprint")
		velocity.y = JUMP_VELOCITY
		jump_sound.stop()
		jump_sound.play()
	var direction = Input.get_axis("move_left", "move_right")
	var current_speed = SPEED
	if is_on_floor() and Input.is_action_pressed("sprint"):
		current_speed *= SPRINT_MULTIPLIER
	elif not is_on_floor() and sprint_jump:
		current_speed *= SPRINT_MULTIPLIER
	if direction > 0:
		visuals.scale.x = abs(visuals.scale.x)
	elif direction < 0:
		visuals.scale.x = -abs(visuals.scale.x)
	if is_on_floor():
		if direction == 0:
			play_animation("idle")
		else:
			play_animation("run")
	else:
		play_animation("jump")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	move_and_slide()

func die():
	if is_dead:
		return
	is_dead = true
	if death_sound:
		death_sound.play()
	velocity.x = 0
	velocity.y = 60
	collision_mask = 2
	animated_sprite.play("jump")

func play_animation(animation_name):
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
