extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dubble_jump 
@onready var camera = $"../Camera"
@onready var anim = $Anim


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("action") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		dubble_jump = true
	elif Input.is_action_just_pressed("action") and dubble_jump:
		velocity.y = JUMP_VELOCITY
		dubble_jump = false

	# Get the input actions. right and left
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		camera.position.x = position.x
		if direction > 0:
			anim.flip_h = false
			anim.play("run") # run right
		elif  direction < 0:
			anim.play("run") # run left
			anim.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Anim.play("idle")
		
	move_and_slide()
