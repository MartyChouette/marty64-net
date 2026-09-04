"""
Generate four role-specific PDF resumes for marty64.net/resumes/
Run: python build_resumes.py
"""

from fpdf import FPDF
import os

OUT_DIR = os.path.dirname(os.path.abspath(__file__))


class ResumePDF(FPDF):
    def __init__(self):
        super().__init__()
        self.set_auto_page_break(auto=True, margin=15)
        self.add_page()
        self.set_margins(18, 15, 18)
        self.set_y(15)

    def header_block(self):
        self.set_font("Helvetica", "B", 20)
        self.cell(0, 8, "MARTY SCOTT", align="C", new_x="LMARGIN", new_y="NEXT")
        self.set_font("Helvetica", "", 9)
        self.cell(0, 5, "(they/them)", align="C", new_x="LMARGIN", new_y="NEXT")
        self.set_font("Helvetica", "", 9)
        self.cell(
            0, 5,
            "Brooklyn, NY  |  909.456.0467  |  greatmartyscott@gmail.com",
            align="C", new_x="LMARGIN", new_y="NEXT",
        )
        self.cell(
            0, 5,
            "marty64.net  |  github.com/martychouette  |  martychouette.itch.io",
            align="C", new_x="LMARGIN", new_y="NEXT",
        )
        self.ln(3)

    def section_heading(self, text):
        self.set_font("Helvetica", "B", 11)
        self.set_text_color(51, 51, 51)
        self.cell(0, 7, text.upper(), new_x="LMARGIN", new_y="NEXT")
        self.set_draw_color(180, 180, 180)
        self.line(self.l_margin, self.get_y(), self.w - self.r_margin, self.get_y())
        self.ln(3)
        self.set_text_color(0, 0, 0)

    def role_header(self, title, detail=""):
        self.set_font("Helvetica", "B", 10)
        if detail:
            self.cell(self.get_string_width(title) + 2, 6, title)
            self.set_font("Helvetica", "", 9)
            self.set_text_color(85, 85, 85)
            self.cell(0, 6, f"  |  {detail}", new_x="LMARGIN", new_y="NEXT")
            self.set_text_color(0, 0, 0)
        else:
            self.cell(0, 6, title, new_x="LMARGIN", new_y="NEXT")
        self.ln(1)

    def bullet(self, text):
        self.set_font("Helvetica", "", 9.5)
        x = self.l_margin + 5
        self.set_x(x)
        self.cell(4, 5, "-")
        self.set_x(x + 5)
        self.multi_cell(self.w - self.r_margin - x - 5, 5, text)
        self.ln(0.5)

    def skills_line(self, label, detail):
        self.set_font("Helvetica", "B", 9.5)
        self.cell(self.get_string_width(label + ": ") + 1, 5, label + ": ")
        self.set_font("Helvetica", "", 9.5)
        self.multi_cell(0, 5, detail)
        self.ln(0.5)

    def edu_line(self, school, degree):
        self.set_font("Helvetica", "B", 10)
        self.cell(self.get_string_width(school + " - ") + 1, 5, school + " - ")
        self.set_font("Helvetica", "", 10)
        self.cell(0, 5, degree, new_x="LMARGIN", new_y="NEXT")
        self.ln(1)

    def summary(self, text):
        self.set_font("Helvetica", "", 9.5)
        self.multi_cell(0, 5, text)
        self.ln(2)


# ============================================================
# SHARED DATA
# ============================================================

EDUCATION = [
    ("NYU (Tisch)", "MFA, Game Design (Game Center) | 2024 - 2026"),
    ("Cal Poly Pomona", "BS, Computer Science | 2021 - 2023"),
    ("Mt. San Antonio College", "AA/AS, Database Management & Programming | 2018 - 2021"),
    ("Musicians Institute", "AA, Piano Tech (Audio Engineering emphasis) | 2009 - 2011"),
]


def add_education(pdf):
    pdf.section_heading("Education")
    for school, degree in EDUCATION:
        pdf.edu_line(school, degree)


