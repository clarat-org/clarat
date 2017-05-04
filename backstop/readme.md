# Halbautomatische manual visual regression tests, oder "Versuch der CSS-Zähmung"

Diese manuellen Tests nutzen das node-Modul "backstopJS": https://github.com/garris/BackstopJS. BackstopJS erstellt Screenshots von angegebenen Seiten oder Elementen. Im Falle von Clarat werden komplette Seiten (und diese in mehrern Bildschirmdimensionen) erfasst. BackstopJS bietet kein automatisiertes Testing in verschiedenen Browsern, sondern arbeitet mit einem einzigen headless Browser, der im wesentlichen eine ältere Chrome-Version ist.

Aus mehreren Gründen sind diese visuellen Regressions-Test nicht Teil der bestehenden Clarat-Testsuite (Resourcennutzung, Dauer der Tests, Zusammenspiel zwischen Rails und node,...), können aber im folgenden Szenario hilfreich sein:

Für ein Feature im Clarat-Frontend wird CSS oder JS angefasst und eine Änderung in der Ausgabe der Seite ist zu erwarten. BackstopJS sorgt einerseits für einen schnellen Überblick im Kontext der geänderten Seite (zum Beispiel ob geänderte Styles auf mehr Breakpoints wirken als gewollt), andererseits zum schnelleren Entdecken von ggf. ungewünschten Änderungen im Gesamtprojekt (Beispiel: Änderung des zentralen Suchformulars auf Folgeseiten macht Suche auf "World Start" kaputt).


# Installation und Abhängigkeiten

Backstop JS erfordert eine aktuelle Node-Version und eine globale Installation: `npm install -g backstopjs`

Nach erfolger Installation müssen weitere Abhängigkeiten wie der headless Browser installiert werden: `npm install`

# Benutzung

Vorgeschlagene Nutzung: Direkt nach dem Auschecken eines Feature- oder Fixbranches von develop oder master werden Referenz-Screenshots erstellt (die genauen Commands sind im folgenden in den einzelnen Szenariobeschreibungen zu finden).

**Wichtig: Clarat muss lokal (und auf localhost:3000) laufen, bevor backstopJS benutzt wird. Andernfalls werden weiße Seiten mit weißen Seiten verglichen (was zwar angehehm schnell und fehlerlos geht, aber keine Hilfe ist 😉).**

## "Testszenarien"
Es wird versucht einen großen Überblick über die Seite zu gewinnen und zu erhalten. Da dies aber bedeutet: Jedes Template in jeder Sprache in jeder (sinnvollen) Bildschirmbreite - musste dies in einzelne (immer noch recht große) Pakete aufgeteilt werden. Jedes einzelne Paket hat jeweils einen Befehl zur Erstellung der "Baseline"- oder Referenzscreens und einem zum Testen selbst.


### "World Choice"
http://localhost:3000/

Auswahl der Welten

```
npm run backstop-worldchoice-ref
npm run backstop-worldchoice
```

### "World Start"
http://localhost:3000/family, http://localhost:3000/refugees

Startseite der jeweiligen Welt

```
npm run backstop-worldstart-ref
npm run backstop-worldstart
```

### "Offer Show"
http://localhost:3000/family/angebote/16 (und jeweils lokalisierten Routes)

Einzelner Offer-Eintrag. Achtung - unsere jeweiligen Datenstände weichen unter Garantie ab, nicht immer gibt es ein Offer mit ID 16. Hierzu bitte die Pfade in `backstop/offer_show.json` anpassen!

```
npm run backstop-worldstart-ref
npm run backstop-worldstart
```

### "Offer Index"
http://localhost:3000/family/angebote?utf8=✓ (und alle weiteren GET-Parameter...) (und jeweils lokalisierten Routes)

Offer-Übersicht. Da die Google Map manchmal unterschiedlich lange lädt und deswegen vereinzelt zwischen Referenz- und Test-Run nicht fertig geladen ist, ist sie für dieses Testszenario generell ausgeblendet

```
npm run backstop-offerindex-ref
npm run backstop-offerindex
```

### "Orga Show"
http://localhost:3000/family/organisationen/1 (und jeweils lokalisierte Routes)

Einzelner Orga-Eintrag. Achtung - unsere jeweiligen Datenstände weichen unter Garantie ab, nicht immer gibt es eine Orga mit ID 1. Hierzu bitte die Pfade in `backstop/orga_show.json` anpassen!

```
npm run backstop-orgashow-ref
npm run backstop-orgashow
```

### "About"
http://localhost:3000/family/ueber-uns

Über Uns-Seite

```
npm run backstop-about-ref
npm run backstop-about
```

### "FAQ"
http://localhost:3000/family/haeufige-fragen

FAQ-Seite

```
npm run backstop-faq-ref
npm run backstop-faq
```

