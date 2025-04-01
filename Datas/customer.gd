extends Resource
class_name Customer

@export var name: String
@export var dialog: String
@export var character_scene: PackedScene
@export var order: Dictionary[MenuItem, int]
