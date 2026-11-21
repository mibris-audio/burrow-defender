class_name HeartPickup
extends Area2D
## A heart that falls slowly from the sky. The rabbit grabs it to repair the burrow.

signal collected(heart)

var player: Node2D
var fall_speed := 130.0
var _sway_phase := 0.0


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
	var col := Color("e05a7a")
	draw_circle(Vector2(-6, -4), 7, col)
	draw_circle(Vector2(6, -4), 7, col)
	draw_colored_polygon(
		PackedVector2Array([Vector2(-12.2, -1), Vector2(12.2, -1), Vector2(0, 14)]),
		col
	)
