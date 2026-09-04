/* ============================================================
   md.js - a small, self-contained markdown renderer
   Handles: headings, bold, italic, inline code, fenced code,
   blockquotes, hr, ordered/unordered lists, links, images.
   Raw HTML lines (starting with '<') are passed through so you
   can drop custom markup into an entry for a different look.
   Single trusted author, so no sanitizing.
   ============================================================ */
(function (global) {
  function inline(s) {
    // images first, then links
    s = s.replace(/!\[([^\]]*)\]\(([^)\s]+)(?:\s+"([^"]*)")?\)/g,
      (_, alt, src, title) =>
        `<img src="${src}" alt="${alt}"${title ? ` title="${title}"` : ''} loading="lazy">`);
    s = s.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g,
      (_, txt, href) => `<a href="${href}" target="_blank" rel="noopener">${txt}</a>`);
    s = s.replace(/`([^`]+)`/g, (_, c) =>
      `<code>${c.replace(/&/g, '&amp;').replace(/</g, '&lt;')}</code>`);
    s = s.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    s = s.replace(/(^|[^*])\*([^*]+)\*/g, '$1<em>$2</em>');
    return s;
  }

  function render(src) {
    const lines = (src || '').replace(/\r\n/g, '\n').split('\n');
    let out = [];
    let i = 0;
    let listType = null; // 'ul' | 'ol'

    function closeList() {
      if (listType) { out.push(`</${listType}>`); listType = null; }
    }

    while (i < lines.length) {
      let line = lines[i];

      // fenced code block
      const fence = line.match(/^```(\w*)\s*$/);
      if (fence) {
        closeList();
        const lang = fence[1];
        const buf = [];
        i++;
        while (i < lines.length && !/^```\s*$/.test(lines[i])) { buf.push(lines[i]); i++; }
        i++; // skip closing fence
        const code = buf.join('\n')
          .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        out.push(`<pre class="code${lang ? ' lang-' + lang : ''}"><code>${code}</code></pre>`);
        continue;
      }

      // raw HTML block line: pass through untouched
      if (/^\s*<(\/?)([a-zA-Z][\w-]*)/.test(line)) {
        closeList();
        out.push(line);
        i++;
        continue;
      }

      // blank line
      if (/^\s*$/.test(line)) { closeList(); i++; continue; }

      // horizontal rule
      if (/^\s*(---|\*\*\*|___)\s*$/.test(line)) { closeList(); out.push('<hr>'); i++; continue; }

      // heading
      const h = line.match(/^(#{1,6})\s+(.*)$/);
      if (h) { closeList(); const l = h[1].length; out.push(`<h${l}>${inline(h[2])}</h${l}>`); i++; continue; }

      // blockquote (collect consecutive)
      if (/^\s*>\s?/.test(line)) {
        closeList();
        const buf = [];
        while (i < lines.length && /^\s*>\s?/.test(lines[i])) {
          buf.push(lines[i].replace(/^\s*>\s?/, '')); i++;
        }
        out.push(`<blockquote>${render(buf.join('\n'))}</blockquote>`);
        continue;
      }

      // unordered list
      if (/^\s*[-*+]\s+/.test(line)) {
        if (listType !== 'ul') { closeList(); out.push('<ul>'); listType = 'ul'; }
        out.push(`<li>${inline(line.replace(/^\s*[-*+]\s+/, ''))}</li>`); i++; continue;
      }
      // ordered list
      if (/^\s*\d+\.\s+/.test(line)) {
        if (listType !== 'ol') { closeList(); out.push('<ol>'); listType = 'ol'; }
        out.push(`<li>${inline(line.replace(/^\s*\d+\.\s+/, ''))}</li>`); i++; continue;
      }

      // paragraph (gather until blank / block)
      closeList();
      const buf = [line];
      i++;
      while (i < lines.length &&
             !/^\s*$/.test(lines[i]) &&
             !/^```/.test(lines[i]) &&
             !/^\s*<(\/?)([a-zA-Z])/.test(lines[i]) &&
             !/^(#{1,6})\s/.test(lines[i]) &&
             !/^\s*>\s?/.test(lines[i]) &&
             !/^\s*[-*+]\s+/.test(lines[i]) &&
             !/^\s*\d+\.\s+/.test(lines[i]) &&
             !/^\s*(---|\*\*\*|___)\s*$/.test(lines[i])) {
        buf.push(lines[i]); i++;
      }
      out.push(`<p>${inline(buf.join('<br>'))}</p>`);
    }
    closeList();
    return out.join('\n');
  }

  global.MD = { render };
})(window);
