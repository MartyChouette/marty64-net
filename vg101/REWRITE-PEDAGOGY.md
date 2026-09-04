# PEDAGOGY PAGES - REWRITE FILE
# Instructions: Rewrite the text below however you want. Keep the headers as-is so I know where to put things. When you're done, save and tell me.
# I'll handle all the HTML, links, glossary terms, figures, and register logic. Just give me the voice.

---

# PAGE: Accessibility as Craft (accessibility-as-craft.html)

## Lead
Accessibility isn't compliance. It isn't a checklist at the end of development. It's craft - a design skill that makes videogames playable by more people without compromising vision. Treating accessibility as craft changes everything: when you consider it, how you implement it, and what you think it means.

## Practice - what you do

### The Compliance View
Conventional accessibility work looks like: subtitles, colorblind modes, remappable controls - done at the end.

This is necessary. It's not sufficient.

The compliance view treats accessibility as adding features for disabled players. It's additive, late, often underfunded.

### The Craft View
The craft view sees accessibility as design quality. Accessible videogames are well-designed videogames.

- Clear visual hierarchy: good design AND readable for low vision
- Responsive controls: good feel AND usable for motor impairments
- Multiple difficulty options: respects player time AND enables more players
- Clear audio cues: good feedback AND playable without sight

Good design is accessible design. They're not separate goals.

### Why "Craft" Not "Feature"?
A feature is bolted on. It has a scope, a budget, a checkbox.

A craft is woven through. It's a way of thinking, not a deliverable.

