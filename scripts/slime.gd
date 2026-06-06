extends Node2D

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var slime_sound = $SlimeSound

const SPEED = 60
var direction = 1

func _process(delta):
	if ray_cast_right.is_colliding() and direction == 1:
		direction = -1
		if slime_sound.playing:
			slime_sound.stop()
		slime_sound.play()
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding() and direction == -1:
		direction = 1
		if slime_sound.playing:
			slime_sound.stop()
		slime_sound.play()
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta
