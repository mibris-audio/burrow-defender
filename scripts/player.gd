class_name PlayerRabbit
extends Node2D
## The rabbit. Moves around the lower part of the meadow and fires carrots.
## Weapon upgrades improve fire rate and the number of carrots per shot.

signal shot(pos: Vector2, dir: Vector2)

const CARROT_SPEED := 650.0
const SHOT_COOLDOWN_START := 0.28
const SPREAD_DEGREES := 14.0
const MIN_X := 40.0
const MAX_X := 680.0
const MIN_Y := 520.0
const MAX_Y := 820.0

var shoot_cooldown := SHOT_COOLDOWN_START
var carrot_count := 1
var shoot_cd := 0.0


func upgrade_fire_rate() -> void:
	shoot_cooldown = maxf(shoot_cooldown * 0.6, 0.08)


func upgrade_multishot() -> void:
	carrot_count = mini(carrot_count + 1, 5)


func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_LEFT) or Input.is_physical_key_pressed(KEY_A):
		dir.x -= 1
	if Input.is_physical_key_pressed(KEY_RIGHT) or Input.is_physical_key_pressed(KEY_D):
		dir.x += 1
	if Input.is_physical_key_pressed(KEY_UP) or Input.is_physical_key_pressed(KEY_W):
		dir.y -= 1
	if Input.is_physical_key_pressed(KEY_DOWN) or Input.is_physical_key_pressed(KEY_S):
		dir.y += 1

	position += dir.normalized() * SPEED * delta
	position.x = clampf(position.x, MIN_X, MAX_X)
	position.y = clampf(position.y, MIN_Y, MAX_Y)

	shoot_cd -= delta
	if Input.is_physical_key_pressed(KEY_SPACE) and shoot_cd <= 0.0:
		shoot_cd = shoot_cooldown
		_fire(carrot_count)


func _fire(count: int) -> void:
	for i in range(count):
		var offset := deg_to_rad((float(i) - (count - 1) / 2.0) * SPREAD_DEGREES)
		shot.emit(position + Vector2(0, -30), Vector2.UP.rotated(offset) * CARROT_SPEED)


func _draw() -> void:
	var fur := Color("d8cdbb")
	# Body and head.
	draw_circle(Vector2(0, 4), 22, fur)
	draw_circle(Vector2(0, -20), 15, fur)
	# Ears (outer + inner).
	draw_circle(Vector2(-8, -42), 6, fur)
	draw_circle(Vector2(8, -42), 6, fur)
	draw_circle(Vector2(-8, -42), 3, Color("e8a8b8"))
	draw_circle(Vector2(8, -42), 3, Color("e8a8b8"))
	# Face.
	draw_circle(Vector2(-6, -22), 2.5, Color("1c120a"))
	draw_circle(Vector2(6, -22), 2.5, Color("1c120a"))
	draw_circle(Vector2(0, -16), 2.5, Color("e8a8b8"))
	# Fluffy tail.
	draw_circle(Vector2(0, 20), 8, Color("f2ead8"))
