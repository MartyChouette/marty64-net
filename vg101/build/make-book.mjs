import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { dirname, resolve, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const KB = resolve(__dirname, '..');            // .../marty64-net/vg101
const IMAGES_URL = pathToFileURL(join(KB, 'images')).href; // file:///.../vg101/images

// ---- Textbook structure (site nav order) --------------------------------
const parts = [
  {
    name: 'Part I',
    title: 'The Framework',
    blurb: 'The core lens of VG101: Gesture, the 4 A’s, Aesthetic Heritage, and Permissions.',
    pages: [
      'framework/index.html',
      'framework/gesture.html',
      'framework/the-four-as.html',
      'framework/aesthetic-heritage.html',
      'framework/permissions.html',
    ],
  },
  {
    name: 'Part II',
    title: 'Foundations',
    blurb: 'What a videogame is, the weekly rhythm of the course, player psychology, and the design lens.',
    pages: [
      'foundations/index.html',
      'foundations/what-makes-a-videogame.html',
      'foundations/the-weekly-rhythm.html',
      'foundations/player-psychology.html',
      'foundations/the-design-lens.html',
    ],
  },
  {
    name: 'Part III',
    title: 'Narrative Design',
    blurb: 'Telling stories in a medium that is played, not read or watched.',
    pages: [
      'narrative/index.html',
      'narrative/environmental-storytelling.html',
      'narrative/branching-consequence.html',
      'narrative/dialogue-systems.html',
      'narrative/ludonarrative-harmony.html',
    ],
  },
  {
    name: 'Part IV',
    title: 'Level Design',
    blurb: 'Shaping space so players understand where to go and how to feel getting there.',
    pages: [
      'level-design/index.html',
      'level-design/spatial-communication.html',
      'level-design/pacing-flow.html',
      'level-design/guidance-without-handholding.html',
      'level-design/verticality-sightlines.html',
    ],
  },
  {
    name: 'Part V',
    title: 'Systems Design',
    blurb: 'Economies, progression, balance, and the behaviors that emerge from rules.',
    pages: [
      'systems/index.html',
      'systems/economy-resources.html',
      'systems/progression-systems.html',
      'systems/balance-philosophy.html',
      'systems/emergent-behavior.html',
    ],
  },
  {
    name: 'Part VI',
    title: 'Pedagogy',
    blurb: 'How VG101 teaches: play, name, make, reflect. Accessibility, debugging, and code as material.',
    pages: [
      'pedagogy/index.html',
      'pedagogy/play-name-make-reflect.html',
      'pedagogy/accessibility-as-craft.html',
      'pedagogy/debugging-as-literacy.html',
      'pedagogy/code-as-material.html',
      'pedagogy/why-unity.html',
      'pedagogy/the-final-project.html',
    ],
  },
  {
    name: 'Part VII',
    title: 'Case Studies',
    blurb: 'Close readings of individual Gestures from published videogames.',
    pages: [
      'case-studies/index.html',
      'case-studies/celeste-dash.html',
      'case-studies/celeste-assist-mode.html',
      'case-studies/dark-souls-bonfire.html',
      'case-studies/hades-god-mode.html',
      'case-studies/portal-level-one.html',
      'case-studies/undertale-genocide.html',
    ],
  },
  {
    name: 'Part VIII',
    title: 'Code Bank',
    blurb: 'Small, readable implementations of the mechanics discussed throughout the text.',
    pages: [
      'code-bank/index.html',
      'code-bank/input-setup.html',
      'code-bank/basic-jump.html',
      'code-bank/variable-jump.html',
      'code-bank/double-jump.html',
      'code-bank/coyote-time.html',
      'code-bank/input-buffer.html',
      'code-bank/dash.html',
      'code-bank/squash-stretch.html',
      'code-bank/screen-shake.html',
      'code-bank/hitstop.html',
      'code-bank/knockback.html',
    ],
  },
  {
    name: 'Appendix',
    title: 'Reference',
    blurb: 'Glossary of terms and the reading list behind the course.',
    pages: [
      'glossary.html',
      'references.html',
    ],
  },
];

// ---- Extraction helpers -------------------------------------------------
function extract(pagePath) {
  const full = join(KB, 'pages', pagePath);
  const html = readFileSync(full, 'utf8');

  // Title from first <h1>
  const h1 = html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
  const title = h1 ? h1[1].replace(/<[^>]*>/g, '').trim() : pagePath;

  // Grab the content-wrapper inner HTML (between the opening tag and </main>)
  const startTag = '<div class="content-wrapper">';
  const startIdx = html.indexOf(startTag);
  const mainCloseIdx = html.indexOf('</main>', startIdx);
  let body = html.slice(startIdx + startTag.length, mainCloseIdx);
  // Drop the final </div> that closes content-wrapper
  body = body.replace(/<\/div>\s*$/, '');

  // Remove breadcrumb nav
  body = body.replace(/<nav class="breadcrumb">[\s\S]*?<\/nav>/i, '');

  // Remove the leading <h1>...</h1> (we render our own chapter heading)
  body = body.replace(/<h1[^>]*>[\s\S]*?<\/h1>/i, '');

  // Expand every collapsible register / nav section
  body = body.replace(/\bcollapsed\b/g, '');

  // Force every <details> (code blocks) open so the code prints
  body = body.replace(/<details\b/g, '<details open');

  // Rewrite image paths (any number of ../ then images/) to absolute file URL
  body = body.replace(/src="(?:\.\.\/)+images\//g, `src="${IMAGES_URL}/`);

  // Neutralize internal .html links -> keep text, drop navigation
  body = body.replace(/<a\b([^>]*?)href="([^"]*?\.html[^"]*?)"([^>]*)>/gi,
    '<a class="xref"$1$3>');

  return { title, body };
}

// ---- Build combined HTML ------------------------------------------------
let chapters = [];
let toc = [];
let chapterN = 0;

for (const part of parts) {
  const partId = 'part-' + part.name.toLowerCase().replace(/\s+/g, '-');
  toc.push({ type: 'part', id: partId, name: part.name, title: part.title });
  let inner = `
    <section class="part-divider" id="${partId}">
      <div class="part-kicker">${part.name}</div>
      <h1 class="part-title">${part.title}</h1>
      <p class="part-blurb">${part.blurb}</p>
    </section>`;
  for (const p of part.pages) {
    chapterN++;
    const id = 'ch-' + chapterN;
    const { title, body } = extract(p);
    toc.push({ type: 'chapter', id, n: chapterN, title });
    inner += `
    <section class="chapter" id="${id}">
      <div class="chapter-num">${part.name}</div>
      <h1 class="chapter-title">${title}</h1>
      ${body}
    </section>`;
  }
  chapters.push(inner);
}

const tocHtml = toc.map(t => t.type === 'part'
  ? `<li class="toc-part"><a href="#${t.id}"><span>${t.name}</span><span class="toc-part-title">${t.title}</span></a></li>`
  : `<li class="toc-chapter"><a href="#${t.id}"><span class="toc-n">${t.n}</span><span class="toc-t">${t.title}</span></a></li>`
).join('\n');

const css = readFileSync(join(KB, 'css', 'style.css'), 'utf8');

const doc = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>VG101 — A Videogame Design Textbook</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Lora:ital,wght@0,400;0,500;0,600;1,400&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
<style>
${css}
</style>
<style>
/* ---- Print / book overrides ---- */
:root { --page-w: 7.5in; }
* { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
html, body { background: #ffffff; }
body { color: #1a1a1a; font-family: 'Lora', Georgia, serif; }
.site-container, .sidebar, .mobile-nav-toggle, .mobile-nav-overlay { display: block; }
.sidebar { display: none !important; }
.main-content { margin: 0 !important; padding: 0 !important; max-width: none !important; }
.book { max-width: var(--page-w); margin: 0 auto; }

@page { size: Letter; margin: 0.85in 0.9in; }

/* Cover */
.cover { height: 9.0in; display: flex; flex-direction: column; justify-content: center;
  text-align: center; page-break-after: always; }
.cover .brand { font-family: 'Inter', sans-serif; letter-spacing: .35em; text-transform: uppercase;
  font-size: 13px; color: #14b8a6; margin-bottom: 2rem; }
.cover h1 { font-family: 'Inter', sans-serif; font-weight: 700; font-size: 68px; line-height: 1.02;
  margin: 0 0 1.2rem; color: #0f172a; border: none; }
.cover .sub { font-size: 22px; color: #475569; font-style: italic; margin-bottom: 3rem; }
.cover .byline { font-family: 'Inter', sans-serif; font-size: 15px; color: #334155; }
.cover .rule { width: 64px; height: 3px; background: #14b8a6; margin: 2rem auto; }

/* TOC */
.toc { page-break-after: always; }
.toc h2 { font-family: 'Inter', sans-serif; font-size: 30px; color: #0f172a; margin: 0 0 1.5rem;
  border-bottom: 2px solid #14b8a6; padding-bottom: .5rem; }
.toc ul { list-style: none; padding: 0; margin: 0; }
.toc a { text-decoration: none; color: inherit; display: flex; gap: .75rem; align-items: baseline; }
.toc-part { margin: 1.4rem 0 .5rem; }
.toc-part a { font-family: 'Inter', sans-serif; font-weight: 700; color: #0f172a; }
.toc-part span:first-child { color: #14b8a6; letter-spacing: .12em; text-transform: uppercase; font-size: 12px; }
.toc-part-title { font-size: 18px; }
.toc-chapter { margin: .28rem 0 .28rem 1.2rem; }
.toc-chapter a { font-family: 'Lora', serif; font-size: 15px; color: #334155; }
.toc-n { display: inline-block; min-width: 1.6em; color: #94a3b8; font-variant-numeric: tabular-nums; }

/* Part dividers */
.part-divider { page-break-before: always; page-break-after: always; height: 8.4in;
  display: flex; flex-direction: column; justify-content: center; text-align: left; }
.part-kicker { font-family: 'Inter', sans-serif; letter-spacing: .3em; text-transform: uppercase;
  color: #14b8a6; font-size: 15px; margin-bottom: 1rem; }
.part-title { font-family: 'Inter', sans-serif; font-weight: 700; font-size: 52px; color: #0f172a;
  margin: 0 0 1.5rem; border: none; }
.part-blurb { font-size: 20px; color: #475569; max-width: 5in; line-height: 1.5; }

/* Chapters */
.chapter { page-break-before: always; }
.chapter-num { font-family: 'Inter', sans-serif; letter-spacing: .2em; text-transform: uppercase;
  color: #14b8a6; font-size: 12px; margin-bottom: .4rem; }
.chapter-title { font-family: 'Inter', sans-serif; font-weight: 700; font-size: 34px; color: #0f172a;
  margin: 0 0 1.5rem; padding-bottom: .6rem; border-bottom: 2px solid #e2e8f0; }
.chapter h2 { font-family: 'Inter', sans-serif; color: #0f172a; margin-top: 1.8rem; }
.chapter h3 { font-family: 'Inter', sans-serif; color: #1e293b; }
.chapter p, .chapter li { font-family: 'Lora', serif; font-size: 12pt; line-height: 1.6; color: #1f2937; }
.chapter .lead { font-size: 15pt; color: #334155; font-style: italic; }

/* Registers -> always visible, print-friendly boxes */
.register { border: 1px solid #e2e8f0; border-radius: 8px; margin: 1.2rem 0; overflow: hidden;
  page-break-inside: avoid; }
.register-content { display: block !important; max-height: none !important; padding: 1rem 1.2rem; }
.register-header { padding: .5rem 1.2rem; font-family: 'Inter', sans-serif; font-weight: 600;
  cursor: default; }
.register--practice { border-left: 4px solid #14b8a6; }
.register--practice .register-header { background: #ecfdf5; color: #0f766e; }
.register--craft { border-left: 4px solid #3b82f6; }
.register--craft .register-header { background: #eff6ff; color: #1d4ed8; }
.register--theory { border-left: 4px solid #a855f7; }
.register--theory .register-header { background: #faf5ff; color: #7e22ce; }
.register-header::after, .register-header::before { display: none !important; }
.register-label { font-weight: 400; opacity: .7; }

/* Figures: block, centered, never split */
.vg-figure, figure { float: none !important; width: auto !important; max-width: 100% !important;
  margin: 1.2rem auto !important; page-break-inside: avoid; text-align: center; }
.vg-figure img, figure img { max-width: 100%; height: auto; border-radius: 6px; }
figcaption { font-size: 10pt; color: #64748b; font-style: italic; margin-top: .4rem; }
.vg-credit { display: block; font-size: 8.5pt; color: #94a3b8; }

/* Code */
pre { background: #0f172a; color: #e2e8f0; padding: 1rem; border-radius: 6px; overflow: hidden;
  white-space: pre-wrap; word-break: break-word; page-break-inside: avoid; }
pre, code { font-family: 'JetBrains Mono', monospace; font-size: 9.5pt; }
:not(pre) > code { background: #f1f5f9; color: #0f172a; padding: 1px 4px; border-radius: 3px; }

/* Code Bank <details> filename headers */
details.code-block { margin: .8rem 0 1.2rem; page-break-inside: avoid; }
details.code-block > summary { list-style: none; background: #1e293b; color: #93c5fd;
  font-family: 'JetBrains Mono', monospace; font-size: 9.5pt; padding: .5rem .9rem;
  border-radius: 6px 6px 0 0; }
details.code-block > summary::-webkit-details-marker,
details.code-block > summary::marker { display: none; content: ''; }
details.code-block[open] > summary { border-bottom: 1px solid #334155; }
details.code-block > pre { margin-top: 0; border-radius: 0 0 6px 6px;
  max-height: none !important; overflow: visible !important; }
details.code-block { overflow: visible !important; }
pre, .register-content { max-height: none !important; overflow: visible !important; }

/* Tables */
table { width: 100%; border-collapse: collapse; margin: 1rem 0; page-break-inside: avoid; font-size: 10.5pt; }
th, td { border: 1px solid #e2e8f0; padding: .5rem .6rem; text-align: left; font-family: 'Inter', sans-serif; }
th { background: #f8fafc; }

/* Cross-references become plain emphasized text (links go nowhere in print) */
a.xref, a.term { color: #0f766e; text-decoration: none; border-bottom: 1px dotted #f59e0b; }

h2 { border: none; }
hr { border: none; border-top: 1px solid #e2e8f0; margin: 2rem 0; }
img { break-inside: avoid; }
</style>
</head>
<body>
<div class="book">

  <section class="cover">
    <div class="brand">VG101 Knowledge Base</div>
    <h1>Videogames<br>as Their Own<br>Medium</h1>
    <div class="rule"></div>
    <div class="sub">A complete text on videogame design</div>
    <div class="byline">Marty Scott · marty64.net</div>
  </section>

  <nav class="toc">
    <h2>Contents</h2>
    <ul>
${tocHtml}
    </ul>
  </nav>

${chapters.join('\n')}

</div>
</body>
</html>`;

mkdirSync(join(__dirname, 'out'), { recursive: true });
const outHtml = join(__dirname, 'out', 'vg101-textbook.html');
writeFileSync(outHtml, doc, 'utf8');
console.log('Wrote', outHtml);
console.log('Chapters:', chapterN, 'Parts:', parts.length);
