
extends CanvasLayer

const CLASS_NAMES := {
	"Thief": "Ladron",
	"Cleric": "Clerigo",
	"Mage": "Mago",
	"Tank": "Tanque"
}

@onready var stats_column: VBoxContainer = \
	$Root/TopLeft/StatsColumn

@onready var player_name_label: Label = \
	$Root/TopLeft/PlayerName

@onready var class_label: Label = \
	$Root/TopLeft/ClassLabel

@onready var health_bar: ProgressBar = \
	$Root/TopLeft/HealthBar

@onready var health_text: Label = \
	$Root/TopLeft/HealthText

@onready var room_label: Label = \
	$Root/TopCenter/RoomLabel

@onready var reward_label: Label = \
	$Root/TopRight/RewardLabel

@onready var damage_button: Button = \
	$Root/DebugPanel/DebugRow/DamageButton

@onready var reward_button: Button = \
	$Root/DebugPanel/DebugRow/RewardButton

@onready var menu_button: Button = \
	$Root/DebugPanel/DebugRow/MenuButton


func _ready() -> void:
	print("HUD INICIADO")

	GameState.run_snapshot_changed.connect(
		_on_run_snapshot_changed
	)

	# Conectar los botones.
	damage_button.pressed.connect(_on_damage_pressed)
	reward_button.pressed.connect(_on_reward_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

	# Escuchar cambios en la partida.
	if not GameState.run_snapshot_changed.is_connected(
		_on_run_snapshot_changed
	):
		GameState.run_snapshot_changed.connect(
			_on_run_snapshot_changed
		)

	# Cargar los datos existentes.
	var snapshot: Dictionary = GameState.get_run_snapshot()

	if snapshot.is_empty():
		_show_empty_state()
	else:
		_on_run_snapshot_changed(snapshot)


func _show_empty_state() -> void:
	player_name_label.text = "Jugador: Explorador"
	class_label.text = "Clase: Sin seleccionar"

	health_bar.max_value = 100
	health_bar.value = 100
	health_text.text = "Vida: 100 / 100"

	room_label.text = "OLA --\nTIEMPO --:--"

	var profile: Dictionary = GameState.get_profile_snapshot()
	reward_label.text = "Fragmentos: %d\nBotín pendiente: +0" % \
		int(profile.get("shards", 0))


func _on_run_snapshot_changed(snapshot: Dictionary) -> void:
	var players: Array = snapshot.get("players", [])
	var local_player_id: String = str(
		snapshot.get("local_player_id", "")
	)

	var player_data: Dictionary = {}

	# Buscar al jugador local.
	for candidate in players:
		var player: Dictionary = candidate

		if str(player.get("player_id", "")) == local_player_id:
			player_data = player
			break

	# Respaldo para partidas de un jugador.
	if player_data.is_empty() and not players.is_empty():
		player_data = players[0]

	if player_data.is_empty():
		_show_empty_state()
		return

	# Nombre y clase.
	var player_name := str(
		player_data.get("display_name", "Explorador")
	)
	var class_id := str(
		player_data.get("class_id", "unknown")
	)

	player_name_label.text = player_name
	class_label.text = "Clase: %s" % str(
		CLASS_NAMES.get(class_id, class_id)
	)

	# Vida.
	var max_hp := maxi(
		1, int(player_data.get("max_hp", 100))
	)
	var hp := clampi(
		int(player_data.get("hp", 0)), 0, max_hp
	)

	health_bar.max_value = max_hp
	health_bar.value = hp
	health_text.text = "Vida: %d / %d" % [hp, max_hp]

	# Ola y tiempo.
	var wave := int(snapshot.get("wave", 1))
	var elapsed := int(snapshot.get("elapsed_seconds", 0))

	room_label.text = "OLA %02d\nTIEMPO %02d:%02d" % [
		wave,
		int(elapsed / 60),
		elapsed % 60
	]

	# Fragmentos y recompensa pendiente.
	var profile: Dictionary = GameState.get_profile_snapshot()
	var reward: Dictionary = snapshot.get("reward_preview", {})

	reward_label.text = "Fragmentos: %d\nBotín pendiente: +%d" % [
		int(profile.get("shards", 0)),
		int(reward.get("shards", 0))
	]


func _on_damage_pressed() -> void:
	print("Botón Simular Daño presionado")
	GameState.simulate_damage(12)


func _on_reward_pressed() -> void:
	GameState.simulate_reward(10)


func _on_menu_pressed() -> void:
	GameState.return_to_menu()
