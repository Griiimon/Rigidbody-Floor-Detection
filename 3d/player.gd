class_name Player3D
extends RigidBody3D

# Settings in the Inspector
# 	Physics Material Friction: 0  ( slide )
# 	Can Sleep: off  ( always simulate this RB, even when not moving )
#	Lock Rotation: on  ( keep RB upright )
#	Continous Collision Detection: Cast Shape
#		( most precise collision detection )
#	Contact Monitor: on  ( collisions will be reported )
#	Max Contact Reported: 3  ( up to 3 collisions will be reported )


@export var move_speed: float= 50.0
@export var jump_strength: float= 5.0

# maximum angle ( compared to up vector ) where the contact collider
# is consider a floor
@export var max_slope_angle: float= 45.0

var is_on_floor: bool= false
var floor_dot_threshold: float



func _ready() -> void:
	# convert the max_slope_angle into a value that works
	# with the dot product
	floor_dot_threshold= cos(deg_to_rad(max_slope_angle))


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and is_on_floor:
		apply_central_impulse(jump_strength * Vector3.UP)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	is_on_floor= false
	
	# loop through all reported collisions 
	for coll_idx in state.get_contact_count():
		# get the normal of each collision
		var floor_normal: Vector3= state.get_contact_local_normal(coll_idx)
	
		# compare the dot product of that normal and the up vector
		# with our converted max_slope_angle threshold 
		if floor_normal.dot(Vector3.UP) > floor_dot_threshold:
			is_on_floor= true

	if is_on_floor:
		# as long as we are on the floor we control the movement
		# ( also means character will stop when nothing is pressed
		#   since linear_velocity.x will be 0 )
		# while not on floor we will slide due to 0 friction in the
		# physics material settings and linear_velocity controlled by 
		# the physics engine
		state.linear_velocity.x= Input.get_axis("ui_left", "ui_right") * move_speed
