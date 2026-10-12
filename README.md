# Lode Wars source

DM source code for Lode Wars, by Leftley - https://www.byond.com/games/Leftley/LodeWars
recovered from `lodewars.dmb` (`world bin v334`) and its resource file. No original source was
available. The first commit is the original decompile. Changes since then are in the commit
history.

## Differences from the original

- **Hosting does not need the subscriber passport.** The original admits a
  local host only if `client.CheckPassport("14c8f0e811e1591e")` passes and
  otherwise deletes the world. This prevented most people with the hosting
  files from even playing.
  `character.dm` drops it, and the first local player becomes host and admin as before.

- **`/obj/hud/score/var/color` is `color_`.** BYOND 516 has a built-in
  `color` on every atom, which v334 did not. The author's var is renamed
  wherever the code uses it.

- **Some member accesses are written with `:`** where the type of the
  variable could not be recovered. It compiles to the same code as `.`.

## Running it

The game reads `admin.txt`, `banned.txt` and `filter.txt` beside the `.dmb` and keeps
player saves in `saves/`
