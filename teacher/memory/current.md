# Stato corrente

Ultimo aggiornamento: 2026-11-16 (riordino del framework, nessuna lezione)
Ultima sessione di studio: 2026-02-28

## Dove siamo

- Ultimo esercizio completato: `19_charpadTilemap.asm` (mappa CharPad a schermo), con la variante `19a_charpadTilemap_selfmod.asm`.
- Ultima sessione: quiz su indirizzamento, lookup table e aritmetica a 16 bit (`quiz/addressing.asm`, `study/math.md`).

## Prossimi passi

1. La pausa dall'ultima sessione è lunga: si riparte da un ripasso dell'esercizio 19 e dei concetti con score più basso.
2. Ripasso mirato di aritmetica a 16 bit: ASL/ROL, somme con carry, moltiplicazione shift-and-add. Lo studente ha detto "dobbiamo tornare su tutti i concetti".
3. Quiz 9 sui colori del Text Multicolour, rimasto in sospeso dal 2026-02-26.
4. Esercizio 20: sprite che si muove sull'aula con collisioni via material. La lezione in `teacher/lessons/` è da preparare, divisa in passi da due concetti nuovi al massimo.
5. SID Factory II: capiti ADSR e le tabelle Wave, Pulse, Filter e Arpeggio; restano HR table, Tempo table, Init table, Commands e la costruzione di un suono pratico.

## Preferenze dello studente

- Vuole scrivere il codice da solo: struttura con TODO e hint progressivi, mai l'esercizio già risolto.
- Vuole capire il perché oltre al come.
- Note di studio: non creare file separati per i sotto-argomenti, integrare nei file `study/` esistenti.
- Grafica: Text Multicolour anziché Hi-Res; stile top-down pseudo-3D (muri con la facciata visibile dall'alto). La scena dell'esercizio 19 è un'aula.
- SID Factory II: usa il driver 11.
- Il 2026-02-26, sessione serale da stanco, ha preferito i quiz al coding.

## Difficoltà aperte

- Aritmetica a 16 bit con shift (ASL/ROL, ADC con carry): molta fatica, completata solo con guida intensiva.
- Loop multi-pagina con puntatori in zero page: distinzione tra pagina e riga.
- Confusione tra esadecimale e decimale (`$0960` non è 960).
- Bit invertiti di `$DD00` nella selezione del bank.
- Flag multicolour per carattere: serve un colore >= 8 nella Colour RAM.
