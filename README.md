# Bash-Linux-Post-Install-Config

Projekt rješava problem post instalacijske konfiguracije Linux sustava korištenjem Bash skriptnog jezika. Skriptaje razvijena na način da ne zahtjeva interakciju sa korisnikom nakon pokretanja što je odlično za "pokreni i ostavi" korištenje kod direktne instalacije, ali, bitnije, omogučava korištenje ove skripte uz autmatizirane sustave virtualizacije poput OpenStack i Docker alata.

Ova skripta rješava probleme:

..* instalacije programa - Prvi korak nakon instalacije Linux sustava je preuzimanje alata koji su nam potrebni za daljnji rad. Skripta omogućava odabir programa podijeljenih u razne grupe - razvojni alati, alati za emulaciju, alati za virtualizaciju i alati za media playback. Radi ovoga, moguće je odabrati koje "grupe" alata ćemo instalirati, ovisno o računalo na koje instaliramo. (Napomena, alati u skripti su alati koje ja osobno koristim i lako se mogu zamjeniti smislenijim programima)

..* Preuzimanje konfiguracijskih datoteka - čest problem sa kojim sam se ja susreo kod instalacije novog linux sustava je ponovno postavljanje alata koje sam ranije koristio. Na Linux sustavima se konfiguracije večine alata nalaze u direktoriju /home/user/.config/. Ova skripta ima mogućnost preuzimanja tih postavki iz repozitorija koji je korisnik ranije postavio i njihovo kopiranje u odgovarajuću datoteku. Tako će programi koje smo upravo instalirali imati poznate postavke pri prvom pokretanju.

..* Dodavanje korisnika - kod instalacije večine Linux distribucija moguće je tijekom instalacije dodati jednog, glavnog, korisnika. No, često nam je potrebno nekoliko korisnika - ako je računalo djeljeno, ili veliki broj korisnika ukoliko se radi o serveru. Ova skripta omogučava isčitavanje korisnčkih imena i lozinka iz text datoteke, bez obzira na broj korisnika i dodavanje tih korisnika u sustav.

## Preuzimanje

Skripta se može preuzeti Github Download funkcijom ugrađenom u stranicu ili pokretanjem naredbe

```bash
config.sh -i demw -u users.txt -c https://github.com/ssegota/config-files
```

Instalacija nije potrebna, već samo treba skriptu pokrenuti.

## Pokretanje

Skripta se može pokrenuti sa jednom ili više opcija. Za informacije o pokretanju možremo koristiti -h flag

```bash
bash config.sh -h
```

Ovo će nam dati uputstva za pokretanje. 

Primjer pokretanja sa svim opcijama je:

```bash
sudo bash config.sh -i demw -u users.txt -c https://github.com/ssegota/config-files
```

Kako skripta izgleda tokom pokretanja, kao i dodatne informacije o skripti vidljive su na: <https://www.youtube.com/watch?v=QcEjs2nLIAs>

Zahvaljujem na čitanju!
