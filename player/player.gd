extends CharacterBody2D

@export var player_stats: Stats

@export var WALK_SPEED = 80
@export var RUN_SPEED = 130
@export var FRICTION = 100
@export var ACCELERATION = 50
@export var JUMP_VELOCITY = -235

#makes it so we dont have to get it every time 
@onready var AnimPlay = $AnimationSpriteSheet/AnimationPlayer
@onready var Sprite = $AnimationSpriteSheet

var CURRENT_SPEED = WALK_SPEED
var paused = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	AnimPlay.play("kingsguard_idle")
	player_stats.taken_damage.connect(handle_damage)
	player_stats.death.connect(handle_death)
	
func handle_damage(damage):
	print("this is the remaining health: ", player_stats.health)
	$Camera2D/HealthBar.position.x -= damage
	
func handle_death():
	print("you died")
	
func handle_roll():
	AnimPlay.stop()
	AnimPlay.play("roll_animation")
		
func handle_pause_menu():
	if paused:
		$Camera2D/PauseMenu.hide()
		Engine.time_scale = 1
	else:
		$Camera2D/PauseMenu.show()
		Engine.time_scale = 0
		
	paused = !paused
		
func dev_testing():
	if Input.is_action_just_pressed("dev_take_damage"):
		player_stats.take_damage(1)

func _physics_process(delta):
	# THIS SHOULD BE REMOVED BEFORE FINAL BUILD
	dev_testing()
	
	# this quits the game, will change to be the menu
	if Input.is_action_just_pressed("menu"):
		handle_pause_menu()
	
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		CURRENT_SPEED = RUN_SPEED
		handle_roll()
	
	if Input.is_action_pressed("sprint"):
		CURRENT_SPEED = RUN_SPEED
	else:
		CURRENT_SPEED = WALK_SPEED

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# -1 means left, 1 means right
	var direction = Input.get_axis("left", "right")
	
	if direction:
		if direction == -1:
			Sprite.flip_h = true
			#AnimPlay.play("kingsguard_walk")
		else:
			Sprite.flip_h = false
			#AnimPlay.play("kingsguard_walk")
		velocity.x = velocity.move_toward(Vector2(direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x
		
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		

	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "roll_animation":
		AnimPlay.play("kingsguard_player_idle")
