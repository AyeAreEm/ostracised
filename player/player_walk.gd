extends State
class_name PlayerWalk

@export var player: CharacterBody2D
@export var speed = 80
@export var acceleration = 50

func enter_state():
	player = get_tree().get_first_node_in_group("Player")

func physics_update(delta):
	if Input.is_action_just_pressed("sprint"):
		$"../../CharacterBody2D/IdleAnimation".hide()
		$"../../CharacterBody2D/IdleAnimation/AnimationPlayer".stop()
		state_transitioned.emit(self, "roll")
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = player.velocity.move_toward(Vector2(direction * speed, player.global_transform.origin.y), acceleration).x
	else:
		state_transitioned.emit(self, "idle")

	player.move_and_slide()
