// ============================================================
//  HAUPTDATEI
//  Hier musst du normalerweise nur die Kapitelliste ändern
//  (siehe unten). Alle anderen Einstellungen stehen in
//  einstellungen.yaml.
// ============================================================

#import "@preview/cmarker:0.1.6"
#import "@preview/glossarium:0.5.9": gls, glspl
#import "vorlage-hdm/lib.typ": pretty-hdm-thesis

#let einstellungen = yaml("einstellungen.yaml")

// Abgabedatum aus den Einstellungen ("JJJJ-MM-TT"); leer = heute.
#let datum = {
  let d = einstellungen.at("date", default: "")
  if d == "" or d == none {
    datetime.today()
  } else {
    let teile = str(d).split("-").map(int)
    datetime(year: teile.at(0), month: teile.at(1), day: teile.at(2))
  }
}

// Markdown-Datei (.md) einlesen und setzen. Dateien, die auf ".typ" enden,
// werden stattdessen als Typst-Datei eingebunden.
//
// Zusätzlich zu normalem Markdown gibt es vier Kurzschreibweisen
// (Beispiele in kapitel/99-beispiele.md):
//   {@schluessel}            Quelle zitieren
//   {@schluessel S. 12}      Quelle mit Seitenzahl zitieren
//   {fn:Text}                Fußnote
//   {abk:API}                Abkürzung (steht beim ersten Mal ausgeschrieben da)
// Mit {@abb-name} oder {@tab-name} verweist man auf Bilder und Tabellen.
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
//  Optionale Teile: auskommentieren (// davor) oder auf none setzen,
//  wenn du sie nicht brauchst.
// ------------------------------------------------------------
#let kurzfassung = markdown("kapitel/00-kurzfassung.md")
#let abstract = markdown("kapitel/00-abstract.md")
#let abkuerzungen = yaml("abkuerzungen.yaml")
#let glossar = yaml("glossar.yaml")
// Danksagung: Datei anlegen und die Zeile darunter durch diese ersetzen:
//   #let danksagung = markdown("kapitel/00-danksagung.md")
#let danksagung = none

// ------------------------------------------------------------
//  KAPITELLISTE
//  Ein Kapitel = eine Zeile. Die Reihenfolge hier ist die
//  Reihenfolge in der Arbeit. Neues Kapitel: Datei in "kapitel/"
//  anlegen und hier eine Zeile ergänzen.
// ------------------------------------------------------------
#let kapitel = (
  "kapitel/01-einleitung.md",
  "kapitel/99-beispiele.md",
  // "kapitel/02-grundlagen.md",
  // "kapitel/03-methodik.md",
  // "kapitel/04-ergebnisse.md",
  // "kapitel/05-fazit.md",
)

// Anhang (optional): Datei anlegen und hier eintragen, sonst none.
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
