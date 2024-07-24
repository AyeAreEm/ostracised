extends CharacterBody2D

func _ready():
	$EnemySprite/AnimationPlayer.play("enemy_idle")
