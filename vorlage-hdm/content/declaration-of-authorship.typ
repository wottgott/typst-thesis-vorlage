// Ehrenwörtliche Erklärung (Deutsch oder Englisch, je nach "lang" in einstellungen.yaml).
// Unterschrieben wird von Hand auf dem Ausdruck.
#let declaration-of-authorship-page(authors, title, location, date, type, lang) = {
  let plural = authors.len() > 1
  let de = lang == "de"
  let kind = if type == "master" {
    if de { "Masterarbeit" } else { "master thesis" }
  } else {
    if de { "Bachelorarbeit" } else { "bachelor thesis" }
  }
  let spo = if type == "master" { "§ 23 Abs. 2 Master-SPO (Vollzeit)" } else { "§ 24 Abs. 2 Bachelor-SPO" }

  if de [
    = Ehrenwörtliche Erklärung

    #if plural [Hiermit versichern wir] else [Hiermit versichere ich],
    #authors.join(", "), ehrenwörtlich, dass #if plural [wir] else [ich] die vorliegende #kind mit dem Titel:

    #align(center, text("„" + title + "“", size: 1.1em, weight: "semibold"))

    selbstständig und ohne fremde Hilfe verfasst und keine anderen als die angegebenen Hilfsmittel benutzt #if plural [haben] else [habe]. Die Stellen der Arbeit, die dem Wortlaut oder dem Sinn nach anderen Werken entnommen wurden, sind in jedem Fall unter Angabe der Quelle kenntlich gemacht. Die Arbeit ist noch nicht veröffentlicht oder in anderer Form als Prüfungsleistung vorgelegt worden.

    #if plural [Wir haben] else [Ich habe] die Bedeutung der ehrenwörtlichen Versicherung und die prüfungsrechtlichen Folgen (#spo) einer unrichtigen oder unvollständigen ehrenwörtlichen Versicherung zur Kenntnis genommen.
  ] else [
    = Declaration of Authorship

    I hereby declare on my honour that I wrote this #kind, titled:

    #align(center, text("“" + title + "”", size: 1.1em, weight: "semibold"))

    independently and without outside help, and used no sources other than those cited. All passages taken from other works, verbatim or in substance, are marked with their source. The thesis has not been published or submitted in any other form as an examination paper.

    I have taken note of the meaning of this declaration on my honour and of the consequences under examination law (#spo) of an incorrect or incomplete declaration.
  ]

  v(0.5cm)
  grid(
    columns: 2,
    gutter: 2cm,
    ..authors.map(author => {
      grid.cell()[
        #set par(spacing: 0.5em)
        #location, #if de [den] else [on] #date.display("[day].[month].[year]")
        #v(2cm)
        #line(length: 6cm)
        #author
      ]
    })
  )
}
