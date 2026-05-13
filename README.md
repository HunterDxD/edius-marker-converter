# EDIUS Marker Converter

Zwei Windows-Batch-Skripte, die EDIUS-Markerlisten in das Drax-Importformat umwandeln und optional direkt in ein Video importieren.

---

## Hintergrund

EDIUS kann Markerlisten in drei Formaten exportieren:

| Format | Datei | Unterstützt |
|--------|-------|-------------|
| Version 2 | `.csv` | ✅ |
| Version 3 | `.csv` | ✅ |
| Version 4 | `.xml` | ❌ |

Damit diese Markerlisten als Kapitel in ein Video importiert werden können (z. B. über [Drax](https://www.draxsoftware.com/)), muss das CSV-Format in ein einfaches Zeitcode-Format umgewandelt werden:

```
00:00:00:000 Kapitelname
00:01:23:456 Zweites Kapitel
```

Diese Skripte erledigen die Umwandlung automatisch.

---

## Skripte

### `edius-convert.bat` – Markerliste konvertieren

Liest eine EDIUS-Markerliste (`.csv`) und schreibt eine fertig formatierte `.txt`-Datei im selben Ordner.

**Verwendung:**
- CSV-Datei per Drag & Drop auf `edius-convert.bat` ziehen, **oder**
- `edius-convert.bat` doppelklicken → verarbeitet alle `.csv`-Dateien im selben Ordner

**Ausgabe:** `meine-markerliste.csv` → `meine-markerliste.txt`

---

### `edius-import.bat` – In Video importieren (benötigt Drax)

Nimmt eine konvertierte `.txt`-Datei und importiert sie über Drax direkt in ein Video.

**Voraussetzungen:**
- [Drax](https://www.draxsoftware.com/) muss installiert sein
- Standard-Installationspfad: `C:\Program Files (x86)\Drax\Drax\Drax.exe`
- Bei abweichendem Pfad: Zeile 20 in `edius-import.bat` anpassen

**Voraussetzungen für den Match:**
- Die `.mp4`-Datei muss im **gleichen Ordner** wie die `.txt`-Datei liegen
- Der Dateiname der MP4 muss den Basisnamen der TXT **enthalten**
- Beispiel: `Konzert.txt` + `Konzert-final-export.mp4` → ✅ Match

**Verwendung:**
- TXT-Datei per Drag & Drop auf `edius-import.bat` ziehen, **oder**
- `edius-import.bat` doppelklicken → verarbeitet alle `.txt`-Dateien im selben Ordner

---

## Typischer Workflow

```
1. In EDIUS: Datei → Markerliste exportieren → Format Version 2 oder 3 (CSV)

2. CSV-Datei auf edius-convert.bat ziehen
   → Erzeugt eine TXT-Datei im gleichen Ordner

3. TXT-Datei auf edius-import.bat ziehen
   → Importiert die Kapitel direkt in das passende MP4 via Drax
```

---

## Hinweise

- Funktioniert mit **Windows 7 und neuer** (keine zusätzliche Software nötig außer Drax für den Import)
- Ordnernamen und Dateipfade mit **Leerzeichen** werden korrekt verarbeitet
- Format Version 4 (XML-Export) wird nicht unterstützt – bitte Format 2 oder 3 beim Export wählen
