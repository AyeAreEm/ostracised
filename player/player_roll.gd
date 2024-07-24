extends State
class_name PlayerRoll

@export var player: CharacterBody2D

func enter_state():
	#$"../../CharacterBody2D/IdleAnimation".show()
	$"../../CharacterBody2D/RollAnimation/AnimationPlayer".play("roll_animation")
	player = get_tree().get_first_node_in_group("Player")

func update(delta):
	pass

func physics_update(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		state_transitioned.emit(self, "walk")
	else:
		state_transitioned.emit(self, "idle")

func _on_animation_player_animation_finished(anim_name):
	$"../../CharacterBody2D/IdleAnimation".hide()
	$"../../CharacterBody2D/RollAnimation/AnimationPlayer".stop()
	if Input.is_action_pressed("sprint"):
		state_transitioned.emit(self, "run")
		return
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		state_transitioned.emit(self, "walk")
	else:
		state_transitioned.emit(self, "idle")
