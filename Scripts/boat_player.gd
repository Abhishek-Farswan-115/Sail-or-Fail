class_name Boat extends CharacterBody3D

@export_category("Parameters")
@export var speed: float = 12.0
@export var acceleration: float = 0.1

@export_category("Camera")
@export var camera_offset: Vector3 = Vector3(0.0, 4.0, 7.0)
@export var camera_follow_strength: float = 0.3
@export var camera_rotation_amount: float = 0.02
@export var camera_rotation_speed: float = 0.2

@export_category("Visuals")
@export var rotation_amount: float = 0.2
@export var rotation_speed: float = 0.15

@onready var mesh: Node3D = $lancha_low_poly
@onready var camera: Camera3D = $camera

var movement_input: float

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	camera.top_level = true

func _process(delta: float) -> void:
	poll_input()
	camera.global_position = lerp(camera.global_position, global_position + camera_offset, camera_follow_strength * delta * 60.0)
	camera.rotation.z = lerp(camera.rotation.z, -movement_input * camera_rotation_amount, camera_rotation_speed * delta * 60.0)
	mesh.rotation.y = lerp(mesh.rotation.y, -movement_input * rotation_amount, rotation_speed * delta * 60.0)
	mesh.rotation.z = lerp(mesh.rotation.z, movement_input * rotation_amount * 0.3, rotation_speed * delta * 60.0)

func poll_input() -> void:
	movement_input = 0.0
	if Input.is_action_pressed("move_left"):
		movement_input -= 1.0
	if Input.is_action_pressed("move_right"):
		movement_input += 1.0

func _physics_process(delta: float) -> void:
	velocity.x = lerp(velocity.x, movement_input * speed, acceleration * delta * 60.0)
	
	velocity.y = 0.0
	position.y = 0.0
	velocity.z = 0.0
	move_and_slide()
