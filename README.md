# Burrow Defender

A small shoot 'em up made with Godot 4 and GDScript. You are a rabbit defending
your burrow from hungry foxes.

![godot](https://img.shields.io/badge/Godot-4.2%2B-478cbf)

## Gameplay

Foxes spawn at the top of the screen and shuffle toward your burrow at the
bottom. Shoot them with carrots before they chew through it. The burrow has
10 HP, and the waves speed up as your score grows.

## Controls

| Input | Action |
| --- | --- |
| Arrow keys / WASD | Move |
| Space | Shoot carrot |
| R | Restart (on game over) |

## Running

1. Open this folder in Godot 4.2 or newer.
2. Press `F5` (Run Project).

No image or audio assets are required: all graphics are drawn procedurally
with \`_draw()\`.

## Project layout

```text
burrow-defender/
├── project.godot
├── scenes/
│   └── main.tscn
└── scripts/
    ├── main.gd
    ├── burrow.gd
    ├── player.gd
    ├── fox.gd
    └── carrot.gd
```

## Ideas for the future

- Sound effects and music
- A second fox type that moves in bursts or throws acorns
- HP pickups dropped by foxes
- High score persistence between runs
