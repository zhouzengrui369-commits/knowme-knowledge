# Real interaction steps

All operations use exact HTML fff5fe152c204471263a97d9753a09317dea2d08e4aec585ab25dff5b5eaf539 at 360x780. Synthetic data only. Screenshots are reviewer originals. Expected/actual: disclosure fully readable, click changes ON/PAUSED, resume restores ON; all five passed.

1. Cold open 01; Knowledge 02; click Pause 03; click Resume 04.
2. Expand work records; select AOG knowledge detail 05; click Pause 06; click Resume 07.
3. Open contextual work 08; click Pause 09; click Resume 10; one click Return Agent 11.
4. Calendar 12; click Pause 13; click Resume 14; close Calendar.
5. Todo 15; click Pause 16; click Resume 17.
6. Complete first Todo 18; click its date link to Calendar 19; week 20; month 21; click day17 22; complete installation review23.
7. Capture mint text; generate candidate24; Correct title/body; Save correction25 (still CANDIDATE); explicit Confirm26 (knowledge6 to7).
8. Natural mint question; waiting27 then own-content answer28; next action enters detail29; Open contextual work30; one click Return Agent31 (question/answer preserved).
9. Capture pottery text32; explicit Confirm (knowledge7 to8); natural pottery question; own-content answer33.
10. Knowledge: expand zero life dimension34; expand nine-dimension dynamic35; scroll body36 shows both new entries and persistent header.
11. Pause in Knowledge; select mint detail37 (PAUSED); open work38 (PAUSED); one click Return Agent39 (PAUSED and conversation intact).
12. Calendar40 retains PAUSED and completed event; close; Todo41 retains PAUSED and completed task; click Resume; close to Agent42 (ON, questions intact).

No hover, horizontal scroll, app-state injection or hidden DOM text was used to meet visual acceptance. AX snapshots in interaction.json supplement visual screenshots. Semantic Playwright clicks and native AX/pointer clicks were used; no JavaScript .click().

User interpretation: boundaries stayed legible while working; correction and confirmation were distinguishable; topic-specific answers were traceable; both return paths preserved context. No critical blocker observed within sampled scope.
