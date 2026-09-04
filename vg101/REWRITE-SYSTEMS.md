# SYSTEMS PAGES - REWRITE FILE
# Instructions: Rewrite the text below however you want. Keep the headers as-is so I know where to put things. When you're done, save and tell me.
# I'll handle all the HTML, links, glossary terms, figures, and register logic. Just give me the voice.

---

# PAGE: Balance Philosophy (balance-philosophy.html)

## Lead
Balance is one of the most misunderstood concepts in videogame design. It doesn't mean "everything is equal." It means "everything is right for the experience you're creating." Balance is a philosophy, not a formula.

## Practice - what you do

### What Does "Balanced" Mean?
Balance has multiple, sometimes conflicting meanings:

Fairness: No player/option has unfair advantage. "Balanced" = "not broken."

Variety: Multiple strategies are viable. "Balanced" = "diverse meta."

Intentional Hierarchy: Some things are supposed to be better. "Balanced" = "power curve is correct."

Felt Rightness: It feels fair, even if numbers aren't equal. "Balanced" = "satisfying."

A videogame can be balanced in one sense and imbalanced in another. The first question: balanced for what?

### Balance Is Context-Dependent
Competitive: No dominant strategy; skill decides.
Cooperative: Each role contributes; no one carries alone.
Single-player: Challenge matches player progression; fair difficulty.
Asymmetric: Different sides have different strengths; overall match is even.
Casual: Feels good; specifics don't matter much.

Chess needs different balance than Mario Kart. League of Legends needs different balance than Stardew Valley.

### Perfect Balance Is Impossible (And Maybe Undesirable)
Reasons perfect balance fails:

Complexity: Any system complex enough to be interesting is too complex to perfectly balance analytically.

Player Diversity: Different players have different skills. "Balanced for pros" does not equal "balanced for casuals."

Meta Evolution: Players discover new strategies. What's balanced today is broken tomorrow.

Discovery Value: Finding what's strong is part of the fun. A perfectly flat meta is boring.

The goal isn't perfect balance. It's good enough balance - where imbalances don't ruin the experience.

### The Balance Process
1. Set Goals: What experience are you balancing for? "Competitive fairness" vs. "power fantasy" vs. "strategic diversity."
2. Identify Pain Points: What's actually breaking? Not everything needs tuning. Tune what hurts the experience.
3. Change One Thing: Single variable changes. If you change multiple things, you won't know which fixed (or broke) it.
4. Playtest: Theory doesn't catch everything. Watch real players. Especially skilled ones.
5. Iterate: Balance is never done. Especially in live games. Expect ongoing tuning.

### Balance Tools
Numbers: Stats, damage, cooldowns, costs. The obvious levers.

Access: When you can get something. A powerful item is less dominant if it comes late.

Counters: Rock-paper-scissors. Strength A beats B beats C beats A. Nothing dominates.

Opportunity Cost: Choosing X means not choosing Y. If X is strong but costs more, that's balance.

Skill Requirement: Powerful things that are hard to use are self-balancing. Skill floors and ceilings.

Information: Knowledge as balance. A strategy that works only if opponents don't know about it.

### Imbalance as Design
Some imbalance is intentional:

Power Curve: Early videogame is weak; late videogame is strong. That's the point.

Asymmetric Design: Different factions/classes should feel different. Equal is boring.

Discovery: If everything is equally viable, there's nothing to discover. Some imbalance creates exploration.

Narrative: Story might want you to feel weak, then strong. "Balance" undermines the arc.

The question: is this imbalance serving the design or breaking it?

### The Metagame
Metagame = the strategies players converge on given current balance.

A healthy meta has multiple viable strategies, counters to dominant strategies, room for innovation, and no single dominant "solved" approach.

An unhealthy meta has one or few dominant strategies, high barrier to competing, stagnation, and player frustration/exodus.

Balance patches reshape the meta. But heavy-handed patching alienates players who invested in now-nerfed strategies.

### Balance vs. Feel
Numbers can be balanced but feel wrong.

A 50% win rate option that feels terrible to play is "balanced" but bad.

