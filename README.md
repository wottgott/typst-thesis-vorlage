# Thesis-Vorlage (Typst, HdM-Layout)

Vorlage für eine Abschlussarbeit im Layout der Hochschule der Medien. Die Kapitel
schreibst du in einfachen **Markdown-Dateien**, den Rest (Titelseite,
Inhaltsverzeichnis, Kopfzeile, Seitenzahlen, Literaturverzeichnis) macht die
Vorlage von allein.

## 1. Einrichten (einmalig)

1. **Repo herunterladen:** auf GitHub oben rechts auf den grünen Knopf
   **Code → Download ZIP**, ZIP entpacken. (Mit Git geht auch `git clone`.)
2. **Visual Studio Code** installieren (https://code.visualstudio.com).
3. In VS Code links auf das Symbol **Erweiterungen** (vier Quadrate) klicken,
   nach **Tinymist Typst** suchen und installieren.
4. In VS Code: **Datei → Ordner öffnen** und den entpackten Ordner wählen.
5. `main.typ` öffnen und oben rechts auf das **Vorschau-Symbol** (Lupe mit Seite)
   klicken. Daneben erscheint die Arbeit als PDF und aktualisiert sich bei
   jedem Speichern.

Beim ersten Mal lädt Typst ein paar Zusatzpakete herunter, dafür braucht der
Rechner Internet. Die Schrift **Arial** muss installiert sein (Windows und Mac
haben sie).

Das fertige PDF bekommst du mit **Strg+Shift+P** (Mac: Cmd+Shift+P), dann
`Typst: Export PDF` eingeben.

## 2. Was liegt wo?

| Datei / Ordner | Wofür |
|---|---|
| `einstellungen.yaml` | Titel, Name, Prüfer, Abgabedatum und alles zum Aussehen (Ränder, Schrift, Abstände) |
| `kapitel/` | **Deine Texte**, ein Kapitel pro Markdown-Datei |
| `main.typ` | Hauptdatei: hier steht die **Kapitelliste** |
| `bilder/` | Deine Bilder |
| `literatur/literatur.bib` | Deine Quellen |
| `abkuerzungen.yaml` | Abkürzungsverzeichnis |
| `glossar.yaml` | Glossar (optional, leer = wird weggelassen) |
| `vorlage-hdm/` | Das Layout selbst. Hier musst du nichts ändern. |

## 3. Zuerst: Angaben eintragen

Öffne `einstellungen.yaml` und ersetze unter `data:` Titel, Untertitel, deinen
Namen, Matrikelnummer und die Prüfer. Dort stellst du auch das Abgabedatum ein
und ob es eine Bachelor- oder Masterarbeit ist. Die Einrückungen am
Zeilenanfang nicht verändern.

## 4. Ein neues Kapitel anlegen

1. Im Ordner `kapitel/` eine neue Datei anlegen, z. B. `02-grundlagen.md`.
2. In die erste Zeile die Kapitelüberschrift mit einem `#` schreiben:
   `# Grundlagen`
3. In `main.typ` bei der **KAPITELLISTE** eine Zeile ergänzen (oder das `//`
   vor einer vorbereiteten Zeile entfernen):

   ```
   "kapitel/02-grundlagen.md",
   ```

Die Reihenfolge in der Liste ist die Reihenfolge in der Arbeit. Jedes Kapitel
beginnt auf einer neuen Seite. Die Datei `kapitel/99-beispiele.md` kannst du
löschen, sobald du sie nicht mehr brauchst (Datei löschen und die Zeile in der
Kapitelliste entfernen).

## 5. Schreiben mit Markdown

```markdown
# Kapitel            (Überschrift 1)
## Abschnitt         (Überschrift 2)
### Unterabschnitt   (Überschrift 3)

Ein Absatz. Eine Leerzeile trennt Absätze.
**fett**, *kursiv*, `Code`

- Aufzählung
- zweiter Punkt

1. Nummerierte Liste
2. zweiter Punkt
```

Die Nummern (1, 1.1, 1.1.1) vergibt die Vorlage selbst.

### Quellen, Fußnoten, Abkürzungen

Diese Kurzschreibweisen gibt es zusätzlich (Beispiele siehe
`kapitel/99-beispiele.md`):

| Schreibe | Ergebnis |
|---|---|
| `{@mustermann2024}` | Zitat der Quelle `mustermann2024` aus `literatur.bib` |
| `{@mustermann2024 S. 12}` | Zitat mit Seitenzahl |
| `{fn:Text der Fußnote}` | Fußnote |
| `{abk:API}` | Abkürzung aus `abkuerzungen.yaml` (beim ersten Mal ausgeschrieben) |
| `{@abb-logo}` | Verweis auf ein Bild oder eine Tabelle mit dem Namen `abb-logo` |

### Bilder, Tabellen, Formeln

Dafür kopierst du die fertigen Blöcke aus `kapitel/99-beispiele.md` und
änderst Dateiname, Beschriftung und Inhalt. Bilder liegen im Ordner `bilder/`.
Ein Block beginnt mit `<!--raw-typst` und endet mit `-->`, dazwischen darf
nichts am Rahmen verändert werden.

## 6. Einstellungen ändern

Alles zum Aussehen steht in `einstellungen.yaml` unter `layout:`, jeweils mit
einem Kommentar dahinter: Seitenränder, Schriftgröße, Zeilenabstand,
Absatzabstand, Überschriftengrößen, Abstand um Überschriften. Die Voreinstellung
ist das HdM-Layout in leicht verkleinerter Form. Werte immer mit Einheit und
Anführungszeichen schreiben, z. B. `"2.5cm"` oder `"11pt"`.

Weitere Auswahlmöglichkeiten in `main.typ` (jeweils mit Kommentar):
Zitierstil (`bib-style`), ob die Ehrenwörtliche Erklärung vorne oder am Ende
steht, Danksagung, Anhang.

## 7. Bei Fehlern

Typst zeigt Fehler mit Datei und Zeile an. Meistens ist es ein vergessenes
Anführungszeichen, eine falsche Einrückung in einer `.yaml`-Datei oder ein
Schreibfehler im Dateinamen der Kapitelliste. Wenn nichts mehr geht: die
letzte Änderung rückgängig machen (Strg+Z) und von dort aus neu versuchen.

Das Layout stammt vom Template *pretty-hdm-thesis* und wurde für diese
Vorlage vereinfacht (Markdown-Kapitel, zentrale Einstellungen).
