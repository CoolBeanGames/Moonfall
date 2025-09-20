extends Node3D

func _on_start_button_down() -> void:
	print("start clicked")
	SignalBus.signals.signals["new_game_clicked"].event.emit()
