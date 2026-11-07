# Field Notes

A window with two tabs: your dex progress (seen, caught, shiny, and the last monster you caught),
and the world's time and weather.

- **Tabs** are buttons; `set_selected` draws the current one as selected, and the window is rebuilt
  when you switch.
- **The dex** arrives just after `ready`, so the window waits for `dex_loaded` before counting it.
- **The last catch's icon** is pressable with `on_press`.
- **Closing the window** is remembered with `on_close`, so it stays closed next session too. You
  open it again from the game's menu, under **Addons**, which runs `on_open`.
