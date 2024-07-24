extends Resource
class_name Stats

signal taken_damage

@export var health: int = 50
@export var strength: int = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("dev_take_damage"):
		take_damage()

func take_damage():
	health -= 10
	if health == 0:
		print("AZHHHHHHHH")
		
	taken_damage.emit(10)
