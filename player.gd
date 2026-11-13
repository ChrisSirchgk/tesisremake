
extends CharacterBody2D
class_name Player

signal moved(world_position: Vector2)

@export var move_speed: float = 180.0

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	velocity = input_direction * move_speed
	move_and_slide()

	if input_direction != Vector2.ZERO:
		moved.emit(global_position)
