extends Node2D

@onready var PixelsHolder: Node = $PixelsHolder

const PIXEL = preload("res://scenes/pixel.tscn")
const CREATURE = preload("res://resources/creature.tres")
const BOARD_SIZE = 200

var BG_COLOR := Color.html("#333333")
var PRED_COLOR := Color.html("#de2c2c")
var PREY_COLOR :=  Color.html("#4dab6b")
var rng = RandomNumberGenerator.new()

var board: Array
var pixels: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in BOARD_SIZE:
		pixels.append([])
		board.append([])
		for j in BOARD_SIZE:
			board[i].append(CREATURE.create_instance())
			var pixel = PIXEL.instantiate()
			PixelsHolder.add_child(pixel)
			pixel.global_position = Vector2(j + 1, -i)
			pixels[i].append(pixel)
	draw_pixels()
	
func draw_pixels() -> void:
	for i in BOARD_SIZE:
		for j in BOARD_SIZE:
			var creature: Creature = board[i][j]
			var pixel = pixels[i][j]
			if creature.type == creature.Type.PREY:
				pixel.self_modulate = PREY_COLOR
			elif creature.type == creature.Type.PRED:
				pixel.self_modulate = PRED_COLOR
			else:
				pixel.self_modulate = BG_COLOR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update()
	draw_pixels()

func update() -> void:
	for i in BOARD_SIZE:
		for j in BOARD_SIZE:
			var curr: Creature = board[i][j]
			if curr.type == Creature.Type.NONE:
				continue
			var _x_off = rng.randi_range(-1,1)
			var _y_off = rng.randi_range(-1,1)
			var _x_adjusted = i + _x_off
			var _y_adjusted = j + _y_off
			
			if _x_adjusted < 0 || _x_adjusted >= BOARD_SIZE - 1: continue;
			if _y_adjusted < 0 || _y_adjusted >= BOARD_SIZE - 1: continue;
			
			var other: Creature = board[_x_adjusted][_y_adjusted]
			curr.move(other)
