# Notes for AI assistants writing PokeFields mods

Read `docs/format.md` and `docs/api.md` before writing anything. Both are generated from the game,
so they're complete: if a function, event or file isn't in them, it doesn't exist. Don't guess at
APIs from other games.

## Addons are Luau, not Lua 5.4

- Luau has `+=`, `..=`, `//`, `if x then a else b` expressions, type annotations, string
  interpolation with backticks, and `for k, v in t do` without `pairs`. There is no `goto`.
- The standard library is `string`, `table`, `math`, `bit32`, `utf8`, `buffer`, `coroutine`, and
  `os.time`, `os.clock`, `os.date`. That's it: no `io`, `debug`, `package` or `os.execute`.
- `require("lib/name")` loads `lib/name.lua` from the same mod. Nothing outside the mod can be loaded.
- Type names from `data` are capitalised: `"Fire"`, `"Water"`.

## How addons work

- The globals are `game`, `data`, `ui`, `timer` and `storage`, plus `print` and `require`.
- Use `game.on(event, handler)` to react and `game.state(topic)` to read what's true right now.
  Don't poll in a loop; use events, or `timer.every` if you really need a clock.
- An addon only reads and draws. It can't move the player, use items, battle, trade or chat, and
  there is no way around that, so don't try.
- Everything an addon runs in one frame shares a small time budget, and each addon has a memory cap
  (see Limits in `docs/api.md`). An addon that keeps erroring gets switched off.
- `storage.save(value)` keeps plain data (numbers, strings, booleans and tables of them), saved per
  character.

## Before handing a mod over

- `pfmod check <mod folder>` should print nothing but its summary line.
- `mod.json` needs `name`, `version` and `author`.
- Type-check against `.types/pokefields.d.luau` (the template already has it).
- `examples/` has working addons to follow.
