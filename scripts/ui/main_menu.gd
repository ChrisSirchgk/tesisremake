
extends Control

@onready var class_option: OptionButton = \
	$Center/MenuPanel/MarginContainer/MenuColumn/ClassOption

@onready var profile_label: Label = \
	$Center/MenuPanel/MarginContainer/MenuColumn/ProfileLabel

@onready var notice_label: Label = \
	$Center/MenuPanel/MarginContainer/MenuColumn/NoticeLabel

@onready var play_button: Button = \
	$Center/MenuPanel/MarginContainer/MenuColumn/PlayButton

@onready var quit_button: Button = \
	$Center/MenuPanel/MarginContainer/MenuColumn/QuitButton


# Nombre visible e identificador interno de cada clase.
const CLASSES := [
	{"name": "Thief", "id": "thief"},
	{"name": "Mage", "id": "mage"},
	{"name": "Tank", "id": "tank"}
]


func _ready() -> void:
	print("Menu iniciado")

	class_option.clear()

	for character_class in CLASSES:
		var index := class_option.item_count
		class_option.add_item(character_class["name"])
		class_option.set_item_metadata(
			index,
			character_class["id"]
		)

	class_option.select(0)

	# Desbloquear las cuatro clases para las pruebas.
	# Así se modifica el perfil actual de GameState.
	var unlocked: Array = GameState.profile.get(
		"unlocked_classes", []
	)

	for character_class in CLASSES:
		var class_id: String = character_class["id"]

		if not unlocked.has(class_id):
			unlocked.append(class_id)

	GameState.profile["unlocked_classes"] = unlocked

	var profile: Dictionary = GameState.get_profile_snapshot()

	profile_label.text = "JUGADOR: %s  |  FRAGMENTOS: %d" % [
		profile.get("display_name", "Explorador"),
		int(profile.get("shards", 0))
	]

	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	GameState.ui_notice.connect(_on_ui_notice)


func _on_play_pressed() -> void:
	var selected_index := class_option.get_selected()

	if selected_index < 0:
		notice_label.text = "Selecciona una clase."
		return

	var class_id := str(
		class_option.get_item_metadata(selected_index)
	)

	print("Clase seleccionada: ", class_id)

	GameState.start_demo_run(class_id)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_ui_notice(message: String) -> void:
	notice_label.text = message
