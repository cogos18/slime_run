# player.gd
# Written by cogos18

class_name Player extends CharacterBody2D


@export var initial_velocity: float = 650.0
@export var acceleration: float = 2.5
@export var jump_height: float = 450.0


@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var jump_timer: Timer = $JumpTimer
@onready var sprite: AnimatedSprite2D = $Sprite

var can_jump := true
var vel: float = initial_velocity


# Function that makes the player jump when called
func _jump(jump_height: float) -> void:
	if !can_jump:
		return
	
	if jump_timer.is_stopped():
		JumpSound.stop()
		CollectSound.stop()
		JumpSound.play()
		jump_timer.start()
	
	velocity.y = -jump_height


func _ready() -> void:
	jump_timer.timeout.connect(func() -> void: can_jump = false)


func _handle_gravity(gravity: float, delta: float) -> void:
	if is_on_floor():
		can_jump = true
		sprite.play("grounded")
		return
	else:
		sprite.play("midair")
	
	velocity.y += gravity * delta

func _handle_input() -> void:
	if Input.is_action_just_released("jump"):
		jump_timer.stop()
		can_jump = false
	
	if Input.is_action_pressed("jump"):
		jump()


func jump() -> void:
	_jump(jump_height)


func _snap_to_pixel() -> void:
	position = Vector2(
		snappedf(position.x, 2.5),
		snappedf(position.y, 2.5)
	)


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	vel += acceleration * delta
	
	_handle_gravity(gravity, delta)
	_handle_input()
	_snap_to_pixel()