# ============================================================
# 1. TEACHING RESUME
# ============================================================
def build_teaching():
    pdf = ResumePDF()
    pdf.header_block()

    pdf.summary(
        "A computer scientist and game designer who treats code as creative material. "
        "I build interactive systems that explore what code can express - sightless platformers "
        "navigated by sound, autobiographical physics games, and an aesthetic-first game engine "
        "in C++/Vulkan. I develop open pedagogical frameworks for teaching code to non-programmers "
        "through making, with accessibility and craft at the center of everything I teach."
    )

    pdf.section_heading("Skills")
    pdf.skills_line("Pedagogy", "Curriculum design, scaffolded instruction, studio-based teaching, accessibility-centered design")
    pdf.skills_line("Languages", "C#, C++, Python, JavaScript, Java, SQL")
    pdf.skills_line("Engines / Tools", "Unity, Unreal, GameMaker, p5.js, Processing")
    pdf.skills_line("Game Design", "Rapid prototyping, play-testing, iterative design, system balancing")
    pdf.skills_line("Audio", "FMOD, Pro Tools, Logic, Ableton (15+ years)")

    pdf.section_heading("Teaching Experience")

    pdf.role_header("NYU Game Center (Tisch) - Code Help Desk", "2025 - Present")
    pdf.bullet("Help BFA and MFA students with code issues across Unity, Unreal, Processing, Twine, and GameMaker")
    pdf.bullet("Walk students through technical problems in plain language so they can get back to making")
    pdf.bullet("Document recurring fixes for the desk")

    pdf.role_header("NYU Game Center Conference - Speaker", "2025")
    pdf.bullet("Presented on game design pedagogy and accessibility")

    pdf.role_header("Music & Arts - Music Teacher", "2012 - 2018")
    pdf.bullet("Taught piano, guitar, and sound production across age groups and skill levels")
    pdf.bullet("Six years of one-on-one and small group instruction")

    pdf.section_heading("Pedagogical Work")

    pdf.role_header("VG101 Knowledge Base", "marty64.net/vg101 | In Development")
    pdf.bullet("Open pedagogical text for teaching videogame design as its own medium, built on a Gesture + Aesthetic Heritage framework")
    pdf.bullet('Core pages: "Code as Material" (Schon, Papert, Sennett), "Debugging as Literacy," "Accessibility as Craft"')
    pdf.bullet("Teaching cycle: Play - Name - Make - Reflect, grounded in Dewey and Kolb")
    pdf.bullet("Three-register system (Practice / Craft / Theory) for layered reading across student and educator audiences")
    pdf.bullet("Code Bank: pre-shaped scaffolds students tune before they write, with exposed parameters for exploration")

    pdf.section_heading("Selected Projects")

    pdf.role_header("Blackout", "Solo Developer | Unity, FMOD")
    pdf.bullet("Sightless 2D platformer built around auditory navigation with no visual cues")
    pdf.bullet("Published research whitepaper on designing for blind play")
    pdf.bullet("Directly engages software and disability as a design question, not a compliance checkbox")

    pdf.role_header("Prototype Studio Gallery", "11 Weekly Prototypes | Unity")
    pdf.bullet("One prototype per week, each exploring a different question through code")
    pdf.bullet("Text adventures, physics toys, 3D environments, naval strategy, emotional vignettes")

    pdf.role_header("Cold Flame", "Solo Developer | Unity")
    pdf.bullet("Autobiographical physics game about life, loss, and chopping wood; code as personal expression")

    pdf.role_header("TEGE - The Enjin Game Engine", "Solo Developer | C++20, Vulkan")
    pdf.bullet("Aesthetic-first open source game engine with a complete editor, 70+ ECS components, and AngelScript scripting")
    pdf.bullet("Built a comprehensive accessibility suite: 8 colorblind modes, screen reader support, switch access, dyslexia mode")
    pdf.bullet("Licensed BSL 1.1 with full documentation and installer")

    add_education(pdf)

    pdf.output(os.path.join(OUT_DIR, "marty-scott-teaching.pdf"))
    print("Built: marty-scott-teaching.pdf")


