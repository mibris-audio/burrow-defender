class_name Carrot
extends Area2D
## A carrot projectile. Flies in a straight line and pops foxes.

const SPEED := 650.0

var _dir := Vector2.UP


func setup(dir: Vector2) -> void:
	_dir = dir.normalized()


func _ready() -> void:
	area_entered.connect(_on_area_entered)

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 9.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	position += _dir * SPEED * delta
	if position.y < -40 or position.x < -40 or position.x > 760:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("foxes"):
		area.take_hit()
		queue_free()


func _draw() -> void:
	# Pointy carrot body with two little leaves.
	draw_colored_polygon(
		PackedVector2Array([Vector2(-5, 12), Vector2(5, 12), Vector2(0, -16)]),
		Color("e88030")
	)
	draw_line(Vector2(0, 12), Vector2(-6, 22), Color("3f9b4f"), 3.0)
	draw_line(Vector2(0, 12), Vector2(6, 22), Color("3f9b4f"), 3.0)
