class_name Creature
extends Resource

enum Type {PRED, PREY, NONE }

@export var max_health := 50

var health: int: set = set_health
var type: int
var rand = RandomNumberGenerator.new()

func create_instance() -> Resource:
	var instance: Creature = self.duplicate()
	instance.health = max_health / 5
	var roll := rand.randi_range(0,100)
	if roll > 10:
		instance.type =  Type.NONE
	elif roll > 5:
		instance.type = Type.PREY
	else:
		instance.type = Type.PREY
	return instance
	
func set_health(value : int) -> void:
	health = clampi(value, 0, max_health)
