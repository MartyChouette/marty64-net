/* ========================================
   Marty64 Knowledge Base - Main JavaScript
   ======================================== */

// ========================================
// Search Index
// ========================================

const searchIndex = [
  // Framework
  { title: "Gesture", section: "Framework", url: "pages/framework/gesture.html", 
    keywords: "action aesthetic arc atmosphere feel unit experience" },
  { title: "Aesthetic Heritage", section: "Framework", url: "pages/framework/aesthetic-heritage.html",
    keywords: "lineage history inheritance quotation transformation cinema music" },
  { title: "Permissions", section: "Framework", url: "pages/framework/permissions.html",
    keywords: "agency authorship allow require forbid moral" },
  { title: "Action Grammar", section: "Framework", url: "pages/framework/action-grammar.html",
    keywords: "verbs actions inputs possibility space layer one" },
  { title: "Feedback & Readability", section: "Framework", url: "pages/framework/feedback-readability.html",
    keywords: "communication juice clarity visual audio feedback layer two" },
  { title: "Meaning from Dynamics", section: "Framework", url: "pages/framework/meaning-from-dynamics.html",
    keywords: "procedural rhetoric ludonarrative interpretation meaning layer three" },
  
  // Foundations
  { title: "What Makes a Game", section: "Foundations", url: "pages/foundations/what-makes-a-game.html",
    keywords: "definition play rules magic circle huizinga" },
  { title: "Player Psychology", section: "Foundations", url: "pages/foundations/player-psychology.html",
    keywords: "motivation flow engagement reward intrinsic extrinsic" },
  { title: "Feedback Loops", section: "Foundations", url: "pages/foundations/feedback-loops.html",
    keywords: "positive negative snowball rubber banding systems" },
  { title: "The Design Lens", section: "Foundations", url: "pages/foundations/the-design-lens.html",
    keywords: "perspective analysis framework schell methodology" },
  
  // Narrative
  { title: "Environmental Storytelling", section: "Narrative", url: "pages/narrative/environmental-storytelling.html",
    keywords: "space objects discovery world found narrative" },
  { title: "Branching & Consequence", section: "Narrative", url: "pages/narrative/branching-consequence.html",
    keywords: "choice paths endings foldback consequence" },
  { title: "Dialogue Systems", section: "Narrative", url: "pages/narrative/dialogue-systems.html",
    keywords: "conversation npc trees hub spoke" },
  { title: "Ludonarrative Harmony", section: "Narrative", url: "pages/narrative/ludonarrative-harmony.html",
    keywords: "dissonance story mechanics theme coherence" },
  
  // Level Design
  { title: "Spatial Communication", section: "Level Design", url: "pages/level-design/spatial-communication.html",
    keywords: "space guidance landmarks framing contrast" },
  { title: "Pacing & Flow", section: "Level Design", url: "pages/level-design/pacing-flow.html",
    keywords: "rhythm tension release intensity curve" },
  { title: "Guidance Without Hand-Holding", section: "Level Design", url: "pages/level-design/guidance-without-handholding.html",
    keywords: "tutorial teaching implicit discovery" },
  { title: "Verticality & Sight Lines", section: "Level Design", url: "pages/level-design/verticality-sightlines.html",
    keywords: "height view weenie vista camera" },
  
  // Systems
  { title: "Economy & Resources", section: "Systems", url: "pages/systems/economy-resources.html",
    keywords: "currency source sink flow inflation" },
  { title: "Progression Systems", section: "Systems", url: "pages/systems/progression-systems.html",
    keywords: "leveling skill tree unlock xp meta" },
  { title: "Balance Philosophy", section: "Systems", url: "pages/systems/balance-philosophy.html",
    keywords: "fairness tuning metagame nerf buff" },
  { title: "Emergent Behavior", section: "Systems", url: "pages/systems/emergent-behavior.html",
    keywords: "emergence systemic simulation dwarf fortress" },
  
  // Pedagogy
  { title: "Play → Name → Make → Reflect", section: "Pedagogy", url: "pages/pedagogy/play-name-make-reflect.html",
    keywords: "rhythm teaching learning weekly cycle" },
  { title: "Debugging as Literacy", section: "Pedagogy", url: "pages/pedagogy/debugging-as-literacy.html",
    keywords: "code reading failure learning craft" },
  { title: "Accessibility as Craft", section: "Pedagogy", url: "pages/pedagogy/accessibility-as-craft.html",
    keywords: "inclusive design disability universal" },
  { title: "Code as Material", section: "Pedagogy", url: "pages/pedagogy/code-as-material.html",
    keywords: "programming design prototype implementation" },
  
  // Code Bank
  { title: "Code Bank", section: "Code Bank", url: "pages/code-bank/index.html",
    keywords: "scaffolds unity scripts implementation" },
  { title: "Basic Jump", section: "Code Bank", url: "pages/code-bank/basic-jump.html",
    keywords: "jump platformer fixed height gravity" },
  { title: "Variable Jump", section: "Code Bank", url: "pages/code-bank/variable-jump.html",
    keywords: "jump hold height variable platformer" },
  { title: "Dash", section: "Code Bank", url: "pages/code-bank/dash.html",
    keywords: "dash burst movement celeste action" },
  { title: "Screen Shake", section: "Code Bank", url: "pages/code-bank/screen-shake.html",
    keywords: "shake camera feedback juice impact" },
  
  // Case Studies
  { title: "Celeste: The Dash", section: "Case Studies", url: "pages/case-studies/celeste-dash.html",
    keywords: "celeste dash gesture feel feedback" },
  { title: "Dark Souls: The Bonfire", section: "Case Studies", url: "pages/case-studies/dark-souls-bonfire.html",
    keywords: "dark souls bonfire checkpoint heritage" },
  
  // Reference
  { title: "Glossary", section: "Reference", url: "pages/glossary.html",
    keywords: "terms definitions vocabulary" },
  { title: "References", section: "Reference", url: "pages/references.html",
    keywords: "thinkers texts theory reading" },
];

