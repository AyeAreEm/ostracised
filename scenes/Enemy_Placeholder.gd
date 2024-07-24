extends CharacterBody2D

@export var player_stats: Stats

func _ready():
	$EnemySprite/AnimationPlayer.play("enemy_idle")
	player_stats.take_damage(20)
	print("this is damage done: ", 20)
