// Layout and styling for the CV. Data lives in cv.yaml; entry point is cv.typ.

#let muted = luma(90)
#let ink = luma(35) // section headings: darker than muted details, softer than body text
#let sans = "Inter"
#let serif = "Source Serif 4"

// Render a YAML string as Typst markup so data can carry *bold*, _italic_, links.
#let md(s) = eval(str(s), mode: "markup")

// Section heading: letter-spaced small caps (Source Serif 4 has true small caps; Inter doesn't).
#let section(title) = block(above: 20pt, below: 10pt,
  text(font: serif, size: 11.5pt, weight: "semibold", tracking: 0.06em, fill: ink, smallcaps(all: true, title)))

#let dates(start, end) = [#start -- #end]

// Two-row entry: bold heading + right-aligned dates, then italic subtitle + location.
#let entry(heading, subtitle, location, start, end, body: none) = {
  block(breakable: false, below: 8pt)[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      row-gutter: 4pt,
      text(font: sans, weight: "semibold", heading), text(font: sans, size: 8.5pt, fill: muted, dates(start, end)),
      emph(subtitle), text(font: sans, size: 8.5pt, fill: muted, location),
    )
    #if body != none { body }
  ]
}

#let header(cv) = {
  let c = cv.at("contact", default: (:))
  // Two rows: direct contact, then profiles. box() keeps each item from breaking mid-URL.
  let direct = ()
  if "email" in c { direct.push(link("mailto:" + c.email, c.email)) }
  if "phone" in c { direct.push(c.phone) }
  if "location" in c { direct.push(c.location) }
  if "website" in c { direct.push(link("https://" + c.website, c.website)) }
  let profiles = ()
  if "github" in c { profiles.push(link("https://github.com/" + c.github, "github.com/" + c.github)) }
  if "linkedin" in c { profiles.push(link("https://linkedin.com/in/" + c.linkedin, "linkedin.com/in/" + c.linkedin)) }
  if "x" in c { profiles.push(link("https://x.com/" + c.x, "x.com/" + c.x)) }
  let row(items) = items.map(box).join([ #sym.bullet ])

  set par(justify: false)
  align(center)[
    #block(below: 7pt, text(font: sans, size: 24pt, weight: "semibold", tracking: -0.01em, top-edge: "cap-height", cv.name))
    #if "title" in cv { block(below: 9pt, text(font: sans, size: 11pt, fill: muted, cv.title)) }
    #set text(font: sans, size: 8.5pt, fill: muted)
    #set par(leading: 0.6em)
    #(row(direct), row(profiles)).filter(r => r != none).join(linebreak())
  ]
}

#let render(cv) = {
  set document(title: cv.name + " – CV", author: cv.name)
  set page(paper: "a4", margin: (x: 1.8cm, y: 1.6cm))
  set text(font: serif, size: 10pt, lang: "en")
  set par(justify: true, leading: 0.55em)
  set list(indent: 4pt, body-indent: 5pt, spacing: 4pt)

  header(cv)
  // Underline links in the body only; header contacts are self-evidently links.
  show link: underline.with(stroke: 0.4pt + luma(160), offset: 2pt)

  if "summary" in cv {
    section("Summary")
    md(cv.summary)
  }

  if "experience" in cv {
    section("Experience")
    for job in cv.experience {
      entry(
        job.role, job.company, job.at("location", default: ""), job.start, job.end,
        body: if "highlights" in job { list(..job.highlights.map(md)) },
      )
    }
  }

  if "education" in cv {
    section("Education")
    for edu in cv.education {
      entry(
        edu.degree, edu.institution, edu.at("location", default: ""), edu.start, edu.end,
        body: if "details" in edu { md(edu.details) },
      )
    }
  }

  if "skills" in cv {
    section("Skills")
    grid(
      columns: (auto, 1fr),
      column-gutter: 12pt,
      row-gutter: 6pt,
      ..cv.skills.map(s => (text(weight: "bold", s.category), s.items.join(", "))).flatten(),
    )
  }

  if "projects" in cv {
    section("Projects")
    for p in cv.projects {
      block(below: 6pt)[
        #text(weight: "bold", if "url" in p { link(p.url, p.name) } else { p.name })
        #sym.dash.em #md(p.description)
      ]
    }
  }

  if "languages" in cv {
    section("Languages")
    cv.languages.map(l => [*#l.name* (#l.level)]).join([, ])
  }
}
