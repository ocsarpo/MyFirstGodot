extends Node2D

var is_game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.score_changed.connect(_on_score_changed)
	$Player.died.connect(_on_player_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_score_changed(new_score: int) -> void:
	var label = $CanvasLayer/Label
	label.text = "Score: " + str(new_score)
	label.scale = Vector2.ONE
	
	var tween = create_tween()
	tween.tween_property(
			label,
			"scale",
			Vector2(1.4, 1.4),
			0.08
		)
		
	tween.tween_property(
		label,
		"scale",
		Vector2.ONE,
		0.12
	)

func _on_player_died() -> void:
	is_game_over = true
	$CanvasLayer/Label.text = "GAME OVER\n Press R to Restart"

func _process(delta: float) -> void:
	if is_game_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
