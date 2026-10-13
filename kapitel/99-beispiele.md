# Beispiele zum Abschauen

Dieses Kapitel zeigt, wie man Quellen, Bilder, Tabellen und Verweise setzt.
Wenn du es nicht mehr brauchst: Datei löschen und die Zeile in `main.typ`
entfernen.

## Quellen zitieren

Quellen stehen in `literatur/literatur.bib`. Im Text zitierst du mit dem
Kurznamen des Eintrags, in geschweiften Klammern mit einem `@` davor.
Beispiel mit Seitenzahl: Das steht so im Buch {@mustermann2024 S. 12}.
Ohne Seitenzahl: Das ist allgemein bekannt {@mustermann2024}.

## Bilder

Lege das Bild in den Ordner `bilder/` (PNG, JPG oder SVG). Ein Bild mit
Beschriftung und Verweis darauf:

<!--raw-typst
#figure(
  image("bilder/HdM_Logo.svg", width: 40%),
  caption: [Das ist die Bildunterschrift],
) <abb-logo>
-->

Im Text verweist du darauf mit {@abb-logo}.

## Tabellen

<!--raw-typst
#figure(
  table(
    columns: 3,
    [*Name*], [*Wert*], [*Einheit*],
    [Erstens], [1], [kg],
    [Zweitens], [2], [kg],
  ),
  caption: [Das ist die Tabellenüberschrift],
) <tab-beispiel>
-->

Verweis auf die Tabelle: {@tab-beispiel}.

## Fußnoten und Abkürzungen

Eine Fußnote setzt du so:{fn:Text der Fußnote.}

Eine Abkürzung aus `abkuerzungen.yaml` setzt du mit {abk:API}. Beim ersten
Mal steht sie ausgeschrieben da, danach nur noch als Kürzel: {abk:API}.

## Formeln

Für Formeln kopierst du diese Zeile und änderst die Formel:

<!--raw-typst $ E = m c^2 $-->
