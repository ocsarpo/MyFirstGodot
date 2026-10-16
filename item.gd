extends Area2D

var collected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var delay = randf_range(0.0, 0.6)
	await get_tree().create_timer(delay).timeout
	
	if collected:
		return
		
	var tween = create_tween().set_loops()

	# 이건 변화 곡선을 SINE 형태로 쓰겠다는 뜻. 처음엔 천천히, 중간엔 조금 빠르게, 끝에서는 다시 부드럽게 움직이게
	tween.set_trans(Tween.TRANS_SINE)
	# 그 곡선을 시작과 끝 양쪽에 적용 -> 천천히 시작 → 부드럽게 빨라짐 → 다시 천천히 멈춤
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		$Sprite2D,
		"scale",
		Vector2(1.08, 1.08),
		0.5
	)

	tween.tween_property(
		$Sprite2D,
		"scale",
		Vector2.ONE,
		0.5
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
		
	if body.is_in_group("player"):
		collected = true
		
		body.collect_item()
		
		var tween = create_tween()
		
		# 아이템 크기를 약 0.08초 동안 1.2배로 키움
		tween.tween_property(
			self,
			"scale",
			Vector2(1.2, 1.2),
			0.08
		)
		# 아이템 크기를 약 0.12초 동안 0까지 줄임.
		tween.tween_property(
			self,
			"scale",
			Vector2.ZERO,
			0.12
		)
		
		await tween.finished
		
		queue_free() # 를 Scene Tree 에서안전하게제거
