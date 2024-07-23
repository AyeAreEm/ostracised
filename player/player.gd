extends CharacterBody2D

@export var SPEED = 150
@export var ACCELERATION = 10
@export var FRICTION = 80
@export var JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Sprite2D/AnimationPlayer.play("Idle_temp")
	
func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func _physics_process(delta):
	# this quits the game, will change to be the menu
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		#velocity.x = direction * SPEED
		velocity = velocity.move_toward(Vector2(direction * SPEED, 0), ACCELERATION)
	else:
		apply_friction()
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
