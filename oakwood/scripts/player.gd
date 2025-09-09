extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dubble_jump 
var duck_state = false
var powerup_state = false
var slide_state = false 
var shild_state = false
var sword_state = false

@onready var camera = $"../Camera"
@onready var anim = $Anim

func  _ready() -> void:
	#anim.connect("animation_finished", _on_anim_finished)
	pass
   
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		state_jump_anim() # is player on it't way up or down?

	# Handle jump and stat
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		dubble_jump = true
	elif Input.is_action_just_pressed("up") and dubble_jump:
		velocity.y = JUMP_VELOCITY
		dubble_jump = false

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
		velocity.x = direction * SPEED
		camera.position.x = position.x
		if direction > 0: # direction right
			anim.flip_h = false
			if is_on_floor() and slide_state:
				anim.play("slide") # slide right
			elif  is_on_floor() and not slide_state:
				anim.play("run") # run right
		elif  direction < 0: # direction left
			anim.flip_h = true
			if is_on_floor() and slide_state:
				anim.play("slide") # slid left
			elif  is_on_floor() and not slide_state:
				anim.play("run")
	else: # Idle, duck, power_up or shild
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not duck_state and not powerup_state and not shild_state and not sword_state:
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


func anim_finish():
	if anim.animation_finished:
		anim.stop()
		
func _on_anim_finished() -> void:
	pass


func _on_anim_animation_looped() -> void:
	anim.stop()
