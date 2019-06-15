## Hello, World!

Nu när du installerat Rust, låt oss skriva ditt först Rust-program. Det är en
tradition när man lär sig ett nytt språk att skriva ett litet program som
skriver ut texten `Hello, world!` på skärmen, så vi gör samma sak här!

> Notera: Denna bok förutsätter grundläggande bekantskap med kommandoraden.
> Rust har inga specifika krav på hur du redigerar eller verktyg där din kod
> finns, så om du föredrar att använda en integrerad utvecklingsmiljö
> (Integrated Development Environment, IDE) istället för kommandoraden så
> använd din favorit IDE. Många IDE:er har någon form av Rust-stöd; kontrollera
> IDE:ns dokumentation för detaljer. Rust-gruppen har nyligen fokuserat på att
> möjliggöra bra IDE-stöd och framstegen har gått snabbt på den fronten!

### Skapa en projektkatalog

Du börjar med att skapa en katalog att lagra din Rust-kod i. Det spelar Rust
ingen roll var din kod finns, men för övningar och projekt i denna bok föreslår
vi att du skapar en katalog med namnet *projects* i din hemkatalog och håller
alla dina projekt där.

Öppna en terminal och mata in följande kommando för att skapa en katalog med
namnet *projects* och en katalog för Hello, World!-projektet inuti
*projects*-katalogen.

För Linux, macOS och PowerShell under Windows, mata in detta:

```text
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

För Windows CMD, mata in detta:

```cmd
> mkdir "%USERPROFILE%\projects"
> cd /d "%USERPROFILE%\projects"
> mkdir hello_world
> cd hello_world
```

### Skriva och köra ett Rust-program

Nästa steg är att skapa en källkodsfil och kalla den *main.rs*. Rust-filer
slutar alltid med filändelsen *.rs*. Om du använder mer än ett ord i ditt
filnamn, använd ett understreck för att separera dem. Använd till exempel
hellre *hello_world.rs* än *helloworld.rs*.

Öppna nu filen *main.rs* som du nyss skapade och mata in koden i listning 1-1.

<span class="filename">Filnamn: main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

<span class="caption">Listning 1-1: Ett program som skriver ut `Hello, world!`</span>

Spara filen och gå tillbaka till ditt terminalfönster. Under Linux eller macOS,
mata in följande kommandon för att kompilera och köra filen:

```text
$ rustc main.rs
$ ./main
Hello, world!
```

Under Windows mata in kommandot `.\main.exe` istället för `./main`:

```powershell
> rustc main.rs
> .\main.exe
Hello, world!
```

Oavsett vilket operativsystem du har bör stränge `Hello, world!` skrivas ut
på terminalen. Om du inte ser denna utmatning, gå tillbaka till 
[”Felsökning”][felsokning]<!-- ignore --> under installationsavsnittet för att
hitta sätt att få hjälp.

Om `Hello, world!` skrevs ut; grattis! Du har officiellt skrivit ett
Rust-program. Det gör dig till en Rust-utvecklare, välkommen!

### Ett Rust-programs anatomi

Låt oss i detalj gå igenom vad som nyss hände i ditt Hello, world!-program. Här
är den första delen av pusslet:

```rust
fn main() {

}
```

Dessa rader definierar en funktion i Rust. `main`-funktionen är speciell: den är
alltide den första koden som kör i varje körbart Rust-program. Den första raden
deklarerar en funktion med namnet `main` som inte har några parametrar och inte
returnerar något. Om det hade funnits parametrar hade dessa placerats inom
parenteserna `()`.

Notera också att funktionskroppen är omgiven av klammerparenteser, `{}`. Rust
kräver dessa runt alla funktionskroppar. Det är god stil att placera den
inledande klammerparentesen på samma rad som funktionsdeklarationen, efter ett
blanksteg.

När detta skrivs håller ett automatiskt formateringsverktyg kallat `rustfmt` på
att utvecklas. Om du vill hålla dig till standardstilen för alla Rust-projekt
kommer `rustfmt` att formatera din kod enligt en särskild stil. Rust-gruppen
planerar att eventuellt inkludera detta verktyg med Rusts standarddistribution,
precis som `rustc`. Så beroende på när du läser denna bok, kanske verktyget
redan finns på din dator~ Kontrollera dokumentationen på internet för vidare
information.

Inuti `main`-funktionen finns följande kod:

```rust
    println!("Hello, world!");
