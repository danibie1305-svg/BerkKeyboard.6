# Rune Keyboard – istruzioni (Windows + iPhone 12, senza Mac)

## Cosa è verificato e cosa no
- Il codice NON è stato compilato da me (non ho un Mac): la prima esecuzione su GitHub è il vero test.
- Installazione con Apple Account gratuito da Windows: il metodo più probabile è **Sideloadly**
  (sideloadly.io). Non ho potuto verificarlo in questa sessione: provalo e controlla.
- Limiti noti dell'account gratuito: la firma dura **7 giorni**, poi va rifatta (stessa procedura);
  numero limitato di app/ID per settimana.
- Senza abbonamento Apple Developer a pagamento non esistono TestFlight né installazioni permanenti.

## 1. Caricare i file su GitHub
1. Su github.com: "+" in alto > "New repository" > nome `RuneKeyboard` > Create.
2. Estrai lo ZIP sul PC. Nel repository clicca "uploading an existing file".
3. Trascina TUTTE le cartelle e i file (App, Keyboard, .github, project.yml, .gitignore).
   Attenzione: la cartella `.github` è nascosta/inizia con un punto; se non si carica col
   trascinamento, usa "Add file > Create new file", scrivi `.github/workflows/build.yml`
   e incolla il contenuto.
4. Clicca "Commit changes".

## 2. Avviare la compilazione
1. Scheda "Actions" > "Build Rune Keyboard" > "Run workflow".
2. Attendi il pallino verde (circa 3-6 minuti). Rosso = errore.
3. Se è rosso: apri il passaggio "Mostra errori leggibili" e cerca la parola `error:`.
   Copiami quelle righe.

## 3. Scaricare il risultato
Nella pagina dell'esecuzione, in fondo, sezione "Artifacts": scarica `RuneKeyboard-unsigned-ipa`
ed estrai lo ZIP: dentro c'è `RuneKeyboard-unsigned.ipa`.

## 4. Installare sull'iPhone
1. Installa iTunes e iCloud dal sito Apple (non dal Microsoft Store) se richiesti da Sideloadly.
2. Collega l'iPhone al PC, tocca "Autorizza" sull'iPhone.
3. Apri Sideloadly, trascina l'IPA, inserisci il tuo Apple Account, premi "Start".
4. iPhone: Impostazioni > Generali > VPN e gestione dispositivo > tocca il tuo ID > "Autorizza".
   (Se richiesto: Impostazioni > Privacy e sicurezza > Modalità sviluppatore > attiva e riavvia.)
5. Impostazioni > Generali > Tastiera > Tastiere > Aggiungi nuova tastiera > "Rune Keyboard".
6. In un'app tocca il globo finché appare la tastiera runica.

## Se la tastiera non compare / non si seleziona
- Controlla che l'estensione sia stata installata insieme all'app (Sideloadly deve firmare anche l'estensione).
- Nel log di GitHub cerca "OK: estensione incorporata": se manca, la build è sbagliata.

## Se le rune appaiono come quadrati
Dipende dal font di sistema: dimmelo e aggiungo un font runico incorporato.
