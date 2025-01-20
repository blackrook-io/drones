extends Node3D

## TODO:  Use cases that might potentially be future issues or bugs:
##        - Camera near or off the terrain edge.
##        - Camera dropping into buildings and having clipping issues.
##        - Camera dropping below terrain and having clipping issues.

# Camera movement
@export_range(0, 100, 1) var camera_move_speed : float = 20.0

# Camera panning
@export_range(0, 32, 4) var camera_auto_pan_margin : int = 16
@export_range(0, 20, 0.5) var camera_auto_pan_speed : float = 12.0

# Camera rotation
var camera_rotation_direction : int = 0
var camera_socket_rotation_direction : int = 0
@export_range(0, 10, 0.1) var camera_rotation_speed : float = 4.0
@export_range(0, 10, 1) var camera_socket_rotation_x_min : float = -1.20
@export_range(0, 10, 1) var camera_socket_rotation_x_max : float = -0.20

# Camera zoom
var camera_zoom_direction : float = 0.0
@export_range(0, 100, 1) var camera_zoom_speed : float = 40.0
@export_range(0, 100, 1) var camera_zoom_min : float = 1.0
@export_range(0, 100, 1) var camera_zoom_max : float = 25.0
@export_range(0, 2, 0.1) var camera_zoom_speed_dampener : float = 0.95 

# Flags
var camera_can_move_base : bool = true
var camera_can_process : bool = true
var camera_can_zoom : bool = true
var camera_can_pan : bool = true
var camera_can_rotate : bool = true
var camera_can_rotate_socket_x : bool = true
var camera_can_rotate_by_mouse_offset : bool = true

# Internal Flags
var camera_is_rotating_base : bool = false
var camera_is_rotating_mouse : bool = false
var mouse_last_position : Vector2 = Vector2.ZERO


# Nodes
@onready var camera_socket : Node3D = $camera_socket
@onready var camera : Camera3D = $camera_socket/Camera


func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	if not camera_can_process:
		return
		
	camera_base_move(delta)
	camera_zoom_update(delta)
	camera_auto_pan(delta)
	camera_base_rotate(delta)
	camera_rotate_to_mouse_offsets(delta)
	
	
func _unhandled_input(event: InputEvent) -> void:
	# Camera zoom
	if event.is_action("camera_zoom_in"): 
		camera_zoom_direction = -1
	elif event.is_action("camera_zoom_out"):
		camera_zoom_direction = 1
	
	if event.is_action("camera_rotate_left"):
		camera_rotation_direction = 1
		camera_is_rotating_base = true
	elif event.is_action("camera_rotate_right"): 
		camera_rotation_direction = -1
		camera_is_rotating_base = true
	elif event.is_action_released("camera_rotate_left") or event.is_action_released("camera_rotate_right"):
		camera_is_rotating_base = false

	if event.is_action_pressed("camera_rotate"):
		mouse_last_position = get_viewport().get_mouse_position()
		camera_is_rotating_mouse = true
	elif event.is_action_released("camera_rotate"):
		camera_is_rotating_mouse = false


# Moves the base of the camera with WASD.
func camera_base_move(delta : float) -> void:
	if not camera_can_move_base:
		return
	
	var velocity_direction : Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("camera_forward"): 	velocity_direction -= transform.basis.z
	if Input.is_action_pressed("camera_backward"): 	velocity_direction += transform.basis.z
	if Input.is_action_pressed("camera_left"): 		velocity_direction -= transform.basis.x
	if Input.is_action_pressed("camera_right"): 	velocity_direction += transform.basis.x

	position += velocity_direction.normalized() * camera_move_speed * delta
	
	# TODO: Movement should raycast to the terrain and reset the height of the camera_base
	#       object so that it stays a set altitude above the terrain.


# Controls the zoom of the camera.
func camera_zoom_update(delta : float) -> void:
	if not camera_can_zoom:
		return
	
	var new_zoom : float = clamp(camera.position.z + (camera_zoom_speed * camera_zoom_direction * delta), camera_zoom_min, camera_zoom_max)
	camera.position.z = new_zoom
	camera_zoom_direction *= camera_zoom_speed_dampener


# Rotate the camera socket based on the mouse offset.
func camera_rotate_to_mouse_offsets(delta : float) -> void:
	if not camera_can_rotate_by_mouse_offset or not camera_is_rotating_mouse:
		return
	
	var mouse_offset : Vector2 = get_viewport().get_mouse_position()
	mouse_offset = mouse_offset - mouse_last_position
	mouse_last_position = get_viewport().get_mouse_position()
	
	camera_base_rotate_left_right(delta, mouse_offset.x * 0.1)
	camera_socket_rotate_x(delta, mouse_offset.y * 0.1)

# Rotate camera on the Y axis around the point where the camera is facing on the ground.
func camera_base_rotate(delta : float) -> void:
	if not camera_can_rotate or not camera_is_rotating_base:
		return 
	
	camera_base_rotate_left_right(delta, camera_rotation_direction * camera_rotation_speed)
	camera_rotation_direction = 0


# Rotates the camera up or down, within clamp limits.
func camera_socket_rotate_x(delta : float, dir : float) -> void: 
	if not camera_can_rotate_socket_x:
		return
		
	var new_rotation_x : float = camera_socket.rotation.x
	new_rotation_x -= dir * delta * camera_rotation_speed
	new_rotation_x = clamp(new_rotation_x, camera_socket_rotation_x_min, camera_socket_rotation_x_max)
	camera_socket.rotation.x = new_rotation_x


# Rotates the camera_base left or right
func camera_base_rotate_left_right(delta : float, dir : float) -> void:
	rotation.y += dir * delta * camera_rotation_speed


# Pans the camera automatically if the mouse nears the edge of the window.
func camera_auto_pan(delta : float) -> void:
	if not camera_can_pan:
		return
	
	var viewport_current : Viewport = get_viewport()
	var pan_direction : Vector2 = Vector2(-1, -1)  # Start at negative values
	var viewport_visible_rectangle : Rect2i = Rect2i(viewport_current.get_visible_rect())
	var viewport_size : Vector2i = viewport_visible_rectangle.size
	var current_mouse_position : Vector2 = viewport_current.get_mouse_position()
	var zoom_factor : float = camera.position.z * 0.1
	
	# Panning on the X axis
	if ( (current_mouse_position.x < camera_auto_pan_margin) or (current_mouse_position.x > viewport_size.x - camera_auto_pan_margin) ):
		if ( current_mouse_position.x > (viewport_size.x / 2.0) ):   # If on the left half of the screen.
			pan_direction.x = 1
		translate(Vector3(pan_direction.x * delta * camera_auto_pan_speed * zoom_factor, 0, 0))
	
	# Panning on the Y axis on the screen, but Z axis in the game world.
	if ( (current_mouse_position.y < camera_auto_pan_margin) or (current_mouse_position.y > viewport_size.y - camera_auto_pan_margin) ):
		if ( current_mouse_position.y > (viewport_size.y / 2.0) ):   # If on the top half of the screen.
			pan_direction.y = 1
		translate(Vector3(0, 0, pan_direction.y * delta * camera_auto_pan_speed * zoom_factor))
