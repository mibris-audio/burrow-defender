class_name Burrow
extends Node2D
## The rabbit's home. Foxes gnaw on it when they reach it, hearts repair it.

signal damaged

var max_hp := 10
var hp := max_hp


func take_damage(amount := 1) -> void:
	if hp <= 0:
		return
	hp = maxi(hp - amount, 0)
	damaged.emit()
	queue_redraw()


func heal(amount := 2) -> void:
	hp = mini(hp + amount, max_hp)
	queue_redraw()


func _draw() -> void:
	# Dirt mound with a dark entrance, plus a rim of lighter earth.
	draw_colored_polygon(_ellipse(140, 55, Vector2(0, 20)), Color("57402a"))
	draw_colored_polygon(_ellipse(115, 42, Vector2(0, 20)), Color("7a5230"))
	draw_colored_polygon(_ellipse(55, 34, Vector2(0, 26)), Color("8a6038"))
	draw_colored_polygon(_ellipse(38, 26, Vector2(0, 28)), Color("1c120a"))


func _ellipse(rx: float, ry: float, center: Vector2) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in range(40):
		var t := TAU * i / 40.0
		pts.append(center + Vector2(rx * cos(t), ry * sin(t)))
	return pts
