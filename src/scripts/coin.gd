# hazard.gd
# Written by cogos18

class_name Coin extends Node2D


@onready var hitbox: Area2D = $HitBox
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var value: int = 100

signal collected


func _handle_collisions() -> void:
	var colliders = hitbox.get_overlapping_bodies()
	
	for collider in colliders:
		if collider is Player:
			collected.emit()
			queue_free()


func _snap_to_pixel() -> void:
	position = Vector2(
		snappedf(position.x, 2.5),
		snappedf(position.y, 2.5)
	)

func _disappear_once_off_screen() -> void:
	if (!visible_on_screen_notifier.is_on_screen() and position.x <= -300):
		queue_free()


func _process(_delta: float) -> void:
	_disappear_once_off_screen()
	_handle_collisions()


func _physics_process(delta: float) -> void:
	_snap_to_pixel()
