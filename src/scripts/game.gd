# game.gd
# Written by cogos18

class_name Game extends Node


@onready var node_2d = $Node2D
@onready var player: Player = $Node2D/Player
@onready var score_display: Label = $HUD/Control/ScoreDisplay


var score: int = 0

signal game_over

# Move all objects to the left so that it...
# looks like the player is moving forwards. 
func _handle_movement(delta: float) -> void:
	if node_2d.process_mode == Node.PROCESS_MODE_DISABLED:
		pass
	
	var child_nodes := node_2d.get_children()
	
	for node in child_nodes:
		if node_2d.process_mode == Node.PROCESS_MODE_DISABLED:
			break
		
		if node is Coin or node is Hazard:
			node.position.x -= player.vel * delta
		


func _game_over(points: int) -> void:
	player.vel = 0
	player.sprite.play("hit")
	node_2d.process_mode = Node.PROCESS_MODE_DISABLED
	$ObjectSpawner.process_mode = Node.PROCESS_MODE_DISABLED
	GameOverScreen.show()
	GameOverSound.play()
	Log.info("Game over!")
	


func add_point(amount: int) -> void:
	score += amount


func _on_coin_collected(value: int) -> void:
	CollectSound.play()
	
	add_point(value)


func _update_score() -> void:
	score_display.text = str(score)


func _connect_signals_to_objects() -> void:
	var nodes = node_2d.get_children()
	
	
	for node: Node2D in nodes:
		if !node.tree_exiting.is_connected(Log.info.bind(str(node.get_path()) + " freed.")):
			node.tree_exiting.connect(Log.info.bind(str(node.get_path()) + " freed."))
		
		if node is Coin and !node.collected.is_connected(_on_coin_collected.bind(node.value)):
			node.collected.connect(_on_coin_collected.bind(node.value))
		
		
		if node is Hazard and !node.hit.is_connected(game_over.emit):
			node.hit.connect(game_over.emit)
		
		if node is Hazard and !node.player_jumped_over.is_connected(_on_coin_collected.bind(100)):
			node.player_jumped_over.connect(_on_coin_collected.bind(100))


func _ready() -> void:
	game_over.connect(_game_over.bind(score))
	_connect_signals_to_objects()
	   
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and OS.has_feature("pc"):
		get_tree().quit()
	
	
	add_point(1 * int(player.vel / 100))
	
	_connect_signals_to_objects()
	_handle_movement(delta)
	_update_score()