Feel matters more than math. Players experience feel, not numbers. If it feels broken, it's broken - even if the spreadsheet says otherwise.

## Craft - for educators

### Teaching Notes
The "balance = equality" misconception is almost universal with new students. Start by breaking that before anything else.

### Exercise: Balance Audit
Take any asymmetric videogame (two different factions, classes, or options). Analyze: Are they equal? Should they be? What does "balanced" mean in this context?

### Common Misconceptions
"Nerfing strong options is always right." Sometimes the strong option should stay strong - it's the reward for learning or investing.

"Playtesting proves balance." Playtesters aren't the player population. What they find is real; what they don't find is still there.

## Theory - deeper grounding

### Theoretical Background
Balance theory in videogames draws from game theory (Nash equilibrium, dominant strategies), economics (market dynamics, resource allocation), and sports design (handicapping, division systems).

The difference: sports have fixed rules; videogames are patched. This makes balance an ongoing process, not a solved state.

### References
- David Sirlin, Playing to Win - competitive balance and dominant strategies
- Richard Garfield (Magic: The Gathering) talks on balance in trading card games
- League of Legends design blogs on meta-health and patch philosophy

---

# PAGE: Economy & Resources (economy-resources.html)

## Lead
An economy is any system where resources flow - created, spent, exchanged, lost. Most videogames have economies, even if they don't look like money. Understanding economy design is understanding how value moves through your videogame.

## Practice - what you do

### Resources
A resource is anything the player has, wants, or manages:
- Currencies: Gold, coins, credits, gems
- Consumables: Health potions, ammo, food
- Durables: Weapons, armor, tools
- Stats: Health, mana, stamina, experience
- Time: Real time, in-game time, cooldowns
- Attention: What the player can track and manage
- Space: Inventory slots, building area
- Information: Map knowledge, enemy patterns

If the player cares about having more or less of it, it's a resource.

### The Four Flows
Resources do four things:

Sources - Where resources come from (faucets): enemy drops, mission rewards, time-based generation, purchase/crafting.

Sinks - Where resources go (drains): spending on items, consumable use, decay/maintenance costs, death penalties.

Converters - One resource becomes another: crafting (materials to items), training (gold to stats), trading.

Storage - Where resources wait: inventory, banks, stockpiles.

Healthy economies have balanced flows - sources and sinks in rough equilibrium over time.

### Economic Health
Inflation: Too many sources, too few sinks. Resources pile up. Value collapses. Nothing feels precious.
Signs: Players have more gold than they can spend. Shops become irrelevant.

Deflation: Too many sinks, too few sources. Resources are scarce. Progress stalls. Players feel punished.
Signs: Players can never afford anything. Hoarding becomes mandatory.

Dead Currencies: A resource with no meaningful use. Takes up space, adds no decisions.
Signs: You collect something but never spend it. "What is this even for?"

Optimal Path: One strategy dominates. Choice becomes illusion.
Signs: Players always buy the same thing. Other options are "traps."

### Designing Economies
Start with Verbs: What do you want players to do? The economy should reward those actions.

Create Decisions: Resources should force interesting choices. "Save or spend?" "This upgrade or that?"

Tie to Progression: Resource flow should track player progress. Early scarcity, late abundance (or vice versa, strategically).

Playtest Relentlessly: Economies are emergent. You won't know the real balance until players optimize.

### Soft vs. Hard Currencies
Hard currency: Difficult to get, premium, often monetized. Real-money purchases, rare drops.

Soft currency: Easy to get, common, earned through play. Gold, experience.

In F2P design, the relationship between hard and soft currencies is the business model. Handle with ethical care.

### Single-Resource vs. Multi-Resource
Single-resource economies are simpler: one thing to track, clear value, limited depth.

Multi-resource economies add complexity: trade-offs between resources, conversion decisions, more possible strategies, harder to balance.

More isn't always better. Some videogames thrive on elegant single-resource economies (Into the Breach: just managing unit positioning).

### Closed vs. Open Economies
Closed: Fixed resource pool. What exists is what exists. Zero-sum.
Example: Chess - pieces don't regenerate.

