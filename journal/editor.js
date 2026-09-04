/* ============================================================
   editor.js - local authoring tool.
   Uses the File System Access API to write entry files, screenshot
   images, and data.json straight into your journal/ folder.
   Then you commit + push manually.
   Requires a Chromium browser (Chrome/Edge/Brave). No backend.
   ============================================================ */

let dirHandle = null;
let data = { games: [] };
let pendingImages = []; // {path, blob}

const $ = id => document.getElementById(id);

// ---------- remember the folder across reloads (IndexedDB) ----------
const IDB = 'journal-editor', STORE = 'handles';
function idb() {
  return new Promise((res, rej) => {
    const r = indexedDB.open(IDB, 1);
    r.onupgradeneeded = () => r.result.createObjectStore(STORE);
    r.onsuccess = () => res(r.result);
    r.onerror = () => rej(r.error);
  });
}
async function idbSet(k, v) { const db = await idb(); return new Promise(r => { const t = db.transaction(STORE, 'readwrite'); t.objectStore(STORE).put(v, k); t.oncomplete = r; }); }
async function idbGet(k) { const db = await idb(); return new Promise(r => { const t = db.transaction(STORE, 'readonly'); const q = t.objectStore(STORE).get(k); q.onsuccess = () => r(q.result); q.onerror = () => r(null); }); }

// ---------- FS helpers ----------
async function ensurePerm(handle) {
  const opts = { mode: 'readwrite' };
  if (await handle.queryPermission(opts) === 'granted') return true;
  return await handle.requestPermission(opts) === 'granted';
}
async function getDir(root, parts) {
  let h = root;
  for (const p of parts) h = await h.getDirectoryHandle(p, { create: true });
  return h;
}
async function writeFile(root, pathParts, contents) {
  const name = pathParts.pop();
  const dir = await getDir(root, pathParts);
  const fh = await dir.getFileHandle(name, { create: true });
  const w = await fh.createWritable();
  await w.write(contents);
  await w.close();
}
async function readJsonMaybe(root, name) {
  try {
    const fh = await root.getFileHandle(name);
    const txt = await (await fh.getFile()).text();
    return JSON.parse(txt);
  } catch { return null; }
}

// ---------- connect ----------
async function connect(handle) {
  if (!(await ensurePerm(handle))) { setFolder('permission denied', false); return; }
  dirHandle = handle;
  await idbSet('journalDir', handle);
  const loaded = await readJsonMaybe(handle, 'data.json');
  data = loaded || { games: [] };
  setFolder('connected: ' + handle.name, true);
  $('main').style.opacity = '1';
  $('main').style.pointerEvents = 'auto';
  refreshGameSelect();
}
function setFolder(msg, ok) {
  const el = $('folder-status');
  el.textContent = msg;
  el.className = 'status ' + (ok ? 'ok' : 'err');
}

let savedHandle = null;

$('connect-btn').addEventListener('click', async () => {
  if (!window.showDirectoryPicker) {
    setFolder('this browser has no File System Access API - use Chrome/Edge', false);
    return;
  }
  // reuse the last folder if we still have it (avoids re-picking every session)
  if (savedHandle) {
    try { await connect(savedHandle); return; } catch (e) { /* fall through to picker */ }
  }
  try {
    const handle = await window.showDirectoryPicker({ mode: 'readwrite' });
    await connect(handle);
  } catch (e) { /* user cancelled the picker */ }
});

// try to restore last folder reference on load
(async () => {
  savedHandle = await idbGet('journalDir');
  if (savedHandle) setFolder('found "' + savedHandle.name + '" - click Connect to reuse', false);
})();

// ---------- game select ----------
const NEW = '__new__';
function refreshGameSelect() {
  const sel = $('game-select');
  sel.innerHTML = '';
  data.games.forEach(g => {
    const o = document.createElement('option');
    o.value = g.slug; o.textContent = g.title || g.slug;
    sel.appendChild(o);
  });
  const o = document.createElement('option');
  o.value = NEW; o.textContent = '+ new game...';
  sel.appendChild(o);
  toggleNewGame();
}
function toggleNewGame() {
  const isNew = $('game-select').value === NEW;
  $('new-game-fields').style.display = isNew ? '' : 'none';
  $('new-game-accent-wrap').style.display = isNew ? '' : 'none';
}
$('game-select').addEventListener('change', toggleNewGame);

