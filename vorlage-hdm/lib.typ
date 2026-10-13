#import "@preview/glossarium:0.5.9": make-glossary, register-glossary, print-glossary, gls, glspl

#import "content/titlepage.typ": titlepage
#import "content/declaration-of-authorship.typ": declaration-of-authorship-page

// Liest einen YAML-Wert als Typst-Länge. Strings wie "12pt" werden ausgewertet,
// none fällt auf den Standard zurück, alles andere bleibt, wie es ist.
#let as-length(value, fallback) = {
    if type(value) == str {
        eval(value, mode: "code")
    } else if value == none {
        fallback
    } else {
        value
    }
}

// Dasselbe für Ganzzahlen, etwa die Seite, ab der die Kopfzeile beginnt.
#let as-int(value, fallback) = {
    if type(value) == str {
        int(value)
    } else if value == none {
        fallback
    } else {
        value
    }
}

// Sammelt alle einstellbaren Layout-Werte aus metadata.layout in einem
// Dictionary und ergänzt Standardwerte. Das hält die Vorlage selbst frei
// vom Parsing-Kleinkram.
#let resolve-layout(layout) = {
    let pageCfg = layout.at("page", default: (:))
    let typeCfg = layout.at("typography", default: (:))
    let sizes = typeCfg.at("heading-sizes", default: (:))
    let alignments = (left: left, center: center, right: right)

    (
        body: (
            size: as-length(typeCfg.at("body-size", default: 11pt), 11pt),
            leading: as-length(typeCfg.at("body-leading", default: 1.2em), 1.2em),
            spacing: as-length(typeCfg.at("body-spacing", default: 1.8em), 1.8em),
            caption-align: alignments.at(
                typeCfg.at("caption-align", default: "left"), default: left),
        ),
        heading: (
            leading: as-length(typeCfg.at("heading-leading", default: 0.5em), 0.5em),
            above: as-length(typeCfg.at("heading-above", default: 1.8em), 1.8em),
            below: as-length(typeCfg.at("heading-below", default: 1em), 1em),
            h1: as-length(sizes.at("h1", default: 20pt), 20pt),
            h2: as-length(sizes.at("h2", default: 16pt), 16pt),
            h3: as-length(sizes.at("h3", default: 14pt), 14pt),
            h4: as-length(sizes.at("h4", default: 12pt), 12pt),
        ),
        margin: (
            top: as-length(pageCfg.at("margin-top", default: 3.5cm), 3.5cm),
            bottom: as-length(pageCfg.at("margin-bottom", default: 2.5cm), 2.5cm),
            x: as-length(pageCfg.at("margin-x", default: 2.5cm), 2.5cm),
        ),
        header: (
            start-page: as-int(pageCfg.at("header-start-page", default: 3), 3),
            logo-height: as-length(pageCfg.at("header-logo-height", default: 2.5em), 2.5em),
        ),
    )
}

// Laufende Kopfzeile ab der Startseite: links die aktuelle oberste Überschrift,
// rechts das Logo, darunter eine dünne Linie.
#let page-header(logo, start-page, logo-height) = context {
    let current = here().page()
    if current >= start-page {
        let top-headings = heading.where(level: 1)
        let previous = query(top-headings.before(here()))
        let onThisPage = query(top-headings).filter(h => current == h.location().page())

        let renderHeading(body) = block[
            #show heading: set text(size: 14pt, weight: "semibold", style: "italic")
            #body
        ]

        grid(
            columns: (1fr, auto),
            column-gutter: 1em,
            if onThisPage.len() == 0 and previous.len() > 0 and previous.last().numbering != none {
                renderHeading(previous.last())
            } else {
                []
            },
            align(right, {
                set image(height: logo-height)
                logo
            }),
        )

        line(length: 100%, stroke: 0.25pt + black)
    }
}

// Laufende Fußzeile ab der Startseite: eine dünne Linie und die zentrierte
// Seitenzahl, aber nur, wenn die Seite überhaupt eine Nummerierung hat.
#let page-footer(start-page) = context {
    let current = here().page()
    if current >= start-page {
        line(length: 100%, stroke: 0.25pt + black)
        if page.numbering != none {
            align(center, counter(page).display())
        }
    }
}

