extends CharacterBody2D

# Define all possible states
enum STATE {
	IDLE,
	RUN,
	JUMP,
	FALL,
	DUCK,
	POWERUP
}

@export var speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 800.0

@onready var animated_sprite = $AnimatedSprite2D

var current_state: STATE

func _ready():
	# Start in IDLE state
	_set_state(STATE.IDLE)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle input and state-specific logic
	match current_state:
		STATE.IDLE:
			if Input.get_action_strength("ui_right") or Input.get_action_strength("ui_left"):
				_set_state(STATE.RUN)
			elif not is_on_floor():
				_set_state(STATE.FALL)
		
		STATE.RUN:
			var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			if direction != 0:
				velocity.x = direction * speed
				animated_sprite.flip_h = direction < 0
			else:
				_set_state(STATE.IDLE)
			if not is_on_floor():
				_set_state(STATE.FALL)
		
		STATE.JUMP:
			# Jump logic handled on entry; just apply movement
			var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			velocity.x = direction * speed
		
		STATE.FALL:
			var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			velocity.x = direction * speed
			if is_on_floor():
				if direction != 0:
					_set_state(STATE.RUN)
				else:
					_set_state(STATE.IDLE)
		
		STATE.DUCK:
			# Ducking behavior (e.g., reduce size or play animation)
			if Input.is_action_just_released("ui_down"):
				_set_state(STATE.IDLE)
		
		STATE.POWERUP:
			# Example: temporary power-up animation
			if animated_sprite.animation_finished:
				_set_state(STATE.IDLE)

	move_and_slide()

# Called to change state safely
func _set_state(new_state: int) -> void:
	if current_state == new_state:
		return  # Prevent redundant state changes

	_exit_state()        # Clean up current state
	current_state = new_state
	_enter_state()       # Initialize new state

# Enter logic for current state
func _enter_state() -> void:
	match current_state:
		STATE.IDLE:
			animated_sprite.play("idle")
		
		STATE.RUN:
			animated_sprite.play("run")
		
		STATE.JUMP:
			if is_on_floor():  # Only jump if on ground
				velocity.y = jump_force
				animated_sprite.play("jump")
				# After jumping, we stay in JUMP until apex
			else:
				_set_state(STATE.FALL)  # Fallback
		
		STATE.FALL:
			animated_sprite.play("fall")
		
		STATE.DUCK:
			animated_sprite.play("duck")
			# Optionally resize collision shape or set flag
		
		STATE.POWERUP:
			animated_sprite.play("powerup")

# Exit logic for current state
func _exit_state() -> void:
	match current_state:
		STATE.IDLE:
			pass  # Nothing to clean up
		STATE.RUN:
			pass
		STATE.JUMP:
			# You could track jump start time, cancel effects, etc.
			pass
		STATE.FALL:
			pass
		STATE.DUCK:
			# Reset any duck-specific changes
			pass
		STATE.POWERUP:
			# End power-up effects here if needed
			pass   
