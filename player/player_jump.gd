extends State
class_name PlayJump

@export var player: CharacterBody2D
@export var JUMP_VELOCITY = -220
var start_time = 0

func enter_state():
	player = get_tree().get_first_node_in_group("Player")
	
func physics_update(delta):
	if Input.is_action_pressed("ui_accept") and player.is_on_floor():
		if start_time == 0:
			start_time = Time.get_unix_time_from_system()
			return
		
	print(Input.is_action_just_released("ui_accept"))
	if Input.is_action_just_released("ui_accept") and player.is_on_floor():
		var time_elapsed = Time.get_unix_time_from_system() - start_time
		print(time_elapsed)
		
		if time_elapsed > 1.2:
			player.velocity.y = JUMP_VELOCITY * 1.2
		else:
			if JUMP_VELOCITY * time_elapsed < JUMP_VELOCITY * -1:
				player.velocity.y = JUMP_VELOCITY
			else:
				player.velocity.y = JUMP_VELOCITY * time_elapsed
				
	elif player.is_on_floor():
		state_transitioned.emit(self, "idle")
