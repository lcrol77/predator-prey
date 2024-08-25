extends Node2D

@onready var pixels: Node = $Pixels

const PIXEL = preload("res://scenes/pixel.tscn")
const CREATURE = preload("res://resources/creature.tres")
const BOARD_SIZE = 144
var BG_COLOR := Color.html("#333333")
var PRED_COLOR := Color.html("#de2c2c")
var PREY_COLOR :=  Color.html("#4dab6b")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_pixels()
	
func draw_pixels() -> void:
	for i in BOARD_SIZE:
		for j in BOARD_SIZE:
			var pixel =  PIXEL.instantiate()
			pixels.add_child(pixel)
			pixel.global_position = Vector2(j + 1, -i)
			var number = rng.randi_range(-1,1)
			if number == -1:
				pixel.self_modulate = BG_COLOR
			elif number == 0:
				pixel.self_modulate = PRED_COLOR
			else:
				pixel.self_modulate = PREY_COLOR


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
