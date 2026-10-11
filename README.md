# Lode Wars source

DM source code for Lode Wars, by Leftley - https://www.byond.com/games/Leftley/LodeWars
recovered from `lodewars.dmb` (`world bin v334`) and its resource file. No original source was
available. Everything here was decompiled from those two files.

It compiles with 0 errors, 6 warnings.
three `if' statements with an empty body in `LoadCharacter`, and three locals that are set and never read.

## What is here

    lodewars_s.dme      the environment
    *.dm                the procs, back in the files the debug info names
    _types.dm           the type tree. every var, initial value and built-in
                        each type sets
    _globals.dm         global vars and the `world` settings
    lodewars_s.dmm      the map
    default.dms         the client script
    *.dmi, *.png, *.html  the resources

## Differences from the original

- **Hosting does not need the subscriber passport.** The original admits a
  local host only if `client.CheckPassport("14c8f0e811e1591e")` passes and
  otherwise deletes the world. This prevented most people with the hosting
  files from even playing. BYOND passports are retired, so that check cannot pass.
  `character.dm` drops it, and the first local player becomes host and admin as before.

- **`/obj/hud/score/var/color` is `color_`.** BYOND 516 has a built-in
  `color` on every atom, which v334 did not. The author's var is renamed
  wherever the code uses it.

- **Comments, blank lines and the original formatting are gone.** A
  compiled world does not keep them. Procs are in the files and in the
  order the debug info gives, but not at their original line numbers, so a
  runtime error names a different line than the original would.

- **Some member accesses are written with `:`** where the type of the
  variable could not be recovered. It compiles to the same code as `.`.

## Running it

The game reads `admin.txt`, `banned.txt` and `filter.txt` beside the `.dmb` and keeps
player saves in `saves/`