// ---------- slug + date ----------
function slugify(s) {
  return String(s).toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '').slice(0, 60) || 'untitled';
}
function today() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}
$('entry-date').value = today();

// ---------- live preview ----------
function updatePreview() { $('preview').innerHTML = MD.render($('entry-body').value); }
$('entry-body').addEventListener('input', updatePreview);

// ---------- paste screenshots ----------
$('entry-body').addEventListener('paste', async (e) => {
  const items = [...(e.clipboardData?.items || [])];
  const imgItem = items.find(it => it.type.startsWith('image/'));
  if (!imgItem) return; // let normal text paste happen
  e.preventDefault();

  const gameSlug = currentGameSlug();
  if (!gameSlug) { flash('Pick or name a game first, then paste.', false); return; }

  const blob = imgItem.getAsFile();
  const ext = (blob.type.split('/')[1] || 'png').replace('jpeg', 'jpg');
  const stamp = today() + '-' + Date.now().toString(36) + '-' + pendingImages.length;
  const relPath = `media/${gameSlug}/${stamp}.${ext}`;
  pendingImages.push({ path: relPath, blob });

  const ta = $('entry-body');
  const md = `\n![screenshot](${relPath})\n`;
  const pos = ta.selectionStart;
  ta.value = ta.value.slice(0, pos) + md + ta.value.slice(ta.selectionEnd);
  ta.selectionStart = ta.selectionEnd = pos + md.length;
  updatePreview();
  flash('Screenshot queued: ' + relPath, true);
});

function currentGameSlug() {
  const sel = $('game-select').value;
  if (sel === NEW) {
    const t = $('new-game-title').value.trim();
    return t ? slugify(t) : '';
  }
  return sel;
}

// ---------- save ----------
$('save-btn').addEventListener('click', async () => {
  if (!dirHandle) { flash('Connect the journal folder first.', false); return; }
  const title = $('entry-title').value.trim();
  if (!title) { flash('Give the entry a title.', false); return; }

  const sel = $('game-select').value;
  let game;
  if (sel === NEW) {
    const gt = $('new-game-title').value.trim();
    if (!gt) { flash('Name the new game.', false); return; }
    const gslug = slugify(gt);
    if (data.games.some(g => g.slug === gslug)) { flash('That game slug already exists.', false); return; }
    game = { slug: gslug, title: gt, accent: $('new-game-accent').value, layout: $('entry-format').value, entries: [] };
    data.games.push(game);
  } else {
    game = data.games.find(g => g.slug === sel);
  }

  const date = $('entry-date').value || today();
  const slug = date + '-' + slugify(title);
  const tags = $('entry-tags').value.split(',').map(t => t.trim()).filter(Boolean);
  const body = $('entry-body').value;
  const file = `entries/${game.slug}/${slug}.md`;

  try {
    // 1) write queued screenshots
    for (const img of pendingImages) {
      await writeFile(dirHandle, img.path.split('/'), img.blob);
    }
    // 2) write the entry markdown
    await writeFile(dirHandle, file.split('/'), body);
    // 3) update the index
    const existing = (game.entries || []).find(en => en.slug === slug);
    const rec = { slug, title, date, format: $('entry-format').value, tags, file };
    if (existing) Object.assign(existing, rec);
    else { game.entries = game.entries || []; game.entries.push(rec); }
    // 4) write data.json
    await writeFile(dirHandle, ['data.json'], JSON.stringify(data, null, 2));

    const imgCount = pendingImages.length;
    pendingImages = [];
    refreshGameSelect();
    $('game-select').value = game.slug; toggleNewGame();
    flash(`Saved ${file}${imgCount ? ' + ' + imgCount + ' image(s)' : ''}. Now: git add -A && git commit && git push`, true);
  } catch (e) {
    flash('Save failed: ' + e.message, false);
  }
});

function flash(msg, ok) {
  const el = $('save-status');
  el.textContent = msg;
  el.className = 'status ' + (ok ? 'ok' : 'err');
}

// ---------- passphrase hash tool ----------
$('pass-btn').addEventListener('click', async () => {
  const v = $('pass-input').value;
  if (!v) return;
  const buf = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(v));
  const hex = [...new Uint8Array(buf)].map(b => b.toString(16).padStart(2, '0')).join('');
  $('pass-out').innerHTML =
    'Paste this into <code>viewer.js</code> as <code>PASS_HASH</code>:<br><code>' + hex + '</code>';
});

updatePreview();
