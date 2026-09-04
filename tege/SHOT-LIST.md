# TEGE Site — Custom Screenshot Shot List

Capture list for upgrading the enjin/ landing page. Shoot at a consistent
resolution (2560×1440 or 1920×1080), same aspect ratio per group.

## Priority 1 — "One Scene, Every Style" (the core pitch)

Pick ONE scene with clear geometry, a character, and some environment.
Lock the camera. Do not move it between shots. Capture the same frame in
each of the 8 art-style presets so the style-switcher swaps look feel like
flipping the dropdown in the real editor.

| # | Preset | Save as |
|---|--------|---------|
| 1 | Realistic PBR | `style-pbr.png` |
| 2 | Blinn-Phong | `style-blinn.png` |
| 3 | Hand-Painted | `style-handpainted.png` |
| 4 | Cel / Toon (ink outline) | `style-cel.png` |
| 5 | PS1 Low-Poly (jitter + affine) | `style-ps1.png` |
| 6 | Pixel Art | `style-pixel.png` |
| 7 | NPR Sketch | `style-sketch.png` |
| 8 | Analog CRT | `style-crt.png` |

## Priority 2 — Fresh editor + UI captures

Replace reused/duplicated shots so each tab shows something different.

- `shot-editor-hero.png` — wide editor with a good-looking scene, for the hero (replaces reuse of enjin-editor-workspace across 3 spots)
- `shot-visual-scripting.png` — the node/wiring graph in use (site claims visual scripting but shows no node graph)
- `shot-angelscript.png` — AngelScript editor with hot-reload visible
- `shot-accessibility-menu.png` — the in-game accessibility menu (colorblind, remap, screenreader) — currently zero real shots of the #2 pillar

## Priority 3 — World / simulation showpieces

One striking capture each, to back up the "Everything in the Box" claims.

- `shot-weather-zones.png` — weather/seasons
- `shot-water-fluid.png` — fluid sim / water
- `shot-particles-gpu.png` — GPU particles with collision
- `shot-destructible.png` — Voronoi fracture / destruction
- `shot-procgen.png` — dungeon / wave-function-collapse output

## Notes

- Keep filenames kebab-case to match existing `enjin-*` convention.
- PNG for UI/flat-shaded, JPG/WebP acceptable for photoreal scenes to save weight.
- After capture, drop into `images/` and I'll wire them into the page.
