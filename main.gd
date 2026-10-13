extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.score_changed.connect(_on_score_changed)
	$Player.died.connect(_on_player_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_score_changed(new_score: int) -> void:
	$CanvasLayer/Label.text = "Score: " + str(new_score)

func _on_player_died() -> void:
	$CanvasLayer/Label.text = "GAME OVER"
