extends CharacterBody2D

@export var WALK_SPEED = 80
@export var RUN_SPEED = 130
@export var FRICTION = 100
@export var ACCELERATION = 50
@export var JUMP_VELOCITY = -220

var CURRENT_SPEED = WALK_SPEED
var jump_start = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$IdleAnimation/AnimationPlayer.play("kingsguard_player_idle")
	
func handle_roll():
		$IdleAnimation/AnimationPlayer.stop()
		$RollAnimation/AnimationPlayer.play("roll_animation")
		print("rolling")
	
	
func handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_start = Time.get_unix_time_from_system()
		
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		var time_elapsed = Time.get_unix_time_from_system() - jump_start
		print(time_elapsed)
		
		if time_elapsed > 1.2:
			velocity.y = JUMP_VELOCITY * 1.2
		else:
			if JUMP_VELOCITY * time_elapsed < JUMP_VELOCITY * -1:
				velocity.y = JUMP_VELOCITY
			else:
				velocity.y = JUMP_VELOCITY * time_elapsed

func _physics_process(delta):
	if Input.is_action_just_pressed("sprint"):
		CURRENT_SPEED = RUN_SPEED
		handle_roll()
	
	if Input.is_action_pressed("sprint"):
		CURRENT_SPEED = RUN_SPEED
	else:
		CURRENT_SPEED = WALK_SPEED
	
	# this quits the game, will change to be the menu
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	# Handle jump
	handle_jump()

	# -1 means left, 1 means right
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			pass
		else:
			pass
		velocity.x = velocity.move_toward(Vector2(direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
