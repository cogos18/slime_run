# hazard.gd
# Written by cogos18

class_name Hazard extends Node2D


@onready var hitbox: Area2D = $HitBox
@onready var top_area: Area2D = $TopArea


signal player_jumped_over
signal hit


func _handle_collisions() -> void:
	var colliders = hitbox.get_overlapping_bodies()
	
	for collider in colliders:
		if collider is Player:
			hit.emit()


func _when_player_jumped_over(body: Node2D) -> void:
	if body is Player:
		player_jumped_over.emit()


func _snap_to_pixel() -> void:
	position = Vector2(
		snappedf(position.x, 2.5),
		snappedf(position.y, 2.5),
	)

func _process(_delta: float) -> void:
	if !top_area.body_entered.is_connected(_when_player_jumped_over):
		top_area.body_entered.connect(_when_player_jumped_over)
	
	_handle_collisions()


func _physics_process(delta: float) -> void:
	_snap_to_pixel()
