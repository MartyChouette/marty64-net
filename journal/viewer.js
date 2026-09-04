/* ============================================================
   viewer.js - password gate + reads data.json + renders entries
   ============================================================ */

// SHA-256 hex of the viewer passphrase. Default passphrase: "marty64".
// Change it from the editor (edit.html -> "Set passphrase" tool),
// then paste the new hash here.
const PASS_HASH = "9af47d12a7f31ee83340fb6b94c0fa1f191e1e017e48708ef60fe881de5acfe3";

const gate = document.getElementById('gate');
const app = document.getElementById('app');

async function sha256hex(str) {
  const buf = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(str));
  return [...new Uint8Array(buf)].map(b => b.toString(16).padStart(2, '0')).join('');
}

function unlock() {
  gate.classList.add('hidden');
  app.classList.remove('hidden');
  loadJournal();
}

// already unlocked this session?
if (sessionStorage.getItem('journal_ok') === '1') unlock();

document.getElementById('gate-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const val = document.getElementById('gate-input').value;
  const err = document.getElementById('gate-err');
  if (await sha256hex(val) === PASS_HASH) {
    sessionStorage.setItem('journal_ok', '1');
    unlock();
  } else {
    err.textContent = 'nope.';
    document.getElementById('gate-input').select();
  }
});

// ---------- render ----------
let DATA = { games: [] };

async function loadJournal() {
  try {
    const res = await fetch('data.json?_=' + Date.now());
    DATA = await res.json();
  } catch (e) {
    document.getElementById('reader').innerHTML =
      '<p class="empty">No data.json yet. Open the editor to create your first entry.</p>';
    return;
  }
  buildNav();
  // deep-link to an entry via #game/entry
  const hash = location.hash.slice(1);
  if (hash) {
    const [g, en] = hash.split('/');
    openEntry(g, en);
  }
}

function buildNav() {
  const nav = document.getElementById('nav');
  nav.innerHTML = '';
  if (!DATA.games || !DATA.games.length) {
    nav.innerHTML = '<p class="empty" style="margin-top:1rem">No games yet.</p>';
    return;
  }
  DATA.games.forEach((game, gi) => {
    const group = document.createElement('div');
    group.className = 'game-group' + (gi === 0 ? '' : ' collapsed');
    const accent = game.accent || '#f59e0b';

    const title = document.createElement('div');
    title.className = 'game-title';
    title.innerHTML =
      `<span class="dot" style="background:${accent}"></span>` +
      `<span>${escapeHtml(game.title || game.slug)}</span>` +
      `<span class="chev">&#9660;</span>`;
    title.addEventListener('click', () => group.classList.toggle('collapsed'));
    group.appendChild(title);

    const ul = document.createElement('ul');
    ul.className = 'entry-list';
    const entries = [...(game.entries || [])].sort((a, b) => (b.date || '').localeCompare(a.date || ''));
    entries.forEach(entry => {
      const li = document.createElement('li');
      const a = document.createElement('a');
      a.href = `#${game.slug}/${entry.slug}`;
      a.dataset.g = game.slug; a.dataset.e = entry.slug;
      a.innerHTML = `${escapeHtml(entry.title || entry.slug)}` +
        (entry.date ? `<span class="e-date">${entry.date}</span>` : '');
      a.addEventListener('click', () => { setTimeout(() => openEntry(game.slug, entry.slug), 0); });
      li.appendChild(a);
      ul.appendChild(li);
    });
    group.appendChild(ul);
    nav.appendChild(group);
  });
}

async function openEntry(gameSlug, entrySlug) {
  const game = DATA.games.find(g => g.slug === gameSlug);
  if (!game) return;
  const entry = (game.entries || []).find(e => e.slug === entrySlug);
  if (!entry) return;

  document.querySelectorAll('.entry-list a').forEach(a =>
    a.classList.toggle('active', a.dataset.g === gameSlug && a.dataset.e === entrySlug));
  // make sure its group is open
  document.querySelectorAll('.game-group').forEach(grp => {
    if (grp.querySelector(`a[data-g="${gameSlug}"]`)) grp.classList.remove('collapsed');
  });

  const reader = document.getElementById('reader');
  reader.style.setProperty('--j-accent', game.accent || '#f59e0b');
  reader.innerHTML = '<p class="empty">Loading...</p>';

  let body = '';
  try {
    const res = await fetch(entry.file + '?_=' + Date.now());
    body = await res.text();
  } catch (e) {
    body = '_Could not load this entry file._';
  }

  const fmt = entry.format || game.layout || 'log';
  const tags = (entry.tags || []).map(t => `<span class="tag">${escapeHtml(t)}</span>`).join(' ');
  reader.className = 'reader format-' + fmt;
  reader.innerHTML = `
    <header class="entry-head">
      <div class="kicker">${escapeHtml(game.title || game.slug)}</div>
      <h1>${escapeHtml(entry.title || entry.slug)}</h1>
      <div class="meta">
        ${entry.date ? `<span>${entry.date}</span>` : ''}
        ${tags ? `<span>${tags}</span>` : ''}
      </div>
    </header>
    <article class="content">${MD.render(body)}</article>
  `;
  window.scrollTo(0, 0);
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
}
