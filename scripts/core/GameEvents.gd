extends Node

signal game_started
signal quit_requested

func emit_game_started() -> void:
	game_started.emit()

func emit_quit_requested() -> void:
	quit_requested.emit()
