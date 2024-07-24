extends CharacterBody2D

@export var player_stats: Stats

@export var WALK_SPEED = 80
@export var RUN_SPEED = 130
@export var FRICTION = 100
@export var ACCELERATION = 50
@export var JUMP_VELOCITY = -235

var CURRENT_SPEED = WALK_SPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimationSpriteSheet/AnimationPlayer.play("kingsguard_player_idle")
	player_stats.taken_damage.connect(handle_damage)
	
func handle_damage(damage):
	print("this is the remaining health: ", player_stats.health)
	$Camera2D/HealthBar.offset.x -= damage
	
func handle_roll():
		$AnimationSpriteSheet/AnimationPlayer.stop()
		$AnimationSpriteSheet/AnimationPlayer.play("roll_animation")

func _physics_process(delta):
	if Input.is_action_just_pressed("sprint") and is_on_floor():
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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# -1 means left, 1 means right
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			$AnimationSpriteSheet.flip_h = true
		else:
			$AnimationSpriteSheet.flip_h = false
		velocity.x = velocity.move_toward(Vector2(direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "roll_animation":
		$AnimationSpriteSheet/AnimationPlayer.play("kingsguard_player_idle")
