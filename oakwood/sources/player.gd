extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dubble_jump 
var duck_state = false
var powerup_state = false
@onready var camera = $"../Camera"
@onready var anim = $Anim


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		state_jump_anim() # is player on it't way up or down?

	# Handle jump and state		
	if Input.is_action_just_pressed("action") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		dubble_jump = true
	elif Input.is_action_just_pressed("action") and dubble_jump:
		velocity.y = JUMP_VELOCITY
		dubble_jump = false
		#state_jump_anim() # dubble jump in the air
		
	# duck state
	if Input.is_action_just_pressed("down"):
		duck_state = true
	elif Input.is_action_just_released("down"):
		duck_state = false		
	
	# powerup state
	if Input.is_action_just_pressed("action_z"):
		powerup_state = true
	elif Input.is_action_just_released("action_z"):
		powerup_state = false
	
	# Get the input actions. right and left
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		camera.position.x = position.x
		if direction > 0:
			anim.flip_h = false
			if is_on_floor():
				anim.play("run") # run right
		elif  direction < 0:
			anim.flip_h = true
			if is_on_floor():
				anim.play("run") # run left
			
	else: # Idle or duck
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and duck_state == false:
			$Anim.play("idle")
		elif duck_state and is_on_floor():
			anim.play("duck")
	powreup_anim() # check if powerup is playing			
	move_and_slide()


func state_jump_anim() -> void:
	# play anim jump or falling
	if velocity.y < 0: #player is moving up → play "jump"
		anim.play("jump")
	if velocity.y > 0: #player is moving down → play "fall"
		anim.play()
	 
func powreup_anim() -> void:
	if is_on_floor() and powerup_state == true and velocity.x == 0:
		anim.play("power_up")