// ========================================
// Search Functionality
// ========================================

function initSearch() {
  const searchInput = document.getElementById('search-input');
  const searchResults = document.getElementById('search-results');
  
  if (!searchInput || !searchResults) return;
  
  searchInput.addEventListener('input', function(e) {
    const query = e.target.value.toLowerCase().trim();
    
    if (query.length < 2) {
      searchResults.classList.remove('active');
      return;
    }
    
    const results = searchIndex.filter(item => {
      return item.title.toLowerCase().includes(query) ||
             item.keywords.toLowerCase().includes(query) ||
             item.section.toLowerCase().includes(query);
    });
    
    if (results.length === 0) {
      searchResults.innerHTML = '<div class="search-result-item">No results found</div>';
    } else {
      searchResults.innerHTML = results.slice(0, 10).map(item => `
        <div class="search-result-item" onclick="window.location.href='${getRelativePath()}${item.url}'">
          <div class="search-result-title">${item.title}</div>
          <div class="search-result-section">${item.section}</div>
        </div>
      `).join('');
    }
    
    searchResults.classList.add('active');
  });
  
  // Close results when clicking outside
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.search-wrapper')) {
      searchResults.classList.remove('active');
    }
  });
  
  // Keyboard navigation
  searchInput.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      searchResults.classList.remove('active');
      searchInput.blur();
    }
  });
}

// ========================================
// Get relative path based on current location
// ========================================

function getRelativePath() {
  const path = window.location.pathname;
  const depth = (path.match(/\//g) || []).length - 1;
  
  if (path.includes('/pages/')) {
    // Count depth from pages folder
    const afterPages = path.split('/pages/')[1];
    const subDepth = (afterPages.match(/\//g) || []).length;
    return '../'.repeat(subDepth + 1);
  }
  
  return '';
}

// ========================================
// Toggle Sections (Pedagogy/Philosophy)
// ========================================

function initToggles() {
  document.querySelectorAll('.pedagogy-header, .philosophy-header').forEach(header => {
    header.addEventListener('click', function() {
      const content = this.nextElementSibling;
      const icon = this.querySelector('.toggle-icon');
      
      content.classList.toggle('collapsed');
      icon.textContent = content.classList.contains('collapsed') ? '▶' : '▼';
    });
  });
}

// ========================================
// Active Nav Highlighting
// ========================================

function initActiveNav() {
  const currentPath = window.location.pathname;
  
  document.querySelectorAll('.nav-link').forEach(link => {
    if (currentPath.includes(link.getAttribute('href'))) {
      link.classList.add('active');
    }
  });
}

// ========================================
// Mobile Navigation
// ========================================

function initMobileNav() {
  const toggle = document.querySelector('.mobile-nav-toggle');
  const sidebar = document.querySelector('.sidebar');
  const overlay = document.querySelector('.mobile-nav-overlay');

  if (!toggle || !sidebar) return;

  // Create overlay if it doesn't exist
  let navOverlay = overlay;
  if (!navOverlay) {
    navOverlay = document.createElement('div');
    navOverlay.className = 'mobile-nav-overlay';
    document.body.appendChild(navOverlay);
  }

  function openMenu() {
    toggle.classList.add('active');
    sidebar.classList.add('mobile-open');
    navOverlay.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeMenu() {
    toggle.classList.remove('active');
    sidebar.classList.remove('mobile-open');
    navOverlay.classList.remove('active');
    document.body.style.overflow = '';
  }

  toggle.addEventListener('click', function() {
    if (sidebar.classList.contains('mobile-open')) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  navOverlay.addEventListener('click', closeMenu);

  // Close on escape key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && sidebar.classList.contains('mobile-open')) {
      closeMenu();
    }
  });

  // Close when clicking a nav link (for same-page navigation)
  sidebar.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', closeMenu);
  });
}

// ========================================
// Initialize on DOM Ready
// ========================================

document.addEventListener('DOMContentLoaded', function() {
  initSearch();
  initToggles();
  initActiveNav();
  initMobileNav();
});

// ========================================
// Utility: Convert markdown-style links
// ========================================

function convertWikiLinks(content) {
  // Convert [[link]] to proper HTML links
  return content.replace(/\[\[([^\]]+)\]\]/g, function(match, p1) {
    const parts = p1.split('|');
    const url = parts[0].replace(/\//g, '-') + '.html';
    const text = parts[1] || parts[0].split('/').pop();
    return `<a href="${url}">${text}</a>`;
  });
}
