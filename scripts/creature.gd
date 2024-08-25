class_name Creature
extends Resource

enum Type {PRED, PREY, NONE }

@export var max_health := 50

var health: int
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
		instance.type = Type.PRED
	return instance
	
func	 move(other:Creature) -> void:
	other.type = self.type
	other.health = self.health
	self.type = Type.NONE

func reproduce(other: Creature):
	other.health = 10;
	other.type = Type.PREY;

func heal(hp: int) -> void:
	self.health += hp

func update() ->void:
	match self.type:
		Type.PRED:
			self.heal(-1)
		Type.PREY:
			self.heal(1)
