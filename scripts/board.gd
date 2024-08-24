extends Node2D

const PIXEL = preload("res://scenes/pixel.tscn")
const BOARD_SIZE = 144
var rng = RandomNumberGenerator.new()
@onready var pixels: Node = $Pixels

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_pixels()

func draw_pixels() -> void:
	for i in BOARD_SIZE:
		for j in BOARD_SIZE:
			var pixel =  PIXEL.instantiate()
			pixels.add_child(pixel)
			pixel.global_position = Vector2(j, -i)
			pixel.self_modulate = Color.AQUA



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