Calling accessibility a craft means:
- It's considered from the start
- It's everyone's responsibility (not one specialist's)
- It's ongoing (not one release milestone)
- It's skilled work (not just implementation)

### Core Accessibility Domains

Visual: Low vision, blindness, colorblindness. Is the screen readable at a glance? Does color alone convey information?

Auditory: Deafness, hard of hearing. Is audio information redundantly presented? Are subtitles good?

Motor: Limited mobility, precision, fatigue. Are controls flexible? Are time-sensitive moments adjustable?

Cognitive: Learning differences, attention, memory. Is information clearly presented? Can pace be controlled?

Every player exists on spectrums in all four domains. "Disabled" isn't a binary.

### Accessibility as Design Constraint
Constraints drive creativity. Accessibility constraints are design constraints.

"This videogame must be playable with one hand" isn't a limitation - it's a prompt. What designs emerge from that constraint?

- Celeste's assist mode emerged from thinking about who gets to finish videogames
- The Last of Us Part II's accessibility options were designed alongside core mechanics
- Hades' God Mode respects player time without removing challenge

These aren't compromises. They're design innovations.

### Common Objections (And Responses)

"Accessibility undermines artistic vision."
Does difficulty selection undermine vision? Does subtitles undermine vision? Accessibility is player options, not mandate.

"Our audience doesn't need it."
Your audience includes disabled players. 20-25% of people have some form of disability. You just don't see them because they can't play your videogame.

"We don't have the budget."
Accessibility built from the start costs less than accessibility retrofitted. The cheapest accessibility is considered design.

"Some videogames are meant to be hard."
Hard for whom? A timing-based videogame is harder for someone with motor impairments. Is that the challenge you intended? Celeste is hard AND accessible.

### Practical Accessibility Craft

Visual: Don't rely on color alone. Scalable text. High contrast option. Screen reader support for menus.

Auditory: Subtitles (good ones: speaker identification, sound effects). Visual cues for important sounds. Adjustable audio channels.

Motor: Remappable controls. Toggle vs. hold options. Adjustable timing windows. One-handed control schemes.

Cognitive: Clear objectives. Adjustable speed/pace. Save anywhere. Minimize memory load.

## Craft - for educators

### Teaching Notes
Accessibility as craft is often introduced as a social/ethical topic. It's that, but it's also a design topic. Framing it as craft keeps the conversation grounded in design decisions, not just ethics.

### How This Integrates with the Course
Accessibility isn't its own week - it's woven through everything:
- Feedback & Readability: Feedback channels as accessibility - if all feedback is audio, deaf players are excluded
- Feel Experiment: Adjust timing variables. How does changing them change who can play?
- Case studies: Analyze how Celeste and Hades handle accessibility

### Common Misconceptions
"Accessibility modes break the game for everyone else." Other players don't use modes they don't want. Celeste assist mode being there doesn't affect players who don't enable it.

"Accessibility is a specialty." Every design decision has accessibility implications. It belongs in everyone's design vocabulary.

## Theory - deeper grounding

### Theoretical Background
The curb cut effect: accessible design often benefits the general population. Curb cuts were designed for wheelchairs; they're used by strollers, delivery carts, travelers with luggage. Subtitles were designed for deaf viewers; they're widely used in loud environments and by non-native speakers.

The social model of disability vs. the medical model: medical model sees disability as the person's problem; social model sees disability as the environment's failure to accommodate. Videogame accessibility is applied social model.

### References
- Game Accessibility Guidelines (gameaccessibilityguidelines.com) - comprehensive reference
- The AbleGamers Foundation - advocacy and research
- Celeste developer commentary on assist mode design
- The Last of Us Part II accessibility talks (GDC 2021)

---

# PAGE: Code as Material (code-as-material.html)

## Lead
Code is a material. Like clay or paint, it has properties, resistances, and possibilities. Treating code as material - rather than as instruction or logic - changes how designers relate to implementation.

## Practice - what you do

### The Conventional View
In traditional education, code is treated as instruction: you tell the computer what to do, it does it. Code is a means to an end - the end being the running program.

This frames code as transparent. You think about what you want; code makes it happen. The code itself is irrelevant; only the result matters.

### The Material View
In the material view, code has its own properties - like clay, wood, or paint. You work with it, not just through it. It pushes back. It suggests possibilities. It resists certain things and enables others.

Properties - Code has inherent properties:
- It runs: Unlike a sketch, code executes. You can feel it.
- It's exact: No ambiguity. 0.5 is not "about half."
- It's repeatable: Same input, same output (usually). You can iterate precisely.
- It's modular: Pieces can be combined, separated, reused.
- It's fragile: Small changes can break everything. Syntax matters.

Resistances - Code resists certain things:
- Vagueness ("make it feel good" isn't code)
- Simultaneity (things happen in sequence, not at once)
- Continuous values (you pick a number; the material doesn't)
- Inconsistency (it does exactly what you said, even if you didn't mean it)

Possibilities - Code enables things other materials can't:
- Instant variation (change a number, see different behavior)
- Parametric design (expose values, make them tunable)
- Interactivity (the material responds to input)
- Reproduction (copy infinitely, share globally)
- Combination (stack systems on systems)

### What This Changes

Design Through Implementation: If code is material, you design through implementation, not before it. You discover possibilities by working with the material. A painter doesn't fully plan the painting before touching canvas; a designer doesn't fully plan the feel before touching code.

Prototyping as Sketching: Code prototypes are sketches in material. Rough, exploratory, meant to be thrown away. Like a sculptor's maquette, the prototype reveals what the material can do.

Feel Is Found: Gesture emerges from the code. You can imagine how a jump should feel, but the actual feel comes from gravity values, jump velocities, frame timing. The code gives you the feel; you refine it.

Parameters Are Handles: Good code exposes parameters - handles you can grab to change the behavior. The Code Bank scaffolds are designed this way: exposed variables at the top, tunable without understanding the implementation.

### The Code Bank as Material Library
The Code Bank provides pre-shaped materials. Like buying lumber instead of felling trees, or using premixed paint instead of grinding pigments.

You're not cheating by using scaffolds. You're starting with refined material so you can focus on design decisions, not implementation details.

Use scaffolds to:
- Get something running fast
- Feel the behavior before deciding if it's right
- Tune parameters to find the feel you want
- Learn by reading working code

### Knowing vs. Feeling
Knowing what you want is not the same as feeling it.

"I want a floaty jump" is knowledge. The actual floaty jump - the gravity, the hang time, the landing - is feel. Code makes the jump real. Then you react to the real thing.

This is why prototyping matters. You don't know if your idea works until you feel it in material form.

## Craft - for educators

### Teaching Notes
This framing helps students who feel like "they're not programmers" embrace code as part of their design practice. The alternative - waiting for an engineer to implement your ideas - is a real limitation that this mindset can address.

### Exercise: Parameter Exploration
Take any Code Bank scaffold. Expose one parameter (e.g., gravity). Set it to five different values. For each, play for 30 seconds and describe: what does this feel like? What genre of videogame would use this? What does this value say about the world?

Don't explain the code. Just describe what it produces.

### Common Misconceptions
"Code is just implementation." Code is design. The specific way something is implemented shapes what it can become. A jump built with one approach has different design possibilities than the same jump built differently.

"I'll learn to code later." The code-as-material perspective says: you need to touch the material to design with it. Prototyping is designing.

## Theory - deeper grounding

### Theoretical Background
The "code as material" framing draws from: craft traditions (material properties shaping what's possible), phenomenology (experiencing tools as extensions of the body), and design research (especially prototyping as a thinking tool, not just a verification tool).

Donald Schön's "reflection-in-action" - practitioners learn by doing, not just by planning. The material talks back. Code talking back is a feature, not a bug.

### References
- Seymour Papert - Mindstorms (learning through building/making)
- Donald Schön - The Reflective Practitioner
- Bret Victor - "Learnable Programming" and related essays on direct manipulation

---

# PAGE: Debugging as Literacy (debugging-as-literacy.html)

## Lead
Debugging isn't just fixing code. It's a mode of thinking - a literacy in the root sense: the ability to read, understand, and respond to systems. Treating debugging as literacy changes how we teach code in videogame design.

## Practice - what you do

### The Conventional View
In CS education, debugging is remediation. You wrote a bug; now fix it. Debugging is failure recovery.

This framing makes debugging shameful. Students hide their bugs. They feel dumb when code doesn't work.

### The Literacy View
Debugging is reading. When code breaks, you read what it's actually doing (vs. what you intended). That reading skill transfers: you can read code you didn't write, read systems you didn't design, read behavior you didn't expect.

Debugging is inquiry. "Why doesn't this work?" is a research question. You form hypotheses, test them, revise. This is scientific thinking applied to systems.

Debugging is craft. Every craft has failure. Potters have collapsed pots. Writers have bad drafts. Debugging is normal, not shameful.

### Why This Matters for Videogame Design
Videogame designers who can't debug are dependent on engineers. They can't prototype. They can't tweak feel. They can't understand why their design isn't working.

Videogame designers who can debug have:
- Prototyping independence: Build rough versions without waiting for engineers
- Feel intuition: Tweak values, see results, iterate fast
- System literacy: Understand how videogame systems actually work
- Communication ability: Talk to engineers in their language

You don't need to be a great programmer. You need to be a competent debugger.

### Teaching Debugging

Normalize Failure: Code not working isn't failure - it's the normal state. Nobody writes perfect code first try. Professional developers spend most of their time debugging.

Read Before Fix: Before changing anything, understand what's happening. Read the error message. Read the code. Articulate (in words) what you think is wrong.

One Change at a Time: Change one thing, test, repeat. If you change five things and it works, you don't know which change fixed it.

Print Statements Are Your Friend: The simplest debugging tool: print the value. See what's actually happening, not what you think is happening.

Rubber Duck Debugging: Explain the code to someone (or something). The act of articulating often reveals the bug.

Use the Error Message: Error messages tell you something. Read them. They're not random noise.

### The Code Bank and Debugging
The Code Bank scaffolds are designed for reading and modification, not just execution.

When a scaffold doesn't produce the feel you want:
1. Read the scaffold code
2. Identify which variable controls the aspect you want to change
3. Hypothesize what changing it will do
4. Test by changing and running
5. Iterate until it feels right

This is debugging as design process.

### Debugging Without Coding
The debugging mindset applies beyond code:

Debugging a design: Something doesn't work. Why? Form hypothesis. Test. Revise.

Debugging feedback: Playtesters report frustration. Where? Why? What's the root cause?

Debugging communication: Message isn't landing. What's being misunderstood? Where's the gap?

The skill transfers. Learning to debug code teaches you to debug everything.

## Craft - for educators

### Teaching Notes
The biggest obstacle is shame. Students who think debugging means they failed will hide their bugs, avoid experimenting, and lose the most valuable part of the learning process.

Normalize debugging from day one. Show your own debugging process in front of the class. Get stuck. Work through it out loud.

### Exercise: Intentional Bugs
Give students working code. Ask them to break it five different ways (change a variable, delete a line, comment something out). For each break: what happened? Why? Then fix it.

The goal: debugging should feel exploratory, not panicked.

### Common Misconceptions
"Good programmers don't have bugs." The opposite is true - experienced programmers debug constantly. The skill is debugging faster and more effectively.

"I should figure it out myself before asking." Rubber duck debugging is legitimate. Explaining your code to someone, even someone who can't help, is a real technique.

## Theory - deeper grounding

### Theoretical Background
Debugging as literacy connects to several educational frameworks: computational thinking (decomposition, pattern recognition, abstraction), scientific method (hypothesis, test, revise), and metaliteracy (understanding not just how to use tools, but how they work).

The shame around debugging is cultural, not inherent. Some programming communities treat debugging as the main activity, not a corrective one.

### References
- Seymour Papert - the importance of debugging in constructionist learning
- "The Art of Debugging" by Agans - systematic debugging techniques
- Mindset research (Carol Dweck) - growth mindset applied to technical failure

---

# PAGE: Play → Name → Make → Reflect (play-name-make-reflect.html)

## Lead
The weekly rhythm of VG101 - and our core pedagogical method. Learning videogame design isn't about reading theory first. It's about feeling, then naming, then making, then understanding.

## Practice - what you do

### The Sequence

Play: Experience videogames firsthand. Not analyzing yet - just playing. Letting the videogame affect you.

What students do: Play assigned videogames with journaling prompts. Notice what they feel. Don't explain yet.

Name: Give vocabulary to the experience. "That feeling when you dash" becomes "the dash gesture." "Where did that mechanic come from?" becomes "aesthetic heritage."

What students do: Learn concepts that name what they've already felt. Discuss. Make connections.

Make: Create something that embodies the concept. Not just talk about gestures - build one. Use the Code Bank scaffolds.

What students do: Small, focused making exercises. Recreation, modification, original work.

Reflect: Step back and understand. What did you make? Why did it work or not? How does this change how you see videogames?

What students do: Written reflection, critique sessions, connecting to larger ideas. Then repeat.

### Why This Order?
The conventional order - theory first, application second - doesn't work for videogame design.

Conventional: Read about jumping → learn "game feel" vocabulary → try to implement jump → grade the implementation.

Play → Name → Make → Reflect: Jump in a videogame, feel it → give name to what you felt → build a jump that matches the feeling → reflect on what you learned.

The problem with theory-first: students learn words without referents. "Ludonarrative dissonance" means nothing until you've felt the dissonance.

### Play: What Counts?
"Play" isn't just passing time with videogames. It's active, attentive engagement.

Good playing:
- Playing with a question in mind ("What makes this jump feel good?")
- Journaling while or after playing
- Playing something unfamiliar (not just comfort videogames)
- Playing critically (noticing choices, not just reacting)

Less useful playing:
- Mindless grinding
- Checking phone while playing
- Only playing what you already know

The assignment matters: what question are students taking into play?

### Name: Vocabulary That Fits
Naming should feel like relief, not burden.

If we've shown students Celeste and had them write about the dash, then we introduce "gesture" - they should think "oh, that's what that was!"

If they're confused by "gesture," we introduced it too early. They needed more play.

Naming principles:
- Name what they've experienced
- Use terms that help, not impress
- Let naming emerge from discussion, not just lecture
- Connect new names to old names

### Make: Constrained Creating
Making should be scoped and focused, not open-ended.

"Make a videogame" is paralyzing.

"Recreate the Celeste dash using the dash scaffold in 30 minutes" is actionable.

Good making prompts:
- Clear scope (one gesture, one system, one level)
- Available tools (Code Bank scaffolds, not raw engine)
- Time limit (forces prioritization)
- Evaluable criteria (what does "done" mean?)

The constraint is the gift. Freedom overwhelms; constraint enables.

### Reflect: Closing the Loop
Reflection is where learning consolidates. Without it, students do but don't understand.

Reflection prompts:
- "What surprised you in the making process?"
- "How is what you made different from what you planned?"
- "What would you do differently?"
- "How does this change how you see the original videogame?"

Written reflection is valuable, but so is critique: presenting work and receiving feedback.

## Craft - for educators

### Teaching Notes
The rhythm is not optional structure. Students trained in lecture-first education sometimes resist playing before reading. They want to "know the answer" before engaging. The rhythm requires unlearning that expectation.

### Assessment Alignment
If the rhythm is play → name → make → reflect, assessment should match. Assess reflection and making, not vocabulary recall.

A student who can write about what they made and what they learned demonstrates more understanding than a student who can define "gesture" on a quiz.

### Common Pitfalls

"Play" becomes passive consumption: Without journaling prompts or questions, "play" can become just playing. Give students something to attend to.

"Name" becomes lecture: Naming works best as dialogue, not delivery. Ask students what they noticed, then provide vocabulary for what they're describing.

"Make" becomes overwhelming: Scope aggressively. A 30-minute constraint is better than a week-long project. Small wins build confidence.

"Reflect" gets skipped: When time is short, reflection goes first. Resist this. Reflection is where learning consolidates. Build it into class time.

## Theory - deeper grounding

### Theoretical Background
John Dewey: Learning by doing. Experience precedes abstraction. The philosophical backbone of this approach.

Donald Schön: The Reflective Practitioner. Reflection-in-action and reflection-on-action. Professionals learn by reflecting on what they do.

Kolb's Experiential Learning Cycle: Concrete experience → reflective observation → abstract conceptualization → active experimentation. The Play → Name → Make → Reflect sequence is a version of this cycle adapted for videogame design education.

### References
- John Dewey - Experience and Education
- Donald Schön - The Reflective Practitioner
- David Kolb - Experiential Learning
- Seymour Papert - constructionism and learning through making
