# object_spawner.gd
# Written by cogos18

class_name ObjectSpawner extends Node

@export var hazard_table: Array[Node2D] = []


@onready var cooldown_timer: Timer = $CooldownTimer


func _spawn_object(path: String, pos: Vector2) -> void:
	var obj = load(path).instantiate()
	owner.get_node("Node2D").add_child(obj)
	obj.position = pos

func _when_cooldown_ended() -> void:
	cooldown_timer.wait_time = randf_range(0.75, 1.0) * (owner.player.vel / 1000)
	var chance: int = randi_range(-1, 1)
	
	if chance == 0:
		chance = 1
	
	if chance < 0:
		_spawn_object("res://scenes/hazard.tscn", Vector2(852.0, 544.0))
		await get_tree().create_timer(0.5).timeout
	
	if chance > 0:
		var rate: int = randi_range(1, 5)
		var random_position: float = snappedf(randf_range(480, 544), 1)
		
		for i in rate:
			_spawn_object("res://scenes/coin.tscn", Vector2(852.0, random_position))
			await get_tree().create_timer(0.15).timeout
	
	cooldown_timer.start()
