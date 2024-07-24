extends State
class_name PlayerIdle

@export var player: CharacterBody2D
@export var friciton = 100

func enter_state():
	#$"../../CharacterBody2D/IdleAnimation".show()
	$"../../CharacterBody2D/IdleAnimation/AnimationPlayer".play("kingsguard_player_idle")
	player = get_tree().get_first_node_in_group("Player")
	
func update_state(delta):
	pass
	
func physics_update(delta):
	if Input.is_action_just_pressed("ui_accept"):
		state_transitioned.emit(self, "jump")
	
	if Input.is_action_just_pressed("sprint"):
		$"../../CharacterBody2D/IdleAnimation/AnimationPlayer".stop()
		$"../../CharacterBody2D/IdleAnimation".hide()
		state_transitioned.emit(self, "roll")

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		state_transitioned.emit(self, "walk")
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, friciton)
		
	player.move_and_slide()
