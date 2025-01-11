extends Node3D

@onready var player: Player3D = $Player
@onready var label: Label = $CanvasLayer/Label



func _process(delta: float) -> void:
	label.visible= player.is_on_floor
