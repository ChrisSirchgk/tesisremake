
extends Node

signal run_snapshot_changed(snapshot: Dictionary)
signal profile_changed(profile: Dictionary)
signal ui_notice(message: String)

const MAIN_MENU_SCENE := "res://scenes/ui/main_menu.tscn"
const TEST_RUN_SCENE := "res://scenes/game/test_run.tscn"

# Recursos de las clases.
const CLASS_RESOURCES: Dictionary = {
	"thief": preload("res://data/classes/thief.tres"),
	"mage": preload("res://data/classes/mage.tres"),
	"tank": preload("res://data/classes/tank.tres")
}

# Perfil local de prueba.
var profile: Dictionary = {
	"schema_version": 1,
	"player_id": "local_test",
	"display_name": "Explorador",
	"shards": 125,
	"unlocked_classes": [
		"thief",
		"mage",
        "tank"
	]
}

# Datos de la partida actual.
var run_snapshot: Dictionary = {}


# Devuelve una copia del perfil.
func get_profile_snapshot() -> Dictionary:
	return profile.duplicate(true)


# Devuelve una copia de la partida.
func get_run_snapshot() -> Dictionary:
	return run_snapshot.duplicate(true)


# Obtiene el recurso .tres de una clase.
func get_class_data(class_id: String) -> ClassData:
	return CLASS_RESOURCES.get(class_id) as ClassData


# Inicia una partida utilizando las estadísticas del recurso .tres.
func start_demo_run(class_id: String) -> void:
	var unlocked: Array = profile.get("unlocked_classes", [])

	if not unlocked.has(class_id):
		ui_notice.emit("Esta clase esta bloqueada.")
		return

	var class_data: ClassData = get_class_data(class_id)

	if class_data == null:
		ui_notice.emit("No se encontro la clase: " + class_id)
		return

	run_snapshot = {
		"schema_version": 1,
		"run_id": "demo-run-0001",
		"mode": "demo",
		"local_player_id": "local_test",
		"wave": 2,
		"elapsed_seconds": 95,

		"players": [
			{
				"player_id": "local_test",
				"display_name": "Tu",
				"class_id": class_data.id,
				"class_name": class_data.display_name,

				"hp": class_data.max_hp,
				"max_hp": class_data.max_hp,
				"attack": class_data.attack,
				"defense": class_data.defense,
				"speed": class_data.speed,

				"ability_name": class_data.ability_name,
				"ability_description": class_data.ability_description,

				"status": "alive"
			}
		],

		"reward_preview": {
			"shards": 20
		}
	}

	run_snapshot_changed.emit(get_run_snapshot())
	profile_changed.emit(get_profile_snapshot())

	var error_code := get_tree().change_scene_to_file(
		TEST_RUN_SCENE
	)

	if error_code != OK:
		ui_notice.emit(
			"No se pudo abrir la arena. Error: %d" % error_code
		)


# Simula daño al jugador local.
func simulate_damage(amount: int = 12) -> void:
	if run_snapshot.is_empty():
		return

	var players: Array = run_snapshot.get("players", [])

	if players.is_empty():
		return

	var player: Dictionary = players[0]
	var current_hp: int = int(player.get("hp", 0))
	var max_hp: int = int(player.get("max_hp", 100))

	player["hp"] = clampi(current_hp - amount, 0, max_hp)

	if int(player["hp"]) <= 0:
		player["status"] = "defeated"

	players[0] = player
	run_snapshot["players"] = players

	run_snapshot_changed.emit(get_run_snapshot())


# Simula la obtención de fragmentos.
func simulate_reward(amount: int = 10) -> void:
	if run_snapshot.is_empty():
		return

	var reward: Dictionary = run_snapshot.get(
		"reward_preview",
		{"shards": 0}
	)

	reward["shards"] = int(reward.get("shards", 0)) + amount
	run_snapshot["reward_preview"] = reward

	run_snapshot_changed.emit(get_run_snapshot())


# Regresa al menú principal.
func return_to_menu() -> void:
	var error_code := get_tree().change_scene_to_file(
		MAIN_MENU_SCENE
	)

	if error_code != OK:
		ui_notice.emit(
			"No se pudo abrir el menu. Error: %d" % error_code
		)
