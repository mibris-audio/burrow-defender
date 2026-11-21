class_name Fox
extends Area2D
## A fox that shuffles toward the burrow, meandering as it goes, then gnaws.

signal reached_burrow(fox)
signal killed(fox)

const BITE_DAMAGE := 1
const BITE_INTERVAL := 0.7

var speed := 120.0
var hp := 2
var sway_phase := 0.0
var _bite_timer := BITE_INTERVAL
var _target := Vector2.ZERO
var _hit_flash := 0.0
var _reached := false


func setup(target: Vector2) -> void:
	_target = target


func _ready() -> void:
	add_to_group("foxes")
	speed = randf_range(90.0, 160.0)
	sway_phase = randf() * TAU

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 20.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	_hit_flash = maxf(_hit_flash - delta, 0.0)

	var to_target := _target - position
	if to_target.length() > 24.0:
		position += to_target.normalized() * speed * delta
		position.x += sin(sway_phase + position.y * 0.02) * 40.0 * delta
	else:
		if not _reached:
			_reached = true
		_bite_timer -= delta
		if _bite_timer <= 0.0:
			_bite_timer = BITE_INTERVAL
			reached_burrow.emit(self)

	queue_redraw()


func take_hit() -> void:
	hp -= 1
	_hit_flash = 0.15
	if hp <= 0:
		killed.emit(self)
		queue_free()


func _draw() -> void:
	var body_col := Color("d96f32") if _hit_flash <= 0.0 else Color("ffffff")
	var dark := Color("7c3f1d") if _hit_flash <= 0.0 else Color("aaaaaa")
	var cream := Color("f2ead8")

	# Tail with a white tip.
	draw_circle(Vector2(-26, 14), 12, body_col)
	draw_circle(Vector2(-34, 18), 7, cream)
	# Body and head.
	draw_circle(Vector2(0, 10), 20, body_col)
	draw_circle(Vector2(0, -10), 14, body_col)
	# Pointy ears.
	draw_colored_polygon(_tri(Vector2(-13, -18), Vector2(-5, -27), Vector2(-2, -15)), dark)
	draw_colored_polygon(_tri(Vector2(13, -18), Vector2(5, -27), Vector2(2, -15)), dark)
	# Muzzle and nose.
	draw_circle(Vector2(0, -3), 6, cream)
	draw_circle(Vector2(0, -6), 1.8, Color("1c120a"))
	# Eyes.
	draw_circle(Vector2(-5, -13), 2, Color("1c120a"))
	draw_circle(Vector2(5, -13), 2, Color("1c120a"))
	# Paws (only while still walking).
	if not _reached:
		draw_line(Vector2(-8, 26), Vector2(-8, 32), dark, 4.0)
		draw_line(Vector2(8, 26), Vector2(8, 32), dark, 4.0)


func _tri(a: Vector2, b: Vector2, c: Vector2) -> PackedVector2Array:
	return PackedVector2Array([a, b, c])
