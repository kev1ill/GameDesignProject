class_name Health
extends Node

signal changed(current: int, maximum: int)
signal died

@export var max_health: int = 6
var current: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = max_health

func take_damage(amount: int) -> void:
	if current <= 0:
		return
	current = max(current - amount, 0)
	changed.emit(current, max_health)
	if current == 0:
		died.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
