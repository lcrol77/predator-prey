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

# this probably can be offloaded to the GPU
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
			var _i_off = rng.randi_range(-1,1)
			var _j_off = rng.randi_range(-1,1)
			var _i_adjusted = i + _i_off
			var _j_adjusted = j + _j_off
			
			if _i_adjusted < 0 || _i_adjusted >= BOARD_SIZE: continue;
			if _j_adjusted < 0 || _j_adjusted >= BOARD_SIZE: continue;
			
			var other: Creature = board[_i_adjusted][_j_adjusted]
			curr.update()
			match curr.type:
				Creature.Type.PRED:
					update_pred(curr, other)
				Creature.Type.PREY:
					update_prey(curr, other)

func update_prey(curr: Creature, other: Creature) -> void:
	var otherType = other.type
	var reproduce = false
	if curr.health > curr.max_health:
		curr.health = 10
		reproduce = true
	match otherType:
		Creature.Type.PRED: return
		Creature.Type.PREY: return
		Creature.Type.NONE:
			if reproduce:
				curr.reproduce(other)
			else:
				curr.move(other)

func update_pred(curr: Creature, other: Creature) -> void:
	if curr.health <=0:
		curr.type = Creature.Type.NONE
		return
	var otherType = other.type
	match otherType:
		Creature.Type.PRED: return
		Creature.Type.PREY: 
			other.type = Creature.Type.PRED
			curr.heal(other.health)
		Creature.Type.NONE:
			curr.move(other)
