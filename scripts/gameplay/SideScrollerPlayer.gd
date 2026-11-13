extends CharacterBody2D
class_name SideScrollerPlayer

const ACTION_MOVE_LEFT := "move_left"
const ACTION_MOVE_RIGHT := "move_right"
const ACTION_JUMP := "jump"
const DEFAULT_GRAVITY := 980.0

@export var max_speed: float = 160.0
@export var acceleration: float = 1200.0
@export var deceleration: float = 1400.0
@export var jump_velocity: float = -320.0
@export var gravity_scale: float = 1.0

var _input_state: Dictionary = {
	"horizontal": 0.0,
	"jump_pressed": false,
	"jump_held": false,
}

func _ready() -> void:
	_ensure_default_actions()

func _physics_process(delta: float) -> void:
	_capture_input_state()
	_apply_horizontal_movement(delta)
	_apply_vertical_movement(delta)
	move_and_slide()

func _capture_input_state() -> void:
	_input_state["horizontal"] = Input.get_axis(ACTION_MOVE_LEFT, ACTION_MOVE_RIGHT)
	_input_state["jump_pressed"] = Input.is_action_just_pressed(ACTION_JUMP)
	_input_state["jump_held"] = Input.is_action_pressed(ACTION_JUMP)

func _apply_horizontal_movement(delta: float) -> void:
	var target_velocity_x := float(_input_state["horizontal"]) * max_speed
	var speed_delta := acceleration * delta if absf(target_velocity_x) > 0.0 else deceleration * delta
	velocity.x = move_toward(velocity.x, target_velocity_x, speed_delta)

func _apply_vertical_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _get_gravity_strength() * delta
	elif bool(_input_state["jump_pressed"]):
		velocity.y = jump_velocity

func _get_gravity_strength() -> float:
	var base_gravity := ProjectSettings.get_setting("physics/2d/default_gravity", DEFAULT_GRAVITY)
	return float(base_gravity) * gravity_scale

func build_input_snapshot() -> Dictionary:
	return _input_state.duplicate(true)

func apply_authoritative_state(state: Dictionary) -> void:
	if state.has("position") and state["position"] is Vector2:
		global_position = state["position"]
	if state.has("velocity") and state["velocity"] is Vector2:
		velocity = state["velocity"]

func _ensure_default_actions() -> void:
	_add_action_if_missing(ACTION_MOVE_LEFT, [
		_build_key_input(KEY_A),
		_build_key_input(KEY_LEFT),
	])
	_add_action_if_missing(ACTION_MOVE_RIGHT, [
		_build_key_input(KEY_D),
		_build_key_input(KEY_RIGHT),
	])
	_add_action_if_missing(ACTION_JUMP, [
		_build_key_input(KEY_SPACE),
		_build_key_input(KEY_W),
		_build_key_input(KEY_UP),
	])

func _add_action_if_missing(action_name: String, events: Array[InputEvent]) -> void:
	if InputMap.has_action(action_name):
		return
	InputMap.add_action(action_name)
	for event in events:
		InputMap.action_add_event(action_name, event)

func _build_key_input(keycode: Key) -> InputEventKey:
	var key_event := InputEventKey.new()
	key_event.physical_keycode = keycode
	return key_event
