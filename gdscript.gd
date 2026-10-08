extends CharacterBody2D

@export var controllable: bool = true
signal score_changed(new_score: int)

var speed = 200.0
var score: int = 0

func _ready() -> void:
	$Camera2D.enabled = controllable

func _physics_process(delta: float) -> void:
	if controllable:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func collect_item() -> void:
	score += 1
	score_changed.emit(score)
	#print("current score:", score)