Open: Resources generated over time. Not zero-sum.
Example: Most RPGs - gold keeps dropping.

Multiplayer consideration: Open economies in multiplayer create inflation over server lifetime. Closed economies create scarcity competition.

### Videogames to Study
- Universal Paperclips: Economy as the entire videogame. Watch resources transform and compound.
- Animal Crossing: Soft economy with real-time gates. Turnip market as emergent trading system.
- The Sims: Multi-resource economy (money, needs, relationships, time). Competing sinks.
- Eve Online: Player-driven economy at massive scale. Real inflation, real market crashes.

## Craft - for educators

### Teaching Notes
Economy design is invisible when it works. The best way to teach it is to break it first - show students a videogame with broken economy (either too much or too little) and ask them to diagnose it.

### Exercise: Resource Audit
Pick a videogame. List every resource type. For each: what are the sources? The sinks? Is there a converter? Is there storage? Where does it feel like there's too much or too little?

### Common Misconceptions
"More resources = more depth." Depth comes from meaningful decisions, not raw number of resources. More resources without more decisions is just more management.

"Economies are for RPGs." Every videogame has some form of economy. Even Tetris has an economy: pieces arrive (source), cleared lines disappear (sink). Understanding this is useful anywhere.

## Theory - deeper grounding

### Theoretical Background
Economy design draws from macroeconomics (supply and demand, inflation, deflation) and microeconomics (rational actor theory, opportunity cost).

The key difference from real economics: the designer controls both the rules and can observe all behavior. This makes testing tractable - you can run economic experiments that real economists can't.

### References
- Ramin Shokrizade - "Top F2P Monetization Tricks" and economy design writing
- EVE Online economy reports (published by CCP Games)
- Edward Castronova - Synthetic Worlds (real economics in virtual worlds)

---

# PAGE: Emergent Behavior (emergent-behavior.html)

## Lead
Emergence is when simple rules combine to produce complex, unexpected behaviors. It's when the videogame surprises its own designer. Emergent behavior is why Dwarf Fortress creates tragedies no author wrote, why Breath of the Wild enables solutions no designer anticipated, and why multiplayer videogames generate stories that single-player videogames can't.

## Practice - what you do

### What Is Emergence?
Emergence = macro-level patterns arising from micro-level rules.

The rules of chess are simple: how pieces move, capture, check. The strategies that emerge - openings, defenses, endgames - are not written in the rules. They emerge from players interacting with rules over time.

Emergence means the videogame has more possibility than you explicitly designed.

### Why Designers Love Emergence
Content Multiplication: Designers create rules. Players create content by combining those rules.
Breath of the Wild: Physics + fire + wind + enemies = infinite videos of creative kills.

Replayability: Emergent systems aren't solved. Each playthrough produces different patterns.

Player Authorship: Players feel like co-creators. The story that emerges is their story.

Surprise: Even the designer discovers new behaviors. The videogame is bigger than its creator.

### Why Emergence Is Hard
Unpredictability: You can't fully predict what will emerge. Playtesting reveals, but can't cover everything.

Exploits: Players find emergent behaviors that break the videogame. "Emergent" can mean "broken."

Balance Difficulty: Emergence + balance = nightmare. Systems interact in untestable combinations.

Narrative Dilution: Authored meaning requires control. Emergence cedes control. Hard to have both.

### Designing for Emergence
You can't design emergent behaviors directly - you design the conditions for emergence.

Combinable Elements: Systems that interact with each other. Fire spreads. Water conducts electricity. Enemies have physics.

Consistent Rules: Rules that always apply. If fire burns wood, it burns ALL wood - barrels, bridges, weapons.

Player-Readable Interactions: Players can predict (roughly) how combinations will work. Transparency enables experimentation.

Forgiving Failure: If experimenting is punished, players don't experiment. Emergence needs safety to explore.

Sandbox Spaces: Areas where players can test combinations without stakes.

