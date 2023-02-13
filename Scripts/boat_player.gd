class_name Boat extends CharacterBody3D

signal lives_lost
signal lives_changed(new_lives: int)

@export_category("Parameters")
@export var speed: float = 12.0
@export var acceleration: float = 0.1
@export var lives: int = 3:
	set(val):
		lives = val
		lives_changed.emit(val)

@export_category("Camera")
@export var camera_offset: Vector3 = Vector3(0.0, 4.0, 7.0)
@export var camera_follow_strength: float = 0.3
@export var camera_rotation_amount: float = 0.02
@export var camera_rotation_speed: float = 0.2

@export_category("Visuals")
@export var rotation_amount: float = 0.2
@export var rotation_speed: float = 0.15

@onready var mesh: Node3D = $Boat_1
@onready var camera: Camera3D = $camera

#camera vars
var camera_basis: Basis
var camera_default_rot: Vector3
var trauma : float
var shake_offset: Vector3
var camera_noise: FastNoiseLite

var default_position: float
var movement_input: float

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	
	camera.top_level = true
	camera_default_rot = camera.rotation
	camera_noise = FastNoiseLite.new()
	camera_noise.noise_type =FastNoiseLite.TYPE_PERLIN
	
	default_position = position.z

func _process(delta: float) -> void:
	poll_input()
	
	camera.global_position = lerp(camera.global_position, global_position + camera_offset, camera_follow_strength * delta * 60.0)
	camera_basis = Basis.from_euler(Vector3(camera_default_rot.x, camera_default_rot.y, lerp(camera.rotation.z, -movement_input * camera_rotation_amount, camera_rotation_speed * delta * 60.0)))
	_update_camera_shake(delta)
	camera.global_transform.basis = camera_basis * Basis.from_euler(shake_offset)
	
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
	
	position.z = default_position

func _update_camera_shake(delta: float) -> void:
	trauma = clamp(trauma - delta, 0.0, 1.0)
	shake_offset.x = camera_noise.get_noise_3d(Time.get_ticks_msec(), 0.0, 0.0)
	shake_offset.y = camera_noise.get_noise_3d(0.0, Time.get_ticks_msec(), 0.0)
	shake_offset.z = camera_noise.get_noise_3d(0.0, 0.0, Time.get_ticks_msec())
	var intensity = trauma*trauma
	shake_offset*=intensity

func shake_camera(intensity: float, cap: float = 1.0) -> void:
	trauma = clamp(trauma + intensity, 0.0, cap)

func _on_cd_body_entered(body: Node3D) -> void:
	if body.is_in_group("obstacle"):
		shake_camera(0.5)
		lives -= 1
		if lives <= 0: lives_lost.emit()
