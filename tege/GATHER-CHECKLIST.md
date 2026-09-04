# TEGE Site — What to Gather

Everything you need to capture, export, or source for the site upgrade.
Drop screenshots/GIFs into `images/`, demos into their `demo-*/` folder.
Naming is kebab-case to match the existing `enjin-*` convention.

---

## A. Screenshots

### The 8 art styles — same scene, locked camera
Pick one scene with a character + environment. Do not move the camera between shots.

- [ ] `style-pbr.png` — Realistic PBR
- [ ] `style-blinn.png` — Blinn-Phong
- [ ] `style-handpainted.png` — Hand-Painted
- [ ] `style-cel.png` — Cel / Toon (ink outline)
- [ ] `style-ps1.png` — PS1 Low-Poly (jitter + affine)
- [ ] `style-pixel.png` — Pixel Art
- [ ] `style-sketch.png` — NPR Sketch
- [ ] `style-crt.png` — Analog CRT

### Per-object styles
- [ ] `shot-mixed-styles.png` — one frame, several objects each in a different style at once

### Editor + UI (replace the currently reused shots)
- [ ] `shot-editor-hero.png` — wide editor, strong scene (for the hero)
- [ ] `shot-visual-scripting.png` — node / wiring graph in use
- [ ] `shot-angelscript.png` — AngelScript editor with hot-reload
- [ ] `shot-accessibility-menu.png` — in-game a11y menu (colorblind / remap / reader)

### World / simulation showpieces (one striking shot each)
- [ ] `shot-weather-zones.png` — weather / seasons
- [ ] `shot-water-fluid.png` — fluid sim / water
- [ ] `shot-particles-gpu.png` — GPU particles with collision
- [ ] `shot-destructible.png` — Voronoi fracture / destruction
- [ ] `shot-procgen.png` — dungeon / wave-function-collapse output

---

## B. GIFs / short clips (motion a photo can't show)
Few seconds, looped. WebM preferred, GIF fallback.

- [ ] Art-style / preset switching (the dropdown flip)
- [ ] Time rewind mechanic
- [ ] Tearable cloth / fabric in wind
- [ ] Fluid / water carving terrain
- [ ] GPU particles with collision
- [ ] Weather + seasons changing a scene
- [ ] Vegetation wind
- [ ] Gaussian splat orbit
- [ ] Cel / toon outline reacting to camera movement

---

## C. Web demos (engine `.enjpak` exports)

- [ ] Accessibility demo — already live in `demo/`
- [ ] Art-styles demo — live in-browser preset switching  →  `demo-styles/`
- [ ] Stress / performance demo — heavy load + on-screen FPS / entity / draw-call counters  →  `demo-stress/`
- [ ] Per-object styles demo — one scene, every object a different style  →  `demo-mixed-styles/`

---

## D. CC0 assets (WEB DEMOS ONLY — not the engine tutorial packs)
Log every source in an `ASSET-CREDITS.md`.

- [ ] Gaussian splat capture (PolyCam / Luma self-capture is cleanest license)
- [ ] Toon / cel-shaded lighting scene (model set lit in the toon preset)
- [ ] General fill assets — Poly Haven, Kenney.nl, Quaternius, ambientCG (all CC0)

---

## Notes
- Unused images already sitting in `images/` you can slot in or replace:
  `enjin-daynight-sunset.png`, `enjin-lighting-night.png`,
  `enjin-scene-shiba-wide.png`, `enjin-weather-snow.png`.
- Full rationale and site-side build order is in `UPGRADE-PLAN.md`.
