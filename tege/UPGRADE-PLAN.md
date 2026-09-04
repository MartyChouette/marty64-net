# TEGE Site Upgrade Plan

Everything we're adding to the enjin/ landing page, and the assets you need
to capture or produce for each. Site-side scaffolding I can build now; the
demos and screenshots are engine exports you produce.

---

## 1. Screenshot shot list

### P1 — "One Scene, Every Style" (the core pitch)
Same scene, locked camera, captured in all 8 art-style presets. Feeds a live
style-switcher on the page (see section 3).

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

### P1b — Per-object styles (one frame sells the mixed-style pitch)
- `shot-mixed-styles.png` — one scene, several objects each in a different
  style at once (PBR + cel + PS1 + pixel), same camera. Static stand-in for
  the per-object styles demo.

### P2 — Fresh editor + UI captures (replace reused shots)
- `shot-editor-hero.png` — wide editor with a strong scene (hero)
- `shot-visual-scripting.png` — node/wiring graph (claimed, never shown)
- `shot-angelscript.png` — AngelScript editor, hot-reload visible
- `shot-accessibility-menu.png` — in-game a11y menu (colorblind/remap/reader)

### P3 — World/simulation showpieces
weather zones, fluid/water, GPU particles, Voronoi destruction, procgen output.

### Unused images already in images/ (slot in or replace)
`enjin-daynight-sunset.png`, `enjin-lighting-night.png`,
`enjin-scene-shiba-wide.png`, `enjin-weather-snow.png`.

---

## 2. Web demos — go from one to a gallery

Current: `demo/` = single WebGPU scene (EnjinPlayer.wasm + game.enjpak).
Turn the Showcase tab into a demo gallery with a card per demo.

| Demo | Purpose | Folder |
|------|---------|--------|
| **Accessibility demo** (current) | Show a11y features live | `demo/` |
| **Art-styles demo** | Live in-browser preset switching, the dropdown pitch running for real | `demo-styles/` |
| **Stress / performance demo** | Heavy animation + actions + processing load to prove WebGPU throughput; on-screen FPS/draw-call/entity counters | `demo-stress/` |
| **Per-object styles demo** | One scene, every object a different style at once (PBR + cel + PS1 + pixel side by side). Proves style is per-object material, not a global toggle | `demo-mixed-styles/` |

Each is its own `.enjpak` export dropped into its folder, reusing the same
EnjinPlayer runtime. The stress demo should surface a live stats overlay
(FPS, frame ms, entity/particle count) so the performance claim is visible.

---

## 3. New site sections/features

- **Live style-switcher** — one image, 8 buttons, swaps the render in place.
  Demonstrates "one dropdown, every look" instead of just claiming it.
  Built from the P1 screenshots; upgrades later to the art-styles demo.
- **Demo gallery** — restructure Showcase tab (section 2).
- **Capability showcases** — blocks for things we can only show with real
  captures/demos: Gaussian splat import, toon/stylized lighting (section 4).

---

## 4. CC0 assets to source (WEB DEMOS ONLY)

Scope: CC0 assets are for the site's web demos and capability showcases ONLY.
The assets that ship packaged with the engine tutorials will be our own
original content, kept separate from this.

Demonstrate things a static shot can't sell. Use CC0 so the site demos ship freely.

- **Gaussian splat example** — a photoreal capture imported as a scene object.
  Sources: PolyCam / Luma captures you shoot yourself (cleanest license), or
  public splat datasets. Verify CC0 before shipping.
- **Toon / cel-shaded lighting scene** — a model set lit in the toon/cel preset.
- **General CC0 model/texture/HDRI sources:** Poly Haven (CC0), Kenney.nl (CC0),
  Quaternius (CC0), ambientCG (CC0 textures). Good for populating the demos.

Keep an ASSET-CREDITS.md so even CC0 sources are logged.

---

## 5. GIFs / short clips (motion that a photo can't show)

Some features only read in motion. Capture short looping GIF or muted WebM/MP4
clips (WebM is lighter, GIF is the fallback). Keep them a few seconds, looped.

Candidates:
- Live art-style / preset switching (the dropdown flip)
- Time rewind mechanic
- Tearable cloth / fabric catching wind
- Fluid sim / water carving terrain
- GPU particles with collision
- Weather + seasons changing a scene
- Vegetation wind
- Gaussian splat orbit
- Cel/toon outline reacting to camera movement

---

## Build order (site-side, what I can do now)
1. Restructure Showcase tab into the demo gallery (placeholder cards for the
   two new demos, "coming soon" until you export them).
2. Build the live style-switcher (works with current 3 shots, expands to 8).
3. Add capability-showcase blocks (splat, toon lighting) with placeholders.
