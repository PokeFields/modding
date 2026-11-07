# PokeFields Modding

Everything you need to make mods for [PokeFields](https://pokefields.com): the file format, the
addon API, a starter template, a few example mods, and `pfmod`, which checks a mod the same way the
game does.

Mods only change your own game. You can swap sprites and icons, restyle the interface, put your own
background on the login screen, and write small addons that show you things while you play. Nothing a
mod does is seen by other players, with one exception: a follower sprite, which everyone who has the
same mod installed will see.

## What a mod can change

- **Monster art and cries**: battle sprites (animated, front and back, shiny and forms), box icons,
  followers and cries. A follower for a species that has none in the game makes it walk behind you.
- **Item icons.**
- **The interface**: its art, its fonts, and a theme for colours, sizes, panels and buttons.
- **The login screen background**: an image or a looping video.
- **Addons**: [Luau](https://luau.org) scripts that read what your game knows (your party, your
  bag, battles, chat, where you are) and draw their own little windows.

And what it can't: clothing, the world itself (maps, tiles, characters), sound effects and music, or
the layout of the game's screens. Addons can't send anything to the server, so no auto-battling,
auto-walking or chat bots. That's on purpose, and it's why addons are allowed at all.

## Installing a mod

1. On the login screen, press **Mods** to open Mod Management.
2. Press **Import Mod** and pick the mod's `.zip`. You can also drop the `.zip` onto the window, or
   put it (or an unzipped mod folder) straight into the folder **Open Mods Folder** opens.
3. Select the mod, tick **Enabled** and press **Save**. The game restarts with it.

If two mods change the same thing, the one lower in the list wins. Use ▲ and ▼ to reorder them.

## Making your first mod

1. Copy [`template/`](template) into your mods folder and rename the folder. The folder name is your
   mod's id, so pick something short like `my-sprites`.
2. Edit `mod.json` and put your name on it.
3. In Mod Management, press **Dump Resources**, pick what you want and press **Dump**. The game
   writes those files out as a mod would name them, so you can copy what you need into your mod and
   edit it. One of the options writes out every species and item id with its name.
4. Tick **Verbose Mod Debugs** while you work. Skipped files, theme types the game does not have,
   conflicts between mods and addon errors all go to the game's log, `logs/godot.log`, in the folder just above your mods folder.

Art, sounds and themes load when the game starts, so restart to see changes to them. Addon scripts
reload each time you enter the world: go back to character select and pick your character again.

If you keep your mod somewhere else (in a git checkout, say), link its folder into the mods folder
and the game will follow the link.

## What's in here

| Path | What it is |
|---|---|
| [`template/`](template) | A blank mod to start from: `mod.json`, a tiny addon and the editor setup |
| [`examples/`](examples) | Finished mods to read, try and copy from |
| [`docs/format.md`](docs/format.md) | Every file a mod can contain, with sizes and limits |
| [`docs/api.md`](docs/api.md) | The addon API: events, state, functions, windows |
| [`AGENTS.md`](AGENTS.md) | Instructions for AI coding assistants, if you use one |

`docs/` and the template's types file are generated from the game itself with every update, so they
always match the version you're playing.

## Examples

| Mod | What it shows |
|---|---|
| [`party-hp`](examples/party-hp) | A window with your party's HP. Reading state and rebuilding a window when it changes |
| [`encounter-counter`](examples/encounter-counter) | Counts your wild encounters and shinies per character. Saving data between sessions |
| [`matchups`](examples/matchups) | Shows how well your monster's moves hit the foe in a battle. Game data and battle events |
| [`field-notes`](examples/field-notes) | Dex progress, time and weather in tabs. Selected buttons, pressable icons, remembering a closed window |
| [`plum-theme`](examples/plum-theme) | Recolours windows and buttons. A theme with no art at all |

To try one, copy its folder into your mods folder and enable it.

## Editor setup

Install the **Luau Language Server** extension for VS Code and open your mod's folder. The template's
`.vscode/settings.json` points it at `.types/pokefields.d.luau`, which gives you autocomplete and
type errors for the whole API, including every event's payload. The game never loads folders whose
names start with a dot, so these can stay in your mod.

## pfmod

`pfmod` runs the exact checks the game runs and tells you about anything it would skip. Grab it from
[Releases](../../releases) (Windows and Linux), then:

```
pfmod check path/to/my-mod
pfmod check my-mod.zip
```

If all it prints is one summary line per mod, everything loads. `pfmod sdk <folder>` writes out the
docs, template and examples that match your copy of `pfmod`.

## Sharing a mod

Zip the folder (files at the root of the zip, or inside a single folder) and post it on the
[Mods board](https://pokefields.com/forums/mods). Only share art you made yourself or have permission
to share.

## License

The template, the examples and the docs are [MIT](LICENSE). Use them however you like. Your mods are
yours.
