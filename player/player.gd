extends CharacterBody2D

enum State {
	Idle,
	Walk,
	Jump,
	Fall,
	Roll,
}

@export var player_stats: Stats

@export var WALK_SPEED = 80
@export var RUN_SPEED = 130
@export var FRICTION = 100
@export var ACCELERATION = 50
@export var JUMP_VELOCITY = -235

# makes it so we dont have to get it every time 
@onready var AnimPlay = $AnimationSpriteSheet/AnimationPlayer
@onready var Sprite = $AnimationSpriteSheet
@onready var PauseMenu = $Camera2D/PauseMenu
@onready var HealthBar = $Camera2D/HealthBar

var CURRENT_SPEED = WALK_SPEED
var paused = false
var previous_height = 0

var current_state = State.Idle
var previous_direction = 1
var healing_charges = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter_state(state, force = false):
	if current_state == state:
		return
	
	if !force:
		if current_state == State.Roll and state != State.Jump:
			return
		
		if current_state == State.Fall and !is_on_floor():
			return
		
		if current_state == State.Jump and state == State.Idle:
			return
	
	current_state = state
	AnimPlay.stop()
	match state:
		State.Idle:
			AnimPlay.play("kingsguard_idle")
		State.Walk:
			AnimPlay.play("kingsguard_walk")
		State.Jump:
			previous_height = position.y
			velocity.y = JUMP_VELOCITY
			AnimPlay.play("kingsguard_jump")
		State.Fall:
			AnimPlay.play("kingsguard_fall")
		State.Roll:
			# MIGHT NEED TO REMOVE THIS
			AnimPlay.play("kingsguard_roll")
			
func update_state():
	match current_state:
		State.Roll:
			velocity.x = velocity.move_toward(Vector2(previous_direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x
		State.Idle:
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			
func handle_heal():
	if healing_charges <= 0:
		return
		
	if player_stats.health + 20 > player_stats.max_health:
		var diff = player_stats.max_health - player_stats.health
		player_stats.health += diff
		HealthBar.position.x += diff
	else:
		player_stats.health += 20
		HealthBar.position.x += 20

	healing_charges -= 1
	print(player_stats.health)
	print(HealthBar.position.x)

func handle_damage(damage):
	HealthBar.position.x -= damage
	
func handle_death():
	print("you died")

func _ready():
	enter_state(State.Idle)
	player_stats.taken_damage.connect(handle_damage)
	player_stats.death.connect(handle_death)
	
func handle_roll(direction):
	CURRENT_SPEED = RUN_SPEED
	
	if direction == 0:
		velocity.x = velocity.move_toward(Vector2(previous_direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x
	else:
		velocity.x = velocity.move_toward(Vector2(direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x

	enter_state(State.Roll)
	
func handle_move(direction):
	if direction == -1:
		Sprite.flip_h = true
	else:
		Sprite.flip_h = false
		
	velocity.x = velocity.move_toward(Vector2(direction * CURRENT_SPEED, global_transform.origin.y), ACCELERATION).x
	enter_state(State.Walk)
	
func check_falling():
	if previous_height < position.y and !is_on_floor():
		enter_state(State.Fall)
		
	previous_height = position.y
		
func handle_pause_menu():
	if paused:
		PauseMenu.hide()
		Engine.time_scale = 1
	else:
		PauseMenu.show()
		Engine.time_scale = 0
		
	paused = !paused
		
func dev_testing():
	if Input.is_action_just_pressed("dev_take_damage"):
		player_stats.take_damage(1)

func _physics_process(delta):
	# THIS SHOULD BE REMOVED BEFORE FINAL BUILD
	dev_testing()
	update_state() # not this
	
	var direction = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("heal"):
		handle_heal()
	
	if Input.is_action_just_pressed("menu"):
		handle_pause_menu()
	
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		handle_roll(direction)
	
	if Input.is_action_pressed("sprint"):
		CURRENT_SPEED = RUN_SPEED
	else:
		CURRENT_SPEED = WALK_SPEED

	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		enter_state(State.Jump)
		
	check_falling()

	# -1 means left, 1 means right
	if direction:
		previous_direction = direction
		handle_move(direction)
	else:
		enter_state(State.Idle)
		
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "kingsguard_roll":
		enter_state(State.Idle, true)
