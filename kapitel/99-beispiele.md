# Beispiele zum Abschauen

Dieses Kapitel zeigt, wie Quellen, Bilder, Tabellen und Verweise gesetzt werden. Sobald du die Beispiele nicht mehr brauchst, kannst du die Datei löschen und ihre Zeile in der Kapitelliste von `main.typ` entfernen.

## Quellen zitieren

Die Quellen stehen in `literatur/literatur.bib`, und im Text zitierst du sie mit dem Kurznamen des Eintrags in geschweiften Klammern, dem ein `@` vorangestellt ist. Mit Seitenzahl sieht das so aus: Diese Aussage steht so im Buch {@mustermann2024 S. 12}. Ohne Seitenzahl genügt der Kurzname allein, wie bei dieser allgemein bekannten Aussage {@mustermann2024}.

## Bilder

Das Bild legst du im Ordner `bilder/` ab, als PNG, JPG oder SVG. Der folgende Block zeigt ein Bild mit Beschriftung und einem Namen, über den du im Text darauf verweisen kannst:

<!--raw-typst
#figure(
  image("bilder/HdM_Logo.svg", width: 40%),
  caption: [Das ist die Bildunterschrift],
) <abb-logo>
-->

Auf dieses Bild verweist du im Text mit {@abb-logo}.

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

Der Verweis auf diese Tabelle lautet {@tab-beispiel}.

## Fußnoten und Abkürzungen

Eine Fußnote entsteht direkt hinter dem Wort, zu dem sie gehört:{fn:Das ist der Text der Fußnote.} Abkürzungen stehen in `abkuerzungen.yaml` und werden mit {abk:API} eingesetzt, wobei sie beim ersten Auftreten ausgeschrieben erscheinen und danach nur noch als Kürzel, hier also {abk:API}.

## Formeln

Für eine Formel kopierst du die folgende Zeile und änderst den Inhalt zwischen den Dollarzeichen:

<!--raw-typst $ E = m c^2 $-->
