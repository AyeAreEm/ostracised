extends CharacterBody2D

@export var player_stats: Stats

@onready var AnimPlay = $EnemySprite/AnimationPlayer
@onready var Sprite = $EnemySprite

var player: CharacterBody2D
var start_time = 0

func _ready():
	AnimPlay.play("redguy_idle")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var current_time = Time.get_unix_time_from_system()
	var direction = player.global_position - global_position
	
	if direction.length() <= 50:
		if start_time == 0:
			start_time = Time.get_unix_time_from_system()
			AnimPlay.play("redguy_attack")
		elif current_time - start_time >= 1:
			player_stats.take_damage(10)
			start_time = 0
	else:
		AnimPlay.play("redguy_idle")
		start_time = 0
