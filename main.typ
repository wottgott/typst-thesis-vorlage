// ============================================================
//  HAUPTDATEI
//  In dieser Datei änderst du normalerweise nur die Kapitelliste
//  (siehe unten), denn alle übrigen Einstellungen stehen in
//  einstellungen.yaml.
// ============================================================

#import "@preview/cmarker:0.1.6"
#import "@preview/glossarium:0.5.9": gls, glspl
#import "vorlage-hdm/lib.typ": pretty-hdm-thesis

#let einstellungen = yaml("einstellungen.yaml")

// Abgabedatum aus den Einstellungen ("JJJJ-MM-TT"), bei leerem Feld das heutige Datum.
#let datum = {
  let d = einstellungen.at("date", default: "")
  if d == "" or d == none {
    datetime.today()
  } else {
    let teile = str(d).split("-").map(int)
    datetime(year: teile.at(0), month: teile.at(1), day: teile.at(2))
  }
}

// Liest eine Markdown-Datei (.md) ein und setzt sie. Dateien, die auf ".typ"
// enden, werden stattdessen als Typst-Datei eingebunden.
//
// Zusätzlich zu normalem Markdown gibt es Kurzschreibweisen
// (Beispiele in kapitel/99-beispiele.md):
//   {@schluessel}            Quelle zitieren
//   {@schluessel S. 12}      Quelle mit Seitenzahl zitieren
//   {fn:Text}                Fußnote
//   {abk:API}                Abkürzung (steht beim ersten Mal ausgeschrieben da)
// Mit {@abb-name} oder {@tab-name} verweist du auf Bilder und Tabellen.
#let vorverarbeiten(text) = {
  text
  .replace(regex("[{]fn:([^}]*)[}]"), m => "<!--raw-typst#footnote[" + m.captures.at(0) + "]-->")
  .replace(regex("[{]abk:([^}]*)[}]"), m => "<!--raw-typst#gls(\"" + m.captures.at(0) + "\")-->")
  .replace(regex("[{]@([A-Za-z0-9_:-]+) ([^}]*)[}]"), m => "<!--raw-typst#cite(<" + m.captures.at(0) + ">, supplement: [" + m.captures.at(1) + "])-->")
  .replace(regex("[{]@([A-Za-z0-9_:-]+)[}]"), m => "<!--raw-typst@" + m.captures.at(0) + "-->")
}

#let markdown(pfad) = cmarker.render(
  vorverarbeiten(read(pfad)),
  scope: (image: (pfad, ..optionen) => image("" + pfad, ..optionen), gls: gls, glspl: glspl),
)
#let datei(pfad) = if pfad.ends-with(".typ") { include pfad } else { markdown(pfad) }

// ------------------------------------------------------------
//  Optionale Teile: Wenn du sie nicht brauchst, setzt du ein // davor
//  oder den Wert auf none.
// ------------------------------------------------------------
#let kurzfassung = markdown("kapitel/00-kurzfassung.md")
#let abstract = markdown("kapitel/00-abstract.md")
#let abkuerzungen = yaml("abkuerzungen.yaml")
#let glossar = yaml("glossar.yaml")
// Für eine Danksagung legst du die Datei an und ersetzt die Zeile darunter durch diese:
//   #let danksagung = markdown("kapitel/00-danksagung.md")
#let danksagung = none

// ------------------------------------------------------------
//  KAPITELLISTE
//  Jedes Kapitel steht in einer eigenen Zeile, und die Reihenfolge hier
//  bestimmt die Reihenfolge in der Arbeit. Für ein neues Kapitel legst du
//  eine Datei in "kapitel/" an und ergänzt hier eine Zeile.
// ------------------------------------------------------------
#let kapitel = (
  "kapitel/01-einleitung.md",
  "kapitel/99-beispiele.md",
  // "kapitel/02-grundlagen.md",
  // "kapitel/03-methodik.md",
  // "kapitel/04-ergebnisse.md",
  // "kapitel/05-fazit.md",
)

// Anhang (optional): Dafür legst du eine Datei an und trägst sie hier ein, sonst bleibt es none.
#let anhang = none
// #let anhang = markdown("kapitel/anhang.md")

#show: pretty-hdm-thesis.with(
  einstellungen,
  datum,
  bib: bibliography("literatur/literatur.bib"),
  bib-style: "ieee",              // Zitierstil, z. B. "ieee", "apa", "chicago-author-date"
  declaration-of-authorship-last: false,  // true = Erklärung am Ende statt vorne
  glossary: if glossar.len() > 0 { glossar } else { none },
  acronyms: if abkuerzungen.len() > 0 { abkuerzungen } else { none },
  abstract-de: kurzfassung,
  abstract-en: abstract,
  acknowledgements: danksagung,
  logo: image("bilder/HdM_Logo.svg"),
  appendix: anhang,
)

#for k in kapitel {
  datei(k)
  pagebreak(weak: true)
}
