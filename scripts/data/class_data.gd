
extends Resource
class_name ClassData

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

@export_group("Estadisticas")
@export var max_hp: int = 100
@export var attack: int = 10
@export var defense: int = 0
@export var speed: float = 100.0

@export_group("Habilidad")
@export var ability_name: String = ""
@export_multiline var ability_description: String = ""

@export_group("Visual")
@export var portrait: Texture2D
@export var character_sprite: Texture2D
