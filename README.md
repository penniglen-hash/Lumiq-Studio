# LUMIQ STUDIO – Website

**Human Creativity. Intelligent Growth.**

Website der KI-Marketing-Agentur **LUMIQ STUDIO** – entstanden als Praxisprojekt in der Weiterbildung *KI-Manager:in* (STARTPLATZ AI Academy).

🌐 **Live:** https://lumiq-studio-ki.netlify.app

---

## Funktionen

| Bereich | Technik |
|---|---|
| **One-Pager** (DE/EN umschaltbar) | eine einzige `index.html` – HTML, CSS, JavaScript, ohne Framework |
| **ROI-Rechner** | JavaScript im Browser, Annahmen stellt der Besucher selbst ein |
| **KI-Demo: LinkedIn-Post-Generator** | Website → **n8n**-Webhook → **OpenRouter** API (kostenlose Modelle) |
| **Termin buchen** | **Cal.com** (Embed, lädt erst nach Klick), verbunden mit Google Calendar |
| **Kontaktformular** | Website → **n8n**-Webhook → KI + Gmail-Automation |
| **Newsletter** | Website → **Supabase** (Postgres, Row Level Security) |
| **Rechtliches** | Impressum, Datenschutz, Cookie-Banner, AGB (Platzhalter) |

## Architektur

```
                     ┌─────────────► Cal.com (Termine)
Besucher ─► index.html ─┼─► n8n Webhook ─► OpenRouter (KI-Post)
 (Netlify)              ├─► n8n Webhook ─► KI + Gmail (Kontakt)
                        └─► Supabase REST ─► newsletter_subscribers
```

**Sicherheitsprinzip:** Geheime API-Schlüssel stehen **nie** im Website-Code.
- Der OpenRouter-Schlüssel liegt in den **n8n Credentials**.
- Der Supabase-Schlüssel in der Website ist der **öffentliche** „publishable“ Key; Row Level Security erlaubt damit **nur das Eintragen** neuer Anmeldungen (kein Lesen, Ändern, Löschen).
- Lokale Schlüssel stehen in einer `.env`, die per `.gitignore` nicht hochgeladen wird.

## Dateien

```
index.html                         Website (alles in einer Datei)
n8n/LUMIQ-LinkedIn-Generator.json  n8n-Workflow zum Importieren (ohne Zugangsdaten)
supabase/newsletter.sql            Tabelle + Sicherheitsregeln für den Newsletter
```

## Einrichtung (eigene Kopie)

1. **Hosting:** `index.html` z. B. auf Netlify hochladen (Drag & Drop).
2. **n8n:** Workflow importieren → im Node *OpenRouter (KI)* eine *Header Auth*-Credential anlegen
   (`Authorization` = `Bearer <OpenRouter-Key>`) → **Publish**.
3. **Supabase:** `supabase/newsletter.sql` im SQL Editor ausführen; Project URL und
   *publishable key* in `index.html` (`SUPABASE_URL`, `SUPABASE_PUBLIC_KEY`) eintragen.
4. **Cal.com:** eigenen Buchungslink in `index.html` (`CAL_LINK`) eintragen.
5. **Kontaktformular:** eigene n8n-Webhook-URL in `index.html` (`N8N_WEBHOOK_URL`) eintragen.

## Design

Farben und Schriften nach dem LUMIQ-Brand-Book: Deep Navy `#151B36`, Violet `#6658D9`,
Lavender `#B7A7F4`, Ice `#F3F0FA` · Schriften **Manrope** (Headlines) und **Inter** (Text).

## Hinweis

Demo-/Weiterbildungsprojekt. Kontaktdaten, Preise, Testimonials und Rechtstexte sind teilweise **Platzhalter** und vor einem echten Einsatz zu prüfen.

---

Umgesetzt von **Elena Cherepanova** – Schritt für Schritt mit Unterstützung von **Claude**.
