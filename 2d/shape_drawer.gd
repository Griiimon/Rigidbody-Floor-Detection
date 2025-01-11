extends StaticBody2D

@export var color: Color= Color.GREEN



func _ready() -> void:
	var coll_shape: CollisionShape2D= get_child(0)
	await get_tree().process_frame
	coll_shape.shape.draw(get_canvas_item(), color)