#let pretty-hdm-thesis(
    metadata, date, content,

    logo: none,
    bib: none,
    bib-style: "chicago-notes",
    appendix: none,
    glossary: none, acronyms: none, abstract-de: none, abstract-en: none,
    acknowledgements: none, declaration-of-authorship: true,
    declaration-of-authorship-last: false,
    table-outline: true, figure-outline: true
) = {
    assert(metadata != none, message: "Metadata missing")
    let data = metadata.data
    let layout = metadata.layout
    let resources = yaml("resources.yaml").at(metadata.lang).headings
    let cfg = resolve-layout(layout)

    show: make-glossary

    // Typografie
    set par(leading: cfg.body.leading, spacing: cfg.body.spacing)
    show figure.caption: it => context [
        #set align(cfg.body.caption-align)
        #set text(size: 10pt)
        #strong[#it.supplement #it.counter.display(it.numbering)#it.separator]#text(fill: luma(90))[#it.body]
    ]
    set text(lang: metadata.lang, font: layout.fonts.body, size: cfg.body.size)
    show heading: set par(leading: cfg.heading.leading)
    show heading: set text(lang: metadata.lang, font: layout.fonts.heading)
    show heading: set block(spacing: 0pt, above: cfg.heading.above, below: cfg.heading.below)
    // Folgezeilen einer umbrechenden Überschrift bündig zum Titel einrücken,
    // nicht unter die Nummer. auto rückt um die Breite der Nummerierung ein.
    set heading(hanging-indent: auto)
    show heading.where(level: 4): set text(size: cfg.heading.h4)
    show heading.where(level: 3): set text(size: cfg.heading.h3)
    show heading.where(level: 2): set text(size: cfg.heading.h2)
    show heading.where(level: 1): set text(size: cfg.heading.h1)

    // Zitate und Querverweise als eine Einheit behandeln, damit Angaben wie
    // "[3, S. 4]" oder "Abbildung 3" nicht mitten im Zeilenumbruch reißen.
    show ref: it => box(it)
    show cite: it => box(it)

    // Seitengeometrie, laufende Kopf- und Fußzeile
    set document(
        title: data.title,
        author: data.authors.map(a => a.Name).join(", "),
        description: data.title + ": " + data.subtitle,
        date: date)
    set page(
        paper: "a4",
        margin: (top: cfg.margin.top, bottom: cfg.margin.bottom, x: cfg.margin.x),
        header: page-header(logo, cfg.header.start-page, cfg.header.logo-height),
        footer: page-footer(cfg.header.start-page),
    )

    // Vorspann: keine Seitenzahlen, Überschriften ohne Nummer und nicht im Verzeichnis.
    set page(numbering: none)
    set heading(numbering: none, outlined: false)
    if acronyms != none {
        register-glossary(acronyms)
    }
    if glossary != none {
        register-glossary(glossary)
    }

    titlepage(metadata, logo, date)

    set par(justify: true)

    if declaration-of-authorship and not declaration-of-authorship-last {
        declaration-of-authorship-page(
            data.authors.map(a => a.Name),
            data.title + ": " + data.subtitle,
            layout.Location, date, layout.Type, metadata.lang)
        pagebreak()
    }

    if acknowledgements != none {
        heading(resources.Acknowledgements)
        acknowledgements
        pagebreak(weak: true)
    }

    // Kurzfassungen, jede in ihrer eigenen Sprache benannt.
    let all_resources = yaml("resources.yaml")
    if abstract-en != none {
        heading(all_resources.at("en").headings.Abstract, bookmarked: true)
        abstract-en
        pagebreak(weak: true)
    }
    if abstract-de != none {
        heading(all_resources.at("de").headings.Abstract, bookmarked: true)
        abstract-de
    }

    set par(justify: false)

    // Inhaltsverzeichnis, noch ohne Seitenzahlen.
    pagebreak(weak: true)
    show outline: set heading(bookmarked: true)
    outline()

    // Verzeichnisse vor dem Hauptteil: eigener Nummernkreis in großen römischen
    // Zahlen (I, II, III, ...). Ihre Überschriften stehen selbst im Inhaltsverzeichnis.
    set page(numbering: "I")
    set heading(outlined: true)
    show outline: set heading(outlined: true)
    counter(page).update(1)
    pagebreak(weak: true)

    // Abkürzungen
    if acronyms != none {
        heading(resources.Acronyms)
        print-glossary(acronyms, disable-back-references: true)
        pagebreak(weak: true)
    }

    // Glossar
    if glossary != none {
        heading(resources.Glossary)
        print-glossary(glossary, disable-back-references: true)
        pagebreak(weak: true)
    }

    // Abbildungsverzeichnis
    if figure-outline {
        outline(title: resources.Figures, target: figure.where(kind: image))
        pagebreak(weak: true)
    }

    // Tabellenverzeichnis
    if table-outline {
        outline(title: resources.Tables, target: figure.where(kind: table))
        pagebreak(weak: true)
    }

    // Hauptteil: eigener Nummernkreis in arabischen Zahlen, nummerierte Überschriften.
    set heading(numbering: "1.1.", outlined: true)
    set page(numbering: "1 / 1")
    counter(page).update(1)
    // Überschriften-Zähler nach dem Vorspann zurücksetzen (Kurzfassung, Verzeichnisse),
    // damit der Hauptteil bei Kapitel 1 beginnt.
    counter(heading).update(0)
    pagebreak()

    set par(justify: true)
    content
    set par(justify: false)

    // Literaturverzeichnis: eigener Nummernkreis in Kleinbuchstaben (a, b, c, ...).
    if bib != none {
        pagebreak(weak: true)
        set page(numbering: "a")
        set heading(numbering: none)
        counter(page).update(1)
        set bibliography(style: bib-style, title: resources.Bibliography)
        bib
    }

    // Anhang: eigener Nummernkreis in kleinen römischen Zahlen (i, ii, iii, ...).
    // Überschriften und Abbildungen zählen mit Buchstaben (A, A.1), damit sie sich
    // nicht mit der Zählung des Hauptteils überschneiden.
    if appendix != none {
        pagebreak(weak: true)
        set page(numbering: "i")
        counter(page).update(1)
        counter(heading).update(0)
        set heading(numbering: "A.1", supplement: [Anhang])
        counter(figure.where(kind: image)).update(0)
        counter(figure.where(kind: table)).update(0)
        counter(figure.where(kind: raw)).update(0)
        set figure(numbering: n => {
            let h = counter(heading).get().at(0)
            numbering("A.1", h, n)
        })
        // Anhang-Abbildungen und -Tabellen bleiben aus den Verzeichnissen heraus,
        // die vor dem Hauptteil stehen.
        set figure(outlined: false)
        appendix
    }

    // Ehrenwörtliche Erklärung, falls sie ans Ende des Dokuments gehört.
    if declaration-of-authorship and declaration-of-authorship-last {
        pagebreak(weak: true)
        set page(numbering: none)
        set heading(numbering: none)
        declaration-of-authorship-page(
            data.authors.map(a => a.Name),
            data.title + ": " + data.subtitle,
            layout.Location, date, layout.Type, metadata.lang)
    }
}
