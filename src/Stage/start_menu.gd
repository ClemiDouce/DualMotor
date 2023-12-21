extends Control

const GameScene = preload("res://src/Stage/Stage.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameScene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
