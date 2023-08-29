# csOrdineOS
Sistema operativo per cs-ordini

# Configurazione automatica del server

Questo script automatizza il processo di configurazione di un nuovo server, inclusi l'utente, il dominio, l'autenticazione a due fattori e altre impostazioni. È stato progettato per semplificare il processo di avvio di un nuovo server, ma è importante utilizzarlo con attenzione e verificare attentamente tutte le variabili e le impostazioni prima di eseguirlo.

**Nota:** Questo script è stato creato per scopi didattici e di esempio. Si consiglia vivamente di comprenderne il funzionamento prima di utilizzarlo su un ambiente di produzione.

## Prerequisiti

- Un sistema operativo basato su Linux (testato su Ubuntu).
- Privilegi di amministratore (root) per eseguire lo script.

## Utilizzo

1. Scarica il repository o copia il contenuto dello script nel tuo server.
2. Apri un terminale e spostati nella directory contenente lo script.
3. Esegui il comando `bash install_ubuntu_server.sh` per avviare lo script.
4. Segui le istruzioni interattive per inserire le informazioni richieste.

## Funzionalità principali

- Impostazione dell'indirizzo IP del server.
- Configurazione del dominio/hostname.
- Creazione di un nuovo utente con le autorizzazioni necessarie.
- Impostazione dell'utente per l'autenticazione a due fattori utilizzando Google Authenticator.
- Impostazione della lingua e della timezone.
- Aggiornamento del sistema operativo e pulizia della cache.
- Configurazione di SSH per limitare l'accesso root e aumentare la sicurezza.
- Installazione di Docker e aggiunta dell'utente al gruppo "docker".

## Avvertenze

- Assicurati di comprendere tutte le variabili e le impostazioni dello script prima dell'esecuzione.
- Verifica attentamente che le variabili siano definite correttamente per evitare problemi.
- Esegui lo script su un ambiente di test prima di utilizzarlo su un sistema in produzione.
- L'autenticazione a due fattori può essere critica per la sicurezza. Verifica attentamente questa parte dello script.

## Contributi

Suggerimenti e contributi sono benvenuti! Sentiti libero di aprire una richiesta di pull o segnalare problemi se trovi bug o vuoi migliorare lo script.

## Licenza

Questo script è distribuito con licenza [GNU Affero General Public License (GNU AGPL)](LICENSE).
