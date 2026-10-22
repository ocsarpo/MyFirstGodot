extends Node2D

var is_game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.score_changed.connect(_on_score_changed)
	$Player.died.connect(_on_player_died)
	
	# StartButton 은 paused 에서 동작해야하니 인스펙터->process->mode->When Paused 설정
	# 버튼선택->시그널->pressed() 추가 (main.gd)
	get_tree().paused = true


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
	
	var label = $CanvasLayer/Label
	label.text = "GAME OVER\nPress R to Restart"
	label.scale = Vector2(0.5, 0.5)
	# modulate : Node 의 색상에 곱해지는 값.
	# a: Alpah 투명도.
	# 0.0 완전투명, 1.0 불투명
	label.modulate.a = 0.0  # -> 안보이게 해놓고 Tween 으로 1.0 까지 올림
	label.pivot_offset = label.size / 2 # 확대 기준점을 라벨의 가운데로
	
	var tween = create_tween()
	tween.tween_property(
		label,
		"modulate:a",
		1.0,
		0.2
	)
	tween.tween_property(
		label,
		"scale",
		Vector2(2.0, 2.0),
		0.15
	)
	tween.tween_property(
		label,
		"scale",
		Vector2.ONE,
		0.1
	)
	

func _process(delta: float) -> void:
	if is_game_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _on_start_button_pressed() -> void:
	var strart_screen = $CanvasLayer/StartScreen
	
	var tween = create_tween()
	# 이 Tween만 Pause 상태에서도 실행되게 해줌
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(
		strart_screen,
		"modulate:a",
		0.0,
		0.25,
	)
	await tween.finished
	
	strart_screen.hide()
	get_tree().paused = false
