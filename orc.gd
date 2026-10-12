extends CharacterBody2D

@export var speed: float = 40.0
@export var contact_damage: int = 1
@export var hit_cooldown: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: Health = $Health
@onready var contact_area: Area2D = $ContactArea

var player: Node2D
var knockback := Vector2.ZERO
var cooldown := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health.died.connect(queue_free)
	
func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	var dir := global_position.direction_to(player.global_position)
	velocity = dir * speed + knockback
	knockback = knockback.move_toward(Vector2.ZERO, 500.0 * delta)
	move_and_slide()
	
	sprite.flip_h = dir.x < 0.0
	sprite.play("run")
	
	cooldown = max(cooldown - delta, 0.0)
	if cooldown == 0.0:
		for body in contact_area.get_overlapping_bodies():
			if body.has_method("take_hit"):
				body.take_hit(contact_damage, global_position)
				cooldown = hit_cooldown

func take_hit(amount: int, from: Vector2) -> void:
	knockback = from.direction_to(global_position) * 150.0
	sprite.modulate = Color(1, .3, .3)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, .2)
	health.take_damage(amount)
	
