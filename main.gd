extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.score_changed.connect(_on_score_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_score_changed(new_score: int) -> void:
	$CanvasLayer/Label.text = "Score: " + str(new_score)