### Emergence vs. Randomness
Emergence: Deterministic rules → unpredictable outcomes. Player understands why it happened. Replayable (same inputs → same outputs). Surprising but explicable.

Randomness: Non-deterministic events. Player doesn't control. Variable (same inputs → different outputs). Surprising and arbitrary.

Emergence feels like discovery. Randomness feels like luck (or bad luck).

### Emergent Narrative
Emergent narrative = stories that arise from systems rather than scripts.

Dwarf Fortress generates stories: a dwarf loses their spouse, falls into despair, drinks too much, stumbles into the forge, starts a fire, destroys the fort.

No author wrote that. The systems produced it.

What Enables Emergent Narrative:
- Agents with goals and states (characters who want things)
- Systems that create consequences (actions affect world state)
- Player interpretation (humans find stories in patterns)

Limits of Emergent Narrative:
- Rarely has dramatic structure (no rising action, climax)
- Can feel arbitrary or meaningless
- Lacks authored emotional arc
- Requires player investment to "see" the story

Emergent narrative supplements, but rarely replaces, authored narrative.

### Case Studies
Dwarf Fortress: Maximum emergence. Simple AI rules for dwarves, complex interactions with environment, no authored story. Players project narrative onto simulated events.

Noita: Physics-based emergence. Every pixel is simulated. Fire spreads, liquids flow, explosions chain. The videogame is constantly surprising itself.

Breath of the Wild: Constrained emergence. Physics systems interact predictably. Players discover combinations. Authored story exists alongside emergent play.

Hitman: Curated emergence. Systems enable many solutions, but levels are designed to suggest specific emergent moments.

Chess: Pure emergence. No narrative, just strategy arising from rules.

## Craft - for educators

### Teaching Notes
Emergence is best experienced before being explained. Show students Dwarf Fortress stories, or have them play Noita, before defining the term.

### Exercise: System Combination
Take any two simple systems and combine them. What emerges? Example: Fire system + enemy AI. Does the enemy flee fire? Use it? Ignore it? What happens when fire meets water? What happens when fire meets the player's attack?

Document unexpected behaviors.

### Common Misconceptions
"Emergence = randomness." Emergence is deterministic. The same setup produces the same result. It's complex, not random.

"More systems = more emergence." Systems need to interact to produce emergence. Ten isolated systems don't emerge. Two interacting systems might.

## Theory - deeper grounding

### Theoretical Background
Emergence has deep roots in complexity theory, chaos theory, and systems thinking. Simple rules producing complex behavior appears in physics (thermodynamics), biology (evolution, ecosystems), economics (markets), and sociology (culture).

In videogames, Will Wright's work (SimCity, The Sims, Spore) is the foundational exploration of designed emergence as medium.

### References
- Will Wright - GDC talks on systemic design
- Tynan Sylvester, Designing Games - the chapter on emergence
- John Holland, Hidden Order: How Adaptation Builds Complexity

---

# PAGE: Progression Systems (progression-systems.html)

## Lead
A progression system is any structure that tracks and displays player advancement. Levels, unlocks, skill trees, gear scores - all the ways videogames say "you're getting somewhere." Progression systems answer the question: how does the player know they're advancing?

## Practice - what you do

### Why Progression Matters
Extrinsic Motivation: Visible progress toward goals. The XP bar filling. The new ability unlocking.

Pacing Control: Gates content behind progression. Ensures players don't access everything immediately.

Investment Creation: The more you've leveled up, the more you have to lose by quitting.

Skill Scaffolding: New abilities introduce new complexity. Progression can match mechanical depth to player readiness.

Power Fantasy: Numbers go up. Character gets stronger. Feels good.

### Types of Progression
Character Progression: The avatar improves: stats, abilities, gear. Example: RPG leveling, skill trees, equipment upgrades.

Player Progression: The human improves: skill, knowledge, mastery. Example: Getting better at Dark Souls. No character stats changed - you changed.

World Progression: The videogame world changes: areas unlock, story advances, state evolves. Example: Metroidvania unlocks, NPC relationships, world state.

Meta Progression: Unlocks that persist across runs/sessions. Example: Roguelike permanent upgrades, account-wide unlocks.

