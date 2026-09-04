# Snoop

A 1-bit detective game for the Playdate handheld. Search rooms. Find evidence. Don't get caught.

## The Game

Snoop is a single-file C++ game (~4300 lines) with no imported assets. Everything on screen is drawn procedurally using the Playdate graphics API. The game runs at 30 FPS on a 400x240 1-bit display.

The player breaks into 50 buildings across 8 city districts, searching desks and drawers for evidence of corruption. Each building is a room with four walls: a desk to search, a window to watch for approaching visitors, a door to lock, and a closet to hide in. Visitors walk up to the building on a timer, and each of the four types demands a different defensive response.

25 key clues found across the game connect in pairs on a corkboard evidence board. 15 connections unlock revelation text that gradually exposes a city-wide conspiracy controlled by a figure called The Architect. The story unfolds across four acts, from isolated corruption cases to the final confrontation at the Penthouse Suite.

### Technical

- **Platform**: Playdate (400x240, 1-bit, crank input)
- **Language**: C++ (C++17, single source file)
- **Graphics**: All procedural. No sprites, no images, no external assets.
- **Audio**: Two synth channels (square wave + noise), 9 sound effects generated at runtime.
- **Memory**: No dynamic allocation. All data in static const arrays. Estimated ~20KB game data against 16MB heap.
- **Build**: CMake + MinGW (MSYS2 ucrt64 on Windows), outputs Snoop.pdx

### Content

- 50 buildings across 8 themed districts
- 25 key clues with descriptions
- 15 inter-clue connections with revelation text
- 12 searchable in-game computers with folder/file browsers
- 4 visitor AI types with distinct behaviors and mid-approach turnaround system
- 4-act narrative structure with per-building story notes
- Isometric district overview with mountain/city backdrop
- Per-district world map with ambient pedestrians, vehicles, decorations
- Corkboard evidence board with card placement and connection visualization
- Single save file with auto-save

## Snoop Weaver

`story_planner.html` is a browser-based content authoring tool built specifically for this game. It manages all 50 buildings, 25 clues, 15 connections, 12 computers, NPCs, story arcs, and visual threads in one interface.

### Features

- **10 tabs**: Overview, Districts, Buildings, NPCs, Clues & Web, Story Arc, Mind Map, Playtest, Art, Export
- **Building editor**: Edit every field of every building. Briefings, story notes, desk items, drawer contents (item names, evidence flags, counts), visitor difficulty parameters, computer assignments.
- **Clue & connection editor**: Edit all 25 key clues and 15 connections. Visual connection web (SVG). Clue lifecycle tracer showing the full path from hidden location to evidence board to revelation.
- **Playdate memory budget**: Live estimation of game data size against the 16MB Playdate heap. Breaks down strings, struct sizes, compiled code, SDK overhead. Updates as you edit.
- **C++ export**: Generates drop-in C++ arrays (DISTRICTS, LEVELS, KEY_CLUES, CONNECTIONS, COMPUTERS) matching the exact struct format in main.cpp. Download as header file or copy individual arrays.
- **CSV import/export**: Buildings, clues, connections, drawers, NPCs. Edit in Excel or Google Sheets and import back.
- **Mind map**: Draggable node graph of all buildings and clues with connection lines. Color-coded by district and thread. Zoom/pan.
- **Story arc planner**: Per-act summaries, district conspiracy arcs with setup/escalation/climax. Pacing tags per building (setup, tension, reveal, calm, climax).
- **Narrative threads**: Named color-coded threads (The Architect, Arch Holdings, Offshore Network, etc.) assignable to buildings. Keyword highlighting across all text fields.
- **NPC system**: Character profiles with dialogue (enter/evidence/caught lines), personality notes, building assignments.
- **Playtest walkthrough**: Step through the game building by building. Track which clues are found, which connections revealed. See the story unfold in sequence.
- **Collaboration**: WebSocket-based real-time sync with cursor avatars, presence indicators, and change feed. Optional setup via story_sync.php backend.
- **Undo/redo**: Full history with named operations.
- **Auto-save**: localStorage persistence with JSON export/import.

### Architecture

Single self-contained HTML file. No build step, no dependencies, no framework. Vanilla JS with inline CSS. Opens in any browser. Data stored in localStorage, exportable as JSON.

## Game Design Document

A full HTML reference document (`SnoopGDD.html`) covering every mechanic, all 50 buildings, all 25 clues, all 15 connections, the visitor AI system, difficulty scaling, sound design, save system, and technical notes. Dark noir theme with IBM Plex fonts.

## Files

```
snoop/
  story_planner.html    Snoop Weaver (content authoring tool)
  story_sync.php        Optional WebSocket sync backend
  README.md             This file
```

Game source at `snoop_Playdate/src/main.cpp`. GDD at `snoop_Playdate/Docs/SnoopGDD.html`.
