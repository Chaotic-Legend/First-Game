extends Area2D

@onready var timer = $Timer

var is_restarting = false

func _on_body_entered(body):
	if is_restarting:
		return
	if get_parent() and get_parent().name.begins_with("Slime"):
		if body.has_method("die"):
			is_restarting = true
			body.die()
		return
	if body.has_method("die"):
		body.die()
	is_restarting = true
	timer.start()

func _on_timer_timeout():
	get_tree().paused = false
	get_tree().reload_current_scene()