```

Denna rad gör allt arbete i detta lilla program: den skriver ut texten på
skärmen. Det finns fyra viktiga detaljer att lägga märket till här. För det
första tillhör det Rusts kodningsstil att indentera med fyra blanksteg, inte
med en tabb.

För det andra anropar `println!` ett Rust-makro. Om det hade anropat en
funktion istället så hade det skrivits som `println` (utan utropstecknet `!`).
Vi kommer att diskutera Rust-makron i detalj i kapitel 19. Tills vidare behöver
du bara veta att användning av `!` innebär att du anropar ett makro snarare än
en normal funktion.

För det tredje, se strängen `"Hello, world!"`. Vi skickar denna sträng som ett
argument till `println!` och strängen skrivs ut på skärmen.

För det fjärde, vi avslutar raden med ett semikolon (`;`), vilket indikerar att
detta uttryck är över och att nästa kan påbörjas. De flesta kodrader i Rust
avslutas med ett semikolon.

### Att kompilera och att köra är separata steg

Du har kört ett nyss skapat program, så låt oss undersöka varje steg i
processen.

Innan du kör ett Rust-program måste du kompilera det med Rust-kompilatorn genom
att köra `rustc`-kommandot och skicka med namnet på din källkodsfil, så här:

```text
$ rustc main.rs
```

Om du har bakgrund inom C eller C++ så ser du säkert att detta sker på liknande
sätt som med `gcc` eller `clang`. Efter kompileringen avslutats framgångsrikt
kommer Rust att mata ut en körbar binärfil.

Under Linux, macOS och med PowerShell under Windows kan du se den körbara filen
genom att mata in kommandot `ls` i ditt skal. Under Linux och macOS kommer du
att se två filer. Med PowerShell under Windows kommer du att se samma tre
filer som du hade sett om du hade använt CMD.

```text
$ ls
main  main.rs
```

Med CMD under Windows matar du in följande:

```cmd
> dir /B %= the /B option says to only show the file names =%
main.exe
main.pdb
main.rs
```

Detta visar källkodsfilen med filändelsen *.rs*, den körbara filen (*main.exe*
under Windows, men *main* för alla andra plattformar), och under Windows en fil
som innehåller felsökningsinformation med filändelsen *.pdb*. Du kan nu köra
den körbara filen *main* eller *main.exe* på detta sätt:

```text
$ ./main # or .\main.exe on Windows
```

Om *main.rs* är ditt Hello, world!-program kommer detta att skriva ut `Hello,
world!` på din terminal.

Om du är mer bekant med ett dynamiskt språk så som Ruby, Python eller
JavaScript kanske du inte är van vid kompilering och att köra ett program som
separata steg. Rust är ett språk som använder kompilering-innan-körning, vilket
innebär att du kan kompilera ett program och ge den körbara filen till någon
annan och de kan köra programmet utan att ens ha Rust installerat. Om du ger
någon en *.rb*-, *.py*- eller *.js*-fil måste de ha en Ruby-, Python- eller
JavaScript-implementation installerad. Men för de språken behöver du bara ett
kommando för att kompilera och köra ett program. Allting är en avvägning inom
språkdesign.
 
Att kompilera med enbart `rustc` går bra för enkla kommandon, men allt efter
dina projekt växer kommer du att vilja hantera alla alternativ och göra det
enkelt att dela din kod. Här näst kommer vi att introducera verktyget Cargo,
som kommer att hjälpa dig att skriva riktiga Rust-program.

[felsokning]: ch01-01-installation.html#troubleshooting