# ============================================================
# 2. PROGRAMMING RESUME
# ============================================================
def build_programming():
    pdf = ResumePDF()
    pdf.header_block()

    pdf.summary(
        "A software engineer and game designer with a CS degree and an MFA from NYU. "
        "I build game engines, gameplay systems, and tools from the ground up - from a "
        "100k+ line Vulkan engine with ray tracing and accessibility features, to narrative "
        "state machines and physics-driven interactions in Unity and Unreal. I care about "
        "code that feels good to use, looks right on screen, and ships."
    )

    pdf.section_heading("Skills")
    pdf.skills_line("Languages", "C#, C++, Java, Python, JavaScript, SQL, Custom Scripting")
    pdf.skills_line("Engines / Tools", "Unity, Unreal, GameMaker, TEGE (open source, BSL 1.1)")
    pdf.skills_line("Engine Development", "C++20, Vulkan, ECS architecture, visual scripting, shader authoring")
    pdf.skills_line("Gameplay Systems", "Encounters, interactive objects, narrative scripting, state machines, behavior trees, combat systems, 3D math")
    pdf.skills_line("Web Development", "Next.js, React, HTML/CSS, SEO")
    pdf.skills_line("Creative Coding", "p5.js, Processing")
    pdf.skills_line("Design Tools", "Blender, Photoshop")
    pdf.skills_line("Audio Integration", "FMOD, Pro Tools, Logic, Ableton")

    pdf.section_heading("Experience")

    pdf.role_header("NYU Game Center (Tisch) - Code Help Desk", "2025 - Present")
    pdf.bullet("Help BFA and MFA students debug and fix projects across Unity, Unreal, Processing, and GameMaker")
    pdf.bullet("Troubleshoot broken workflows and translate fixes into clear next steps")

    pdf.role_header("NYU Game Center - Studio Game Director & Producer", "Spring 2025")
    pdf.bullet("Led day-to-day production for a multidisciplinary game team from prototype through milestone builds")
    pdf.bullet("Coordinated playtests, translated findings into prioritized next steps, kept scope aligned with deadlines")
    pdf.bullet("Managed build stability, presentation flow, and last-mile polish for demo readiness")

    pdf.role_header("Custom Construction Website - Designer & Programmer", "2024")
    pdf.bullet("Built a company website with editable content tools and improved SEO")

    pdf.section_heading("Projects")

    pdf.role_header("TEGE - The Enjin Game Engine", "Solo Developer | C++20, Vulkan")
    pdf.bullet("Architected and shipped a 100k+ line aesthetic-first game engine with a complete ImGui editor, 70+ ECS components, and build pipeline")
    pdf.bullet("Implemented a Vulkan PBR renderer with cascaded shadow maps, clustered forward lighting, GPU occlusion culling, and full hardware ray tracing")
    pdf.bullet("Integrated dual physics backends (Jolt 5.2.0, Box2D 3.0.0), AngelScript scripting (721 bindings), and blueprint-style visual scripting with 146+ nodes")
    pdf.bullet("Built a 30+ effect post-processing stack, retro rendering modes (PSX, Dreamcast), and 44 starter templates")
    pdf.bullet("Developed accessibility suite: 8 colorblind corrections, remappable input, screen reader, switch access, dwell-click, dyslexia mode")
    pdf.bullet("Published under BSL 1.1 with full documentation, installer, and standalone game player")

    pdf.role_header("RhodesTrip", "Producer / Designer / Programmer / Audio | Unity, FMOD, Ink, Blender")
    pdf.bullet("Built narrative state machine, cameras, vehicle controls for a third-person driving + exploration game")
    pdf.bullet("Owned prototype slice, iteration based on playtests, cross-discipline coordination (team of 4)")

    pdf.role_header("IRIS (In-Progress)", "Solo Developer | Unity")
    pdf.bullet("Third-person environmental exploration with physics-based flower trimming and arranging")
    pdf.bullet("Prototyped tactile interactions; iterated on feel and reliability")

    pdf.role_header("Blackout", "Solo Developer | Unity, FMOD")
    pdf.bullet("Sightless 2D platformer: audio-driven feedback, navigation cues, mix logic, accessibility hooks, debug tools")
    pdf.bullet("Published research whitepaper on designing for blind play")

    pdf.role_header("Cold Flame", "Solo Developer | Unity")
    pdf.bullet("Autobiographical physics game; 9-minute experience using physics mechanics as emotional metaphor")

    pdf.role_header("Purrfect Pizza VR", "Design / Music / Audio Programming (Team of 6) | Unity, VR Toolkit, Logic")
    pdf.bullet("VR game gamifying formal language constructs through pizza-making for cat bosses")

    pdf.role_header("Prototype Studio Gallery", "11 Weekly Prototypes | Unity")
    pdf.bullet("One per week; text adventures, physics toys, 3D environments, naval strategy, abstract interactions")

    add_education(pdf)

    pdf.output(os.path.join(OUT_DIR, "marty-scott-programming.pdf"))
    print("Built: marty-scott-programming.pdf")


