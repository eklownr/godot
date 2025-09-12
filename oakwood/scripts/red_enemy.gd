extends CharacterBody2D

@onready var anim = $EnemyAnim
@onready var player = $"/root/Main/Player"
var close_to_player_stats = false

const SPEED = 100.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	var direction := global_position.direction_to(player.global_position)
	if global_position.distance_to(player.global_position) > 100:
		velocity.x = direction.x * SPEED
		close_to_player_stats = false
		anim.play("enemy_walk")
	else:
		velocity = Vector2.ZERO  # Stop moving when close
		close_to_player_stats = true
		
	if close_to_player_stats:
		anim.play("enemy_idle")
	
	#velocity.x = move_toward(velocity.x, player.velocity.x, SPEED/2)
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
