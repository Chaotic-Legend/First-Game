extends Node

@onready var score_label = $ScoreLabel
@onready var center_container = $"../UI/CenterContainer"
@onready var paused_label = $"../UI/CenterContainer/PausedLabel"

var score = 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Engine.time_scale = 1.0
	get_tree().paused = false
	score_label.text = "You collected 0 coins."
	center_container.visible = false
	paused_label.text = "PAUSED"

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	if Input.is_action_just_pressed("reset"):
		reset_game()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	center_container.visible = get_tree().paused

func reset_game():
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().reload_current_scene()
