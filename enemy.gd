extends CharacterBody2D

@export var target: Node2D
@export var stop_distance: float = 0.0

var speed: float = 100.0

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	if distance <= stop_distance:
		velocity = Vector2.ZERO
		return
		
	var direction = global_position.direction_to(target.global_position)
	
	velocity = direction * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("player"):
			collider.die()
