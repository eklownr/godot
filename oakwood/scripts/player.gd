extends CharacterBody2D

const RUN_SPEED = 300.0
const WALK_SPEED = 150.0
const JUMP_VELOCITY = -410.0
const SLIDE_ATACK_SPEED = 400.0
var dubble_jump 
var jump_stat = false
var duck_state = false
var powerup_state = false
var slide_state = false 
var shild_state = false
var sword_state = false
#var walk_state = false # normal state
var run_state = false
var die_state = false

@onready var camera = $"../Camera"
@onready var anim = $Anim

   
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		state_jump_anim() # is player on it't way up or down?

	# Handle jump and stat
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_stat = true
		dubble_jump = true
	elif Input.is_action_just_pressed("up") and dubble_jump:
		velocity.y = JUMP_VELOCITY
		jump_stat = true
		dubble_jump = false
	elif  Input.is_action_just_released("up"):
		jump_stat = false

	# Handle die state	TEST	
	if Input.is_action_just_pressed("action_d"):
		anim.play("hit")
		die_state = true
	elif Input.is_action_just_released("action_d"):
		die_state = false

	# Handle slide state		
	if Input.is_action_just_pressed("action_x") and is_on_floor():
		slide_state = true
	elif Input.is_action_just_released("action_x"):
		slide_state = false

	# Handle shild state		
	if Input.is_action_just_pressed("action_z"):
		shild_state = true
	elif Input.is_action_just_released("action_z"):
		shild_state = false

	# Handle walk state		
	if Input.is_action_just_pressed("action_s"):
		run_state = true
	elif Input.is_action_just_released("action_s"):
		run_state = false

	# Handle sword state		
	if Input.is_action_just_pressed("action_c"):
		sword_state = true
	elif Input.is_action_just_released("action_c"):
		sword_state = false

	# Handel duck state
	if Input.is_action_just_pressed("down"):
		duck_state = true
	elif Input.is_action_just_released("down"):
		duck_state = false
	
	# Handel powerup state
	if Input.is_action_just_pressed("action_a"):
		powerup_state = true
	elif Input.is_action_just_released("action_a"):
		powerup_state = false
	
	# Handel right and left. Run and slide.
	var direction := Input.get_axis("left", "right")
	if direction:
		camera.position.x = position.x
		# Set SPEED
		if slide_state and run_state: # add extra speed when slide
			velocity.x = direction * SLIDE_ATACK_SPEED
		elif run_state:
			velocity.x = direction * RUN_SPEED
		else:
			velocity.x = direction * WALK_SPEED

		if direction > 0: # direction right
			anim.flip_h = false
			if die_state:
				die()
			elif  is_on_floor() and slide_state and run_state:
				anim.play("slide") # slide right
			elif  is_on_floor() and not slide_state and not run_state and not sword_state:
				anim.play("walk") # run right
			elif run_state and not jump_stat and not sword_state:
				anim.play("run")
			elif sword_state and not run_state and not jump_stat:
				anim.play("sword")
			
		elif  direction < 0: # direction left
			anim.flip_h = true
			if die_state:
				die()
			elif is_on_floor() and slide_state and run_state and not die_state:
				anim.play("slide") # slid left
			elif  is_on_floor() and not slide_state and not run_state and not sword_state and not jump_stat:
				anim.play("walk")
			elif run_state and not jump_stat and not sword_state:
				anim.play("run")
			elif  sword_state and not run_state and not jump_stat:
				anim.play("sword")
	else: # No direction: Idle, duck, power_up or shild
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		if die_state:
			die()
		elif  is_on_floor() and not duck_state and not powerup_state and not shild_state and not sword_state:
			$Anim.play("idle")
		elif duck_state and is_on_floor() and not powerup_state and not shild_state and not sword_state:
			anim.play("duck")
		elif powerup_state and is_on_floor() and not shild_state and not sword_state:
			anim.play("power_up")
		elif shild_state and not sword_state:
			anim.play("shild")
		elif  sword_state:
			anim.play("sword")
			
	move_and_slide()


# play anim jump or falling
func state_jump_anim() -> void:
	if velocity.y < 0: # player is moving up → play "jump"
		anim.play("jump")
	if velocity.y > 0: # player is moving down → play "fall"
		anim.play()


func die() -> void:
	velocity.x = 0
	anim.play("die")
