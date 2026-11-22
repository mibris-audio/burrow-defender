# Burrow Defender

A small shoot 'em up made with Godot 4 and GDScript. You are a rabbit defending
your burrow from hungry foxes.

![godot](https://img.shields.io/badge/Godot-4.2%2B-478cbf)

## Gameplay

Foxes spawn at the top of the screen and shuffle toward your burrow at the
bottom. Shoot them with carrots before they chew through it. The burrow has
10 HP, and the waves speed up as your score grows.

### Bossfight at score 50

When your score reaches **50**, normal foxes stop spawning and the **Alpha
Fox** boss enters: a big fox with 40 HP that strafes across the sky and
periodically dives at your burrow for 2 damage. Beat it (worth 10 points) and
you choose what happens next:

- **Infinite mode** — endless play where the difficulty rises exponentially:
  the spawn interval decays exponentially, fox speed grows exponentially, and
  their HP steps up every 30 seconds.
- **Next level** — shows a victory screen with the round details (score, time
  survived, shots fired, boss defeated, burrow HP) and a **Repeat level**
  button. The actual next level is not implemented yet.

### Falling pickups

Keep an eye on the sky and catch things with the rabbit:

- **Hearts** (pink) drift down now and then while the burrow is damaged and
  repair it by 2 HP.
- **Upgrade crates** (orange, white arrow) drop when you reach a score
  milestone. Catch one to improve your weapon:

| Milestone | Crate contents |
| --- | --- |
| Score 5 | Faster firing |
| Score 12 | Double carrots (spread shot) |
| Score 22 | Triple carrots |
| Score 35 | Rapid fire |
| Score 50 | Machine carrot (also triggers the bossfight) |

Miss a crate and it is gone, so collect them before they hit the ground.

## Controls

| Input | Action |
| --- | --- |
| Arrow keys / WASD | Move |
| Space | Shoot carrot |
| Mouse | Choose on the boss reward / victory screens |
| R | Restart (on game over or victory screen) |

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
    ├── boss.gd
    ├── carrot.gd
    └── pickup.gd
```

## Ideas for the future

- Sound effects and music
- A second fox type that moves in bursts or throws acorns
- The real next level after the victory screen
- High score persistence between runs
