extends Node2D
## Burrow Defender entry point: builds the world, HUD, spawning and game state.

const SCREEN := Vector2(720, 960)
const BURROW_POS := Vector2(360, 905)

const FoxScript := preload("res://scripts/fox.gd")
const CarrotScript := preload("res://scripts/carrot.gd")

var burrow: Burrow
var player: PlayerRabbit
var hud: CanvasLayer
var score_label: Label
var hp_label: Label
var game_over_panel: Control

var score := 0
var spawn_interval := 2.2
var spawn_timer := 1.5
var game_over := false
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	RenderingServer.set_default_clear_color(Color("28402a"))

	burrow = Burrow.new()
	burrow.position = BURROW_POS
	burrow.damaged.connect(_on_burrow_damaged)
	add_child(burrow)

	player = PlayerRabbit.new()
	player.position = Vector2(SCREEN.x * 0.5, SCREEN.y - 190)
	player.shot.connect(_on_player_shot)
	add_child(player)

	_build_hud()


func _draw() -> void:
	# Meadow ground strip along the bottom.
	draw_rect(Rect2(0, 880, SCREEN.x, 80), Color("3f6d33"))
	# A few grass tufts for decoration.
	for i in range(14):
		var x := 24.0 + i * 52.0
		draw_line(Vector2(x, 930), Vector2(x - 7, 902), Color("527d40"), 3.0)
		draw_line(Vector2(x + 6, 930), Vector2(x + 11, 904), Color("527d40"), 3.0)


func _physics_process(delta: float) -> void:
	if game_over:
		if Input.is_physical_key_pressed(KEY_R):
			get_tree().reload_current_scene()
		return

	spawn_timer -= delta
	if spawn_timer <= 0.0:
		spawn_timer = spawn_interval
		_spawn_fox()


func _spawn_fox() -> void:
	var fox: Fox = FoxScript.new()
	fox.setup(Vector2(BURROW_POS.x, BURROW_POS.y - 50))
	fox.position = Vector2(rng.randf_range(50, SCREEN.x - 50), -40)
	fox.reached_burrow.connect(_on_fox_reached_burrow)
	fox.killed.connect(_on_fox_killed)
	add_child(fox)

	# Difficulty ramps up as the score grows.
	if score >= 4 and spawn_interval > 1.4:
		spawn_interval -= 0.1
	if score >= 10 and spawn_interval > 0.7:
		spawn_interval -= 0.1


func _on_player_shot(pos: Vector2) -> void:
	var carrot: Carrot = CarrotScript.new()
	carrot.position = pos
	add_child(carrot)


func _on_fox_reached_burrow(_fox) -> void:
	burrow.take_damage(1)


func _on_fox_killed(_fox) -> void:
	score += 1
	_update_hud()


func _on_burrow_damaged() -> void:
	_update_hud()
	if burrow.hp <= 0:
		_set_game_over()


func _set_game_over() -> void:
	game_over = true
	game_over_panel.visible = true


func _build_hud() -> void:
	hud = CanvasLayer.new()
	add_child(hud)

	score_label = Label.new()
	score_label.position = Vector2(16, 12)
	score_label.add_theme_font_size_override("font_size", 30)
	hud.add_child(score_label)

	hp_label = Label.new()
	hp_label.position = Vector2(16, 54)
	hp_label.add_theme_font_size_override("font_size", 26)
	hud.add_child(hp_label)

	game_over_panel = Control.new()
	game_over_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_over_panel.visible = false
	hud.add_child(game_over_panel)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_over_panel.add_child(dim)

	var msg := Label.new()
	msg.text = "The foxes got in!\n\nScore: %d\n\nPress R to try again"
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msg.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	msg.add_theme_font_size_override("font_size", 44)
	msg.add_theme_color_override("font_color", Color.WHITE)
	msg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_over_panel.add_child(msg)

	_update_hud()


func _update_hud() -> void:
	score_label.text = "Score: %d" % score
	hp_label.text = "Burrow: %s" % "\u2665".repeat(burrow.hp)
