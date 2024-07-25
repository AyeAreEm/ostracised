extends Control

@onready var player = $"../.."

func _on_resume_pressed():
	player.handle_pause_menu()

func _on_quit_pressed():
	get_tree().quit()
