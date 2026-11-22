class_name BossFox
extends Area2D
## The Alpha Fox: a big boss fox that strafes above the meadow and dives at the burrow.

signal reached_burrow(boss)
signal killed(boss)

const MAX_HP := 40
const HOVER_Y := 150.0
const STRAFE_SPEED := 150.0
const DIVE_SPEED := 430.0
const RETURN_SPEED := 260.0
const DIVE_DELAY := 4.0
const TELEGRAPH_TIME := 0.7
const STRAFE_MIN_X := 110.0
const STRAFE_MAX_X := 610.0
const HOME_X := 360.0

var hp := MAX_HP
var state := "enter"
var _target := Vector2.ZERO
var _strafe_dir := 1
var _dive_timer := DIVE_DELAY
var _telegraph_timer := 0.0
var _flash := 0.0
var _bob_phase := 0.0


func setup(target: Vector2) -> void:
	_target = target


func _ready() -> void:
	add_to_group("foxes")
	_bob_phase = randf() * TAU

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 46.0
	shape.shape = circle
	add_child(shape)


func _physics_process(delta: float) -> void:
	_flash = maxf(_flash - delta, 0.0)

	match state:
		"enter":
			position.y += 130.0 * delta
			if position.y >= HOVER_Y:
				position.y = HOVER_Y
				state = "strafe"
		"strafe":
			_bob_phase += delta
			position.x += _strafe_dir * STRAFE_SPEED * delta
			position.y = HOVER_Y + sin(_bob_phase * 2.2) * 14.0
			if position.x <= STRAFE_MIN_X or position.x >= STRAFE_MAX_X:
				position.x = clampf(position.x, STRAFE_MIN_X, STRAFE_MAX_X)
				_strafe_dir *= -1
			_dive_timer -= delta
			if _dive_timer <= 0.0:
				state = "telegraph"
				_telegraph_timer = TELEGRAPH_TIME
		"telegraph":
			_telegraph_timer -= delta
			if _telegraph_timer <= 0.0:
				state = "dive"
		"dive":
			var to_target := _target - position
			if to_target.length() <= 36.0:
				reached_burrow.emit(self)
				state = "return"
			else:
				position += to_target.normalized() * DIVE_SPEED * delta
		"return":
			var home := Vector2(HOME_X, HOVER_Y)
			var to_home := home - position
			if to_home.length() <= 20.0:
				position = home
				state = "strafe"
				_dive_timer = DIVE_DELAY
			else:
				position += to_home.normalized() * RETURN_SPEED * delta

	queue_redraw()


func take_hit() -> void:
	hp -= 1
	_flash = 0.12
	if hp <= 0:
		killed.emit(self)
		queue_free()


func _draw() -> void:
	var body_col := Color("a83226") if _flash <= 0.0 else Color("ffffff")
	var dark := Color("5c1a10") if _flash <= 0.0 else Color("aaaaaa")
	var cream := Color("f2ead8")

	draw_circle(Vector2(-46, 26), 20, body_col)
	draw_circle(Vector2(-58, 32), 12, cream)
	draw_circle(Vector2(0, 16), 34, body_col)
	draw_circle(Vector2(0, -18), 24, body_col)
	draw_colored_polygon(_tri(Vector2(-24, -34), Vector2(-9, -50), Vector2(-3, -28)), dark)
	draw_colored_polygon(_tri(Vector2(24, -34), Vector2(9, -50), Vector2(3, -28)), dark)
	draw_circle(Vector2(0, -6), 10, cream)
	draw_circle(Vector2(0, -11), 3, Color("1c120a"))
	draw_line(Vector2(-15, -28), Vector2(-4, -21), Color("1c120a"), 3.0)
	draw_line(Vector2(15, -28), Vector2(4, -21), Color("1c120a"), 3.0)
	draw_circle(Vector2(-9, -19), 3, Color("1c120a"))
	draw_circle(Vector2(9, -19), 3, Color("1c120a"))

	if state == "telegraph":
		draw_arc(Vector2.ZERO, 58.0, 0.0, TAU, 40, Color(1.0, 0.25, 0.2, 0.85), 5.0)

	var bar_w := 100.0
	var frac := clampf(float(hp) / float(MAX_HP), 0.0, 1.0)
	draw_rect(Rect2(-bar_w / 2.0, -84.0, bar_w, 12.0), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(-bar_w / 2.0, -84.0, bar_w * frac, 12.0), Color("e05a3a"))


func _tri(a: Vector2, b: Vector2, c: Vector2) -> PackedVector2Array:
	return PackedVector2Array([a, b, c])