# ============================================================
# 3. GAME DEVELOPMENT RESUME
# ============================================================
def build_game_dev():
    pdf = ResumePDF()
    pdf.header_block()

    pdf.summary(
        "A game designer and programmer who works where narrative meets mechanics and "
        "aesthetics meet systems. I prototype early, iterate on feel, and build end-to-end - "
        "from encounter logic and narrative state machines to camera systems and audio-driven "
        "accessibility. I also built an aesthetic-first game engine in C++/Vulkan. "
        "15+ years of audio makes me sensitive to timing and what a moment reads like."
    )

    pdf.section_heading("Skills")
    pdf.skills_line("Game Design", "Greyboxing, rapid prototyping, play-testing, iterative design, system balancing, tuning")
    pdf.skills_line("Gameplay Systems", "Encounters, interactive objects, narrative scripting, state machines, behavior trees, combat systems, 3D math")
    pdf.skills_line("Languages", "C#, C++, Python, JavaScript, Java, SQL")
    pdf.skills_line("Engines / Tools", "Unity, Unreal, GameMaker, TEGE (open source, BSL 1.1)")
    pdf.skills_line("Engine Development", "C++20, Vulkan, ECS architecture, visual scripting, shader authoring")
    pdf.skills_line("Audio", "FMOD, Pro Tools, Logic, Ableton (15+ years)")

    pdf.section_heading("Experience")

    pdf.role_header("NYU Game Center - Studio Game Director & Producer", "Spring 2025")
    pdf.bullet("Led production for a multidisciplinary game team, owning schedules and task tracking from prototype through milestone builds")
    pdf.bullet("Coordinated playtests and feedback capture, translated findings into prioritized next steps")
    pdf.bullet("Served as communication hub across design, engineering, art, and audio")
    pdf.bullet("Managed demo readiness: build stability, presentation flow, last-mile polish")

    pdf.role_header("NYU Game Center (Tisch) - Code Help Desk", "2025 - Present")
    pdf.bullet("Help BFA and MFA students with code issues across Unity, Unreal, Processing, and GameMaker")
    pdf.bullet("Troubleshoot broken projects and walk students through fixes")

    pdf.role_header("NYU Game Center Conference - Speaker", "2025")
    pdf.bullet("Presented on game design pedagogy and accessibility")

    pdf.section_heading("Projects")

    pdf.role_header("RhodesTrip", "Producer / Designer / Programmer / Audio | Unity, FMOD, Ink, Blender")
    pdf.bullet("Third-person driving + exploration with conversation and puzzle elements (team of 4)")
    pdf.bullet("Built narrative state machine, cameras, vehicle controls")
    pdf.bullet("Designed encounters, composed music, coordinated cross-discipline team")
    pdf.bullet("Owned prototype slice, iterated based on playtests")

    pdf.role_header("IRIS (In-Progress)", "Solo Developer | Unity")
    pdf.bullet("Third-person environmental exploration with physics-based flower trimming and arranging")
    pdf.bullet("Prototyped tactile interactions; iterated on feel and reliability")

    pdf.role_header("Blackout", "Solo Developer | Unity, FMOD")
    pdf.bullet("Sightless 2D platformer built around auditory navigation with no visual cues")
    pdf.bullet("Designed audio-driven feedback and progression: navigation cues, mix logic, accessibility hooks")
    pdf.bullet("Published research whitepaper on designing for blind play")

    pdf.role_header("Cold Flame", "Solo Developer | Unity")
    pdf.bullet("Autobiographical physics game about life, loss, and chopping wood")
    pdf.bullet("9-minute experience with voiceover, using physics mechanics as emotional metaphor")

    pdf.role_header("TEGE - The Enjin Game Engine", "Solo Developer | C++20, Vulkan")
    pdf.bullet("Designed, directed, and shipped an aesthetic-first open source game engine with a complete editor, 70+ ECS components, dual physics backends (Jolt/Box2D), and AngelScript scripting with 721 bindings")
    pdf.bullet("Full ray tracing pipeline, 30+ post-processing effects, retro rendering modes, and 44 starter templates")
    pdf.bullet("Accessibility suite with 8 colorblind modes, screen reader support, switch access, and motor accessibility")

    pdf.role_header("Purrfect Pizza VR", "Design / Music / Audio Programming (Team of 6) | Unity, VR Toolkit, Logic")
    pdf.bullet("VR game gamifying formal language constructs through pizza-making for cat bosses")

    pdf.role_header("Prototype Studio Gallery", "11 Weekly Prototypes | Unity")
    pdf.bullet("One per week; text adventures, physics toys, 3D environments, naval strategy, emotional vignettes")

    add_education(pdf)

    pdf.output(os.path.join(OUT_DIR, "marty-scott-game-development.pdf"))
    print("Built: marty-scott-game-development.pdf")


