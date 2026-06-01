# Adventurer — adventure build system

Emacs Lisp module for building tabletop RPG adventures from Org-mode files into PDF documents, scene graphs, and [PathMapper](https://github.com/ivalentinee/path_mapper) packages.

## Dependencies

### Core (document build)

```bash
sudo apt-get install -y pandoc weasyprint graphviz zip emacs
```

- `pandoc` — Markdown to PDF conversion
- `weasyprint` — PDF engine for pandoc
- `graphviz` — scene graph (dot -> png)
- `zip` — PathMapper and pack archives
- `emacs` (27+) — org-mode

### GIMP 3 (map conversion xcf -> ora)

GIMP 3.x may require a PPA or Flatpak.

First try this:
```bash
sudo apt-get install -y gimp
```

If you get document build errors, try this:
```bash
sudo apt-get install -y \
  gimp \
  gir1.2-cairo-1.0 gir1.2-pango-1.0 \
  gir1.2-gdkpixbuf-2.0 gir1.2-gtk-3.0
```

- `gimp` (3.x) — XCF to ORA conversion
- `gir1.2-*` — GObject Introspection dependencies for Python-Fu (should be included with gimp, but might be missing)

## Emacs commands

- `M-x adventurer/build` — build PDF, scene graph, and PathMapper package
- `M-x adventurer/pack` — pack source files (.org + assets) into a zip archive
- `M-x adventurer/clear` — remove generated files
- `M-x adventurer/initialize` — create a new adventure document from template

## Org file structure

```
#+TITLE: Title
#+URLS: [[link][Name]]
#+WALLPAPER: assets/wallpaper.png

* Short description (:ID: description)
* Prepare (:ID: prepare)
  ** NPCs / Enemies / Conditions
* Scenes (:ID: scenes)
  ** [NN] Scene title
     :PROPERTIES: (ID, EXP, LINK, MUSIC, MAP, TOKENS, PLACE-TOKENS)
* Stat blocks (:ID: statblocks)  — optional
```

### Scene properties

- `:ID:` — unique identifier
- `:EXP:` — experience (number or range)
- `:LINK:` — transitions to other scenes
- `:MUSIC:` — track number
- `:MAP:` — path to map file (.xcf or .ora)
- `:TOKENS:` — token definitions
- `:PLACE-TOKENS:` — token placement on map

### EXTRA content (appendix)

Two ways to mark content as EXTRA (moved to PDF appendix):

Drawer (for short blocks without subheadings):
```org
:EXTRA:
Extended description...
:END:
```

Subheading (for blocks with subheadings, foldable in Emacs):
```org
*** [EXTRA] Section title
Extended description...
```

In the PDF, `[EXTRA]` is stripped — headings render without the tag.

## Helper scripts

- `xcf-to-ora.sh <input.xcf> <output.ora>` — convert maps via GIMP 3

## Adventure file structure

```
Adventures/
  NN Adventure Name/
    NN Adventure Name.org   — source document
    assets/
      wallpaper.png
      tokens/               — PNG tokens
      maps/                 — XCF/ORA maps
    build/                  — generated files
      NN Adventure Name.pdf
      NN Adventure Name.png — scene graph
      NN Adventure Name.zip — PathMapper package
      NN Adventure Name.src.zip — source archive
```

## Group management

The `adventurer/group` module manages player groups. Each group is an Org-mode file that builds into a TOML manifest and [PathMapper](https://github.com/ivalentinee/path_mapper) package with player tokens. Optional [Charkeeper](https://charkeeper.ru/) integration for character sheets.

### Group Emacs commands

- `M-x adventurer/group/build` — build group TOML manifest and PathMapper package (tokens zip)
- `M-x adventurer/group/pack` — pack group source files (.org + tokens + source files) into a zip archive
- `M-x adventurer/group/clear` — remove generated files

### Group Org file structure

```org
#+TITLE: Group Name
#+CHARKEEPER_ID: uuid          # optional, campaign ID

* Characters
:PROPERTIES:
:ID: characters
:END:

** Character Name
:PROPERTIES:
:CLASS: Class
:PLAYER: Player Name
:COLOR: #hex
:TOKEN: [[assets/char/char.png][Token]]
:EXTRA: [[assets/char/char-1.png][Token 1]] [[assets/char/char-2.png][Token 2]]
:SOURCE_FILES: [[assets/char/char.xcf][Source]]
:CHARKEEPER_ID: uuid           # optional, per-character
:END:
```

Characters marked as `TODO` are excluded from the build.

### Generated TOML manifest

```toml
title = "Group Name"
charkeeper_id = "uuid"

[[players]]
character_name = "Character"
class = "Class"
player_name = "Player"
color = "#hex"
token = "assets/char/char.png"
charkeeper_id = "uuid"
extra_tokens = [
    { image = "assets/char/char-1.png", name = "Token 1" },
    { image = "assets/char/char-2.png", name = "Token 2" }
]
```

### Group file structure

```
Groups/
  Group Name/
    group-name.org          — source document
    assets/
      character-name/
        character.png       — main token
        character-1.png     — extra token variants
        character.xcf       — source file (for pack)
    build/
      group-name.toml       — generated manifest
      group-name.zip        — PathMapper package
      group-name.src.zip    — source archive
```
