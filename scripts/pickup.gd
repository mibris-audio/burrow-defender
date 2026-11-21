class_name Pickup
extends Area2D
## A pickup that falls slowly from the sky.
## Hearts repair the burrow; upgrade crates improve the rabbit's weapon.

signal collected(pickup)

const HEART := "heart"
const UPGRADE := "upgrade"

var kind := HEART
var upgrade_type := ""  # "fire_rate" or "multishot" for upgrade drops
var player: Node2D
var fall_speed := 130.0
var _sway_phase := 0.0


func setup_upgrade(type: String) -> void:
	kind = UPGRADE
	upgrade_type = type


func _ready() -> void:
	fall_speed = randf_range(100.0, 150.0)
	_sway_phase = randf() * TAU

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 16.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta
	position.x += sin(_sway_phase + position.y * 0.01) * 20.0 * delta

	if position.y > 1000:
		queue_free()
		return

	if player and position.distance_to(player.position) < 34.0:
		collected.emit(self)
		queue_free()


func _draw() -> void:
	if kind == UPGRADE:
		_draw_crate()
	else:
		_draw_heart()


func _draw_heart() -> void:
	var col := Color("e05a7a")
	draw_circle(Vector2(-6, -4), 7, col)
	draw_circle(Vector2(6, -4), 7, col)
	draw_colored_polygon(
		PackedVector2Array([Vector2(-12.2, -1), Vector2(12.2, -1), Vector2(0, 14)]),
		col
	)


func _draw_crate() -> void:
	var base := Color("c8862a")
	draw_rect(Rect2(-13, -13, 26, 26), Color("8a5a1a"))
	draw_rect(Rect2(-10, -10, 20, 20), base)
	# White up arrow to signal a power-up.
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(0, -7), Vector2(7, 1), Vector2(3, 1),
			Vector2(3, 7), Vector2(-3, 7), Vector2(-3, 1), Vector2(-7, 1),
		]),
		Color.WHITE
	)