Most videogames combine multiple types.

### Progression Structures
Linear: Everyone follows the same path. Level 1 → 2 → 3. Easy to balance. No player expression.

Branching: Choose your path through a tree. Player agency, replayability. Balance complexity.

Open: Any ability accessible (if you have currency/points). Maximum freedom. Can create trap options, analysis paralysis.

Gated: Progression unlocked by achievements, not just time/XP. Ties advancement to accomplishment. Can feel arbitrary.

### The Leveling Curve
How fast does the player progress? The leveling curve determines feel:

Linear Leveling: Same XP for each level. Predictable, but can feel grindy late-game.

Exponential Leveling: Each level takes more XP. Early levels fly by; late levels slow down. Creates extended endgame.

Logarithmic Leveling: Early levels are slow; later levels come faster. Rare, but used to extend early game.

Soft Cap / Hard Cap: Progression slows dramatically (soft) or stops entirely (hard) at a certain point.

The curve should match your pacing goals. Fast early = hook players. Slow late = extend engagement.

### Progression vs. Power
Progression = visible advancement. Power = actual capability increase.

These aren't the same:
- High Progression, Low Power: Level numbers go up, but enemies scale. You're not stronger, just "higher level."
- Low Progression, High Power: Few visible markers, but you feel much more capable. Dark Souls: same "level," but you learned the boss.
- Matched: Progression markers correspond to actual power increase. Traditional RPGs.
- Mismatched: Feels bad when you level up but don't feel stronger, or feel stronger but don't see it reflected.

### Skill Trees & Build Diversity
Skill trees create build diversity - different players develop different characters.

Good Skill Trees: Meaningful choices at each node. Multiple viable builds. Clear identity for each path. Synergies to discover.

Bad Skill Trees: One obviously optimal path. Nodes that are never worth taking ("trap" options). Too many small incremental bonuses ("+1% damage"). Choices that can't be understood until late-game.

The test: do different players actually choose differently? Do those choices feel meaningfully distinct?

### Platform Differences
Mobile: Often engagement-focused. Session-length progression. Daily rewards. Real-money shortcuts. Designed around interruption.

Console/PC Single-player: Experience-focused. Progression tied to authored content. Respects player time (ideally). Designed around immersion.

Crafting/Survival: Economy compounding as progression. Valheim, Satisfactory - your infrastructure IS your progression. Building capability compounds.

These aren't moral judgments - they're different design goals. But know which paradigm you're working in.

### Prestige Systems
Prestige = resetting progress to start again, usually with some persistent bonus.

Examples: Call of Duty prestige, roguelike meta-progression, New Game+.

Why it works: extends content without new content, provides long-term goals, lets players re-experience early videogame with mastery, creates visible status markers.

Danger: can feel like treadmill without meaning.

## Craft - for educators

### Teaching Notes
Progression systems are one of the most analyzed parts of videogame design because they're visible and measurable. The risk is students treating progression design as "add XP bars" rather than asking what the system is communicating.

### Exercise: Progression Audit
Pick a videogame with a progression system. Identify: what type of progression is it? What's the leveling curve? Does progression match power? Does it have skill trees? What does the system communicate about what the videogame values?

### Common Misconceptions
"More progression = more engagement." Engagement from progression is extrinsic motivation. It can substitute for - or hollow out - intrinsic motivation. A progression system can actually reduce enjoyment of the core activity.

"Progression is optional to design." Even "no progression" is a progression design choice. Knowing why you do or don't include it matters.

## Theory - deeper grounding

### Theoretical Background
Progression system design draws from behavioral psychology (Skinner's variable reward schedules, operant conditioning) and motivation theory (Deci and Ryan's self-determination theory distinguishing intrinsic vs. extrinsic motivation).

The ethical questions: when does progression design respect player time vs. exploit it? When does it support intrinsic motivation vs. undermine it?

### References
- Nick Yee - research on motivations in online games
- Deci & Ryan - Self-Determination Theory
- Jesse Schell, The Art of Game Design - lenses on progression and reward
