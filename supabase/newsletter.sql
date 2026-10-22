-- =============================================================
--  LUMIQ STUDIO – Newsletter-Tabelle fuer Supabase
--  Ausfuehren in: Supabase -> SQL Editor -> New query -> Run
-- =============================================================

-- 1) Tabelle fuer Newsletter-Anmeldungen
create table if not exists public.newsletter_subscribers (
  id           uuid primary key default gen_random_uuid(),
  email        text not null unique
               check (length(email) <= 254 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  language     text not null default 'de' check (language in ('de', 'en')),
  consent      boolean not null check (consent = true),        -- Einwilligung ist Pflicht
  consent_text text,                                             -- welcher Einwilligungstext bestaetigt wurde
  source       text not null default 'lumiq-website',
  status       text not null default 'pending'
               check (status in ('pending', 'confirmed', 'unsubscribed')), -- fuer Double-Opt-In
  created_at   timestamptz not null default now()
);

-- 2) Sicherheit: Row Level Security einschalten
alter table public.newsletter_subscribers enable row level security;

-- 3) Die Website (oeffentlicher anon-Schluessel) darf NUR neue Anmeldungen eintragen.
--    Es gibt bewusst KEINE Lese-, Aenderungs- oder Loesch-Regel fuer "anon":
--    Besucher koennen also keine E-Mail-Adressen auslesen.
drop policy if exists "Website darf neue Anmeldungen eintragen" on public.newsletter_subscribers;
create policy "Website darf neue Anmeldungen eintragen"
  on public.newsletter_subscribers
  for insert
  to anon
  with check (consent = true and status = 'pending' and source = 'lumiq-website');

-- Hinweis: Du selbst siehst alle Eintraege im Supabase "Table Editor".
-- n8n kann mit dem geheimen service_role-Schluessel lesen/aendern (z. B. fuer Double-Opt-In).