# ============================================================
# 4. COMBINED RESUME
# ============================================================
def build_combined():
    pdf = ResumePDF()
    pdf.header_block()

    pdf.summary(
        "A game designer, programmer, and educator with a CS degree and an MFA in Game Design "
        "from NYU. I build playable prototypes where narrative and mechanics meet, write "
        "aesthetic-first game engines, design for accessibility from the start, and teach code "
        "as creative material. 15+ years of audio across music, podcasts, and game audio."
    )

    pdf.section_heading("Skills")
    pdf.skills_line("Languages", "C#, C++, Java, Python, JavaScript, SQL")
    pdf.skills_line("Engines / Tools", "Unity, Unreal, GameMaker, TEGE (open source, BSL 1.1)")
    pdf.skills_line("Engine Development", "C++20, Vulkan, ECS architecture, visual scripting, shader authoring")
    pdf.skills_line("Game Design", "Greyboxing, rapid prototyping, play-testing, iterative design, system balancing")
    pdf.skills_line("Gameplay Systems", "Encounters, interactive objects, narrative scripting, state machines, behavior trees, 3D math")
    pdf.skills_line("Pedagogy", "Curriculum design, scaffolded instruction, studio-based teaching, accessibility-centered design")
    pdf.skills_line("Audio", "FMOD, Pro Tools, Logic, Ableton (15+ years)")
    pdf.skills_line("Video / Design", "Premiere Pro, Photoshop - editing, thumbnails, social assets")
    pdf.skills_line("Operations", "Scheduling, outreach, event logistics, documentation, Discord community management")

    pdf.section_heading("Experience")

    pdf.role_header("NYU Game Center (Tisch) - Code Help Desk", "2025 - Present")
    pdf.bullet("Help BFA and MFA students with code issues across Unity, Unreal, Processing, and GameMaker")
    pdf.bullet("Troubleshoot broken projects and walk students through fixes")

    pdf.role_header("NYU Game Center - Studio Game Director & Producer", "Spring 2025")
    pdf.bullet("Led production for a multidisciplinary game team from prototype through milestone builds")
    pdf.bullet("Coordinated playtests, managed build stability, and kept scope aligned with deadlines")

    pdf.role_header("NYU Game Center Conference - Speaker", "2025")
    pdf.bullet("Presented on game design pedagogy and accessibility")

    pdf.role_header("Fib Likley (YouTube) - Creator & Editor", "2019 - Present")
    pdf.bullet("Gameplay-driven videos with clear hooks, clean structure, and tight pacing")

    pdf.role_header("The Palisades - Recording Studio Manager & Operations", "2013 - 2019")
    pdf.bullet("Coordinated scheduling for 50+ bands, managed 200+ podcast sessions")
    pdf.bullet("Produced monthly public events, managed on-site logistics and vendor coordination")

    pdf.role_header("Music & Arts - Music Teacher", "2012 - 2018")
    pdf.bullet("Taught piano, guitar, and sound production to students across age groups and skill levels")

    pdf.section_heading("Projects")

    pdf.role_header("TEGE - The Enjin Game Engine", "Solo Developer | C++20, Vulkan")
    pdf.bullet("Solo-developed an aesthetic-first open source game engine featuring 70+ ECS components, a full ImGui editor, ray tracing pipeline, and comprehensive accessibility suite. BSL 1.1")

    pdf.role_header("RhodesTrip", "Producer / Designer / Programmer / Audio | Unity, FMOD, Ink, Blender")
    pdf.bullet("Third-person driving + exploration; narrative state machine, cameras, vehicle controls (team of 4)")

    pdf.role_header("Blackout", "Solo Developer | Unity, FMOD")
    pdf.bullet("Sightless 2D platformer with audio-driven navigation; published research whitepaper")

    pdf.role_header("IRIS (In-Progress)", "Solo Developer | Unity")
    pdf.bullet("Physics-based environmental exploration; prototyping tactile interactions")

    pdf.role_header("Cold Flame", "Solo Developer | Unity")
    pdf.bullet("Autobiographical physics game; code as personal expression")

    pdf.section_heading("Pedagogical Work")
    pdf.role_header("VG101 Knowledge Base", "marty64.net/vg101 | In Development")
    pdf.bullet("Open text for teaching videogame design as its own medium (Gesture + Aesthetic Heritage framework)")
    pdf.bullet("Teaching cycle: Play - Name - Make - Reflect; three-register system for layered reading")

    add_education(pdf)

    pdf.output(os.path.join(OUT_DIR, "marty-scott-combined.pdf"))
    print("Built: marty-scott-combined.pdf")


# ============================================================
if __name__ == "__main__":
    build_teaching()
    build_programming()
    build_game_dev()
    build_combined()
    print("\nAll resumes generated.")
