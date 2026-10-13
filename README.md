# Thesis-Vorlage in Typst (HdM-Layout)

Mit dieser Vorlage schreibst du deine Abschlussarbeit im Layout der Hochschule der Medien, ohne dich um die Formatierung kümmern zu müssen. Die Kapitel liegen als einfache Markdown-Dateien vor, und um Titelseite, Inhaltsverzeichnis, Kopfzeile, Seitenzahlen und Literaturverzeichnis kümmert sich die Vorlage selbst.

## 1. Einrichten (einmalig)

1. Lade das Repo auf GitHub über den grünen Knopf **Code → Download ZIP** herunter und entpacke die Datei. Wenn du Git kennst, funktioniert auch `git clone`.
2. Installiere [Visual Studio Code](https://code.visualstudio.com), falls du es noch nicht hast.
3. Öffne in VS Code links die **Erweiterungen** (das Symbol mit den vier Quadraten), suche nach **Tinymist Typst** und installiere die Erweiterung.
4. Öffne über **Datei → Ordner öffnen** den entpackten Ordner und danach die Datei `main.typ`.
5. Klicke oben rechts auf das **Vorschau-Symbol** (eine Seite mit Lupe). Neben dem Text erscheint dann deine Arbeit als PDF, das sich bei jedem Speichern von selbst aktualisiert.

Beim allerersten Start lädt Typst zwei Zusatzpakete nach, dafür braucht der Rechner eine Internetverbindung. Außerdem muss die Schrift **Arial** installiert sein, was unter Windows und auf dem Mac der Fall ist.

Das fertige PDF exportierst du mit **Strg+Shift+P** (Mac: Cmd+Shift+P) und dem Befehl `Typst: Export PDF`.

## 2. Was liegt wo?

| Datei oder Ordner | Inhalt |
|---|---|
| `einstellungen.yaml` | Titel, Name, Prüfer, Abgabedatum und alles zum Aussehen (Ränder, Schrift, Abstände) |
| `kapitel/` | Deine Texte, ein Kapitel pro Markdown-Datei |
| `main.typ` | Die Hauptdatei mit der **Kapitelliste** |
| `bilder/` | Deine Bilder |
| `literatur/literatur.bib` | Deine Quellen |
| `abkuerzungen.yaml` | Das Abkürzungsverzeichnis |
| `glossar.yaml` | Das Glossar, das bei leerer Liste einfach entfällt |
| `vorlage-hdm/` | Das Layout selbst, hier musst du nichts ändern |

## 3. Zuerst deine Angaben eintragen

Öffne `einstellungen.yaml` und ersetze im Abschnitt `data:` Titel, Untertitel, deinen Namen, die Matrikelnummer und die Prüfer. Weiter oben legst du das Abgabedatum fest, und unter `layout:` wählst du zwischen Bachelor- und Masterarbeit. Die Einrückungen am Zeilenanfang musst du dabei unverändert lassen, weil die Datei sonst nicht mehr gelesen werden kann.

## 4. Ein neues Kapitel anlegen

1. Lege im Ordner `kapitel/` eine neue Datei an, zum Beispiel `02-grundlagen.md`.
2. Schreibe in die erste Zeile die Kapitelüberschrift mit einem `#` davor, also `# Grundlagen`.
3. Ergänze in `main.typ` bei der **KAPITELLISTE** eine Zeile mit dem Dateinamen, oder entferne das `//` vor einer vorbereiteten Zeile:

   ```
   "kapitel/02-grundlagen.md",
   ```

Die Reihenfolge in dieser Liste bestimmt die Reihenfolge in der Arbeit, und jedes Kapitel beginnt automatisch auf einer neuen Seite. Die Beispieldatei `kapitel/99-beispiele.md` kannst du löschen, sobald du sie nicht mehr brauchst. Entferne dazu auch ihre Zeile in der Kapitelliste.

## 5. Schreiben mit Markdown

```markdown
# Kapitel            (Überschrift 1)
## Abschnitt         (Überschrift 2)
### Unterabschnitt   (Überschrift 3)

Ein Absatz endet mit einer Leerzeile.
**fett**, *kursiv*, `Code`

- Aufzählung
- zweiter Punkt

1. Nummerierte Liste
2. zweiter Punkt
```

Die Nummern der Kapitel und Abschnitte (1, 1.1, 1.1.1) vergibt die Vorlage von selbst.

### Quellen, Fußnoten und Abkürzungen

Für diese drei Dinge gibt es Kurzschreibweisen in geschweiften Klammern, die du in `kapitel/99-beispiele.md` im Einsatz siehst:

| Du schreibst | Das Ergebnis |
|---|---|
| `{@mustermann2024}` | Zitat der Quelle `mustermann2024` aus `literatur.bib` |
| `{@mustermann2024 S. 12}` | Zitat mit Seitenzahl |
| `{fn:Text der Fußnote}` | Fußnote am Seitenende |
| `{abk:API}` | Abkürzung aus `abkuerzungen.yaml`, beim ersten Mal ausgeschrieben |
| `{@abb-logo}` | Verweis auf das Bild oder die Tabelle mit dem Namen `abb-logo` |

### Bilder, Tabellen und Formeln

Hier kopierst du am einfachsten die fertigen Blöcke aus `kapitel/99-beispiele.md` und änderst Dateiname, Beschriftung und Inhalt. Die Bilder legst du dafür im Ordner `bilder/` ab. Jeder Block beginnt mit `<!--raw-typst` und endet mit `-->`, und diesen Rahmen solltest du so lassen, wie er ist.

## 6. Einstellungen ändern

Alles zum Aussehen findest du in `einstellungen.yaml` unter `layout:`, und hinter jedem Wert steht ein Kommentar dazu. Einstellbar sind Seitenränder, Schriftgröße, Zeilenabstand, Absatzabstand sowie Größe und Abstände der Überschriften. Die Voreinstellung entspricht dem HdM-Layout in leicht verkleinerter Form. Zahlen schreibst du immer mit Einheit in Anführungszeichen, etwa `"2.5cm"` oder `"11pt"`.

In `main.typ` lassen sich außerdem der Zitierstil (`bib-style`), die Position der Ehrenwörtlichen Erklärung (vorne oder am Ende), die Danksagung und der Anhang einstellen.

## 7. Wenn eine Fehlermeldung erscheint

Typst nennt bei jedem Fehler die Datei und die Zeile, in der er steckt. Meistens fehlt ein Anführungszeichen, eine Einrückung in einer `.yaml`-Datei stimmt nicht, oder der Dateiname in der Kapitelliste enthält einen Tippfehler. Hilft das nicht weiter, machst du die letzte Änderung mit Strg+Z rückgängig und gehst von dort aus Schritt für Schritt vor.

Das Layout stammt vom Template *pretty-hdm-thesis* und wurde für diese Vorlage vereinfacht, damit Kapitel in Markdown funktionieren und alle Einstellungen an einer Stelle stehen.
