# Programmera ett gissningsspel

Låt oss komma in i Rust genom att arbeta genom ett praktiskt projekt
tillsammans! Detta kapitel introducerar dig till ett antal vanliga Rust-koncept
genom att visa dig hur du använder dem i ett riktigt program. Du kommer att
lära dig om `let`, `match`, metoder, associerade funktioner, använda externa
crates, med mera! Följande kapitel kommer att utforska dessa idéer i detalj. I
detta kapitel kommer du att öva på de grundläggande stegen.

Vi kommer att implementera ett klassiskt problem för nybörjarprogrammerare: ett
gissningsspel. Så här fungerar det: programmet kommer att generera ett
slumpmässigt heltal mellan 1 och 100. Det kommer därefter att be spelaren att
mata in en gissning. Efter att en gissning matats in kommer programmet att
indikera huruvida gissningen är allt för låg eller om den är för hög. Om
gissnings är korrekt kommer spelet att skriva ut ett gratulationsmeddelande och
avslutas.

## Sätt upp ett nytt projekt

För att sätta upp ett nytt projekt, gå till *projekt*-katalogen som du skapade
i kapitel 1 och skapa ett nytt projekt med hjälp av Cargo, så här:

```text
$ cargo new guessing_game
$ cd guessing_game
```

Det första kommandot `cargo new`, tar projektets namn (`guessing_game`) som
första argument. Det andra kommandot byter till det nya projektets katalog.

Titta på den genererade *Cargo.toml*-filen:

<span class="filename">Filnamn: Cargo.toml</span>

```toml
[package]
name = "guessing_game"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
edition = "2018"

[dependencies]
```

Om upphovsmansinformationen som Cargo fått från din miljö inte stämmer, åtgärda
den i den filen och spara den på nytt.

Som du såg i kapitel 1 skapar `cargo new` ett ”Hello, world!”-program åt dig.
Checka ut filen *src/main.rs*:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

Låt oss nu kompilera detta ”Hello, world!”-program och köra det i samma steg
genom att använda `cargo run`-kommandot:

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50 secs
     Running `target/debug/guessing_game`
Hello, world!
```

`run`-kommandot är praktiskt när du snabbt måste iterera ett projekt, så som
vi kommer att göra med detta spel -- snabbt testa varje iteration innan vi går
vidare till nästa.

Återöppna filen *src/main.rs*. Du kommer att skriva all kod i denna fil.

## Hantera en gissning

Den första delen av programmet som utgör gissningsspelet är att efterfråga
användarinmatning, hantera denna inmatning och kontrollera att inmatningen
följer den förväntade formen. Till att börja kommer vi att låta spelaren mata
in en gissning. Mata in koden i listning 2-1 i *src/main.rs*.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
use std::io;

fn main() {
    println!("Guess the number!");

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
```

<span class="caption">Listning 2-1: Kod som hämta en gissning från användaren
och skriver ut den</span>

Denna kod innehåller en massa information, så låt oss gå igenom den rad för
rad. För att få tag i användarinmatning och sedan skriva ut resultatet som
utmatning måste vi ta in `io`-biblioteket (in-/utmatning) inom räckvidd.
`io`-biblioteket kommer från standardbiblioteket (vilket kallas `std`):

```rust,ignore
use std::io;
```

Som standard så tar Rust endast in ett fåtal typer inom räckvidd för för varje
program i [inledningen som kallas prelude][prelude]<!-- ignore -->. Om en typ
du vill använda inte finns i prelude:n måste du uttryckligen ta in den typen
inom räckvidd genom en `use`-sats. Att använda `std::io`-biblioteket
tillgängliggör ett antal användbara funktioner, inklusive möjligheten att läsa
in användarinmatning.

[prelude]: ../std/prelude/index.html

Som du såg i kapitel 1 är `main`-funktionen ingångspunkten i programmet:

```rust,ignore
fn main() {
```

Syntaxen `fn` deklarerar en ny funktion, parenteserna, `()`, indikerar att det
inte finns några parametrar och klammerparentesen, `{`, påbörjar
funktionskroppen.

Som du redan lärt dig i kapitel 1 är `println!` ett makro som skriver ut en
sträng på skärmen:

```rust,ignore
println!("Guess the number!");

println!("Please input your guess.");
```

Denna kod skriver ut en uppmaning som berättar vad spelet går ut på och begär
inmatning från användaren.

### Lagra värden med variabler

Härnäst ska vi skapa en plats att spara användarinmatningen, så här:

```rust,ignore
let mut guess = String::new();
```

Nu börjar programmet bli intressant! Det finns mycket som händer på den här
lilla raden. Notera att det är en `let`-sats, vilken används för att skapa en
*variabel*, Här är ett annat exempel:

```rust,ignore
let foo = bar;
```

Denna rad skapar en ny variabel med namnet `foo` och binder den till värdet som
`bar`-variabeln har. I Rust är variabler oföränderliga som standard. Vi kommer
att diskutera detta koncept i detalj i avsnittet [”Variabler och
föränderlighet”][variabler-och-föränderlighet]<!-- ignore --> i kapitel 3.
Följande exempel visar hur man använder `mut` före variabelns namn för att göra
en variabel föränderlig:

```rust,ignore
let foo = 5; // oföränderlig
let mut bar = 5; // föränderlig
```

> Notera: Syntaxen `//` påbörjar en kommentar som fortsätter tills slutet av
> raden. Rust hoppar över allting i kommentarer, vilka diskuteras i detalj i
> kapitel 3.

Låt oss återgå till gissningsspelsprogrammet. Du vet nu att `let mut guess`
kommer att introducera en föränderlig variabel med namnet `guess`. På andra
sidan av likhetstecknet (`=`) finns värdet som `guess` binds till, vilket är
resultatet av att anropa `String::new`, en funktion som returnerar en ny
instans av en `String`. [`String`][string]<!-- ignore --> är en strängtyp som
tillhandahålls av standardbiblioteket och som är en växbar bit UTF-8 kodad
text.

[string]: ../std/string/struct.String.html

Syntaxen `::` på raden `::new` indikerar att `new` är en *associerad funktion*
till `String`-typen. En associerad funktion implementeras för en typ, i detta
fall `String`, snarare än för en särskild instans av en `String`. Vissa språk
kallar detta för en *statisk metod*.

Denna `new`-funktion skapar en ny, tom sträng. Du kommer att hitta
`new`-funktionen hos många typer, då detta är ett vanligt namn för en funktion
som skapar en ny variabel av något slag.

För att sammanfatta, så skapar raden `let mut guess = String::new();` en
föränderlig variabel som för närvarande är bundet till en ny tom instans av en
`String`. Puh!

Kom ihåg att vi inkludera in-/utmatningsfunktionalitet från standardbiblioteket
med `use std::io;` på den första raden i programmet. Vi kommer nu att anropa
`stdin`-funktionen från `io`-modulen:

```rust,ignore
io::stdin().read_line(&mut guess)
    .expect("Failed to read line");
```

Om vi inte hade haft raden `use std::io` i början av programmet så kunde vi ha
skrivit detta funktionsanrop som `std::io::stdin`. `stdin`-funktionen
returnerar en instans av [`std::io::Stdin`][iostdin]<!-- ignore -->, vilket är
en typ som representerar ett handtag till standard in för din terminal.

[iostdin]: ../std/io/struct.Stdin.html

Nästa del av koden, `.read_line(&mut guess)` anropar metoden
[`read_line`][read_line]<!-- ignore --> på standard in-handtaget för att hämta
inmatning från användaren. Vi skickar också ett argument till `read_line`:
`&must guess`.

[read_line]: ../std/io/struct.Stdin.html#method.read_line

Jobbet för `read_line` är att ta vad än användaren skriver in på standard in
och placera det i en sträng, så den tar denna sträng som ett argument.
Strängargumentet måste vara föränderligt så att metoden kan ändra strängens
innehåll genom att lägga till användarinmatningen.

`&` indikerar att detta argument är en *referens*, vilket ger dig ett sätt att
låta flera delar av din kod få till gång till ett stycke data utan att behöva
kopiera denna data till minnet flera gången. Referenser är komplex
funktionalitet och en av Rusts stora fördelar är hur säkert och enkelt det är
att använda referenser. Du behöver inte känna till de detaljerna för att
slutföra detta program. Tills vidare är allt du behöver veta att på samma sätt
som variabler så är referenser oföränderliga som standard. Således måste du
skriver `&mut guess` snarare än `&guess` för att göra den föränderlig. (Kapitel
4 kommer att förklara referenser mer ingående.)

### Hantera eventuella fel med `Result`-typen

Vi är inte helt färdiga med denna rad kod. Även om vad vi diskuterat så här
långt är en enstaka rad kod är det endast den första delen av en enda logisk
rad kod. Den andra delen är denna metod:

```rust,ignore
.expect("Failed to read line");
```

När du anropar en metod med `.foo()`-syntaxen är det ofta bra att infoga en
nyrad och andra blanktecken för att hjälpa till att bryta upp långa rader. Vi
skulle kunna ha skrivit koden så här:

```rust,ignore
io::stdin().read_line(&mut guess).expect("Failed to read line");
```

Men en lång rad är svårläst, så det är bättre att dela upp den: två rader för
två metodanrop. Låt oss nu diskutera vad denna rad gör.

Som vi nämnt tidigare placerar `read_line` vad användaren matar in i strängen
vi anger, men den returnerar också ett värde -- i detta fall ett
[`io::Result`][ioresult]<!-- ignore -->, Rust har ett antal typer med namnet
`Result` i sitt standardbibliotek: ett generellt [`Result`][result]<!-- ignore
--> så väl som specifika versioner för undermoduler så som `io::Result`.

[ioresult]: ../std/io/type.Result.html
[result]: ../std/result/enum.Result.html

`Result`-typer är [*uppräkningar*][enums]<!-- ignore --> (enumerations), vilket
ofta kallas *enum:mar*. En uppräkning är en typ som kan anta ett begränsat
antal värden, och de värdena kallas för enum:mens *varianter*. Kapitel 6 kommer
att förklara enum:mar mer ingående.

[enums]: ch06-00-enums.html

För `Result` är varianteran `Ok` eller `Err`. `Ok`-varianten indikerar att
operationen var framgångsrik och inuti `Ok` finns det framgångsrikt genererade
värdet. `Err`-varianten innebär att operationen misslyckades och `Err`
innehåller information om hur eller varför operationen misslyckades.

Syftet med detta `Result`-typer är att koda information för felhantering.
Värden av `Result`-typen har, precis som värden av vilken typ som helst,
definierade metoder. En instans av `io::Result` har en
[`expect`-metod][expect]<!-- ignore --> som du kan anropa. Om denna instans av
`io::Result` är ett `Err`-värde kommer `expect` att orsaka att programmet
kraschar och skriver ut meddelandet som du angett som argument till `expect`.
Om `read_line`-metoden returnerar ett `Err` är det troligtvis resultatet av
ett fel som kommer från det underliggande operativsystemet. Om denna instans av
`io::Result` är ett `Ok`-värde kommer `expect` att ta returvärdet som `Ok`
innehåller och returnera precis detta värde så att du kan använda det. I detta
fall är värdet antalet byte som användaren matade in på standard in.

[expect]: ../std/result/enum.Result.html#method.expect

Om du inte anropar `expect`, kommer programmet att kompilera, men du får en
varning:

```text
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
warning: unused `std::result::Result` which must be used
  --> src/main.rs:10:5
   |
10 |     io::stdin().read_line(&mut guess);
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   |
   = note: #[warn(unused_must_use)] on by default
```

Rust varnar för att du inte har använd `Result`-värdet som returneras från
`read_line`, vilket indikerar att programmet inte hanterat ett möjligt fel.

Det rätta sättet att undertrycka varningen på är att faktiskt skriva
felhantering, men om du bara vill att programmet ska krascha när ett program
uppstår kan du använda `expect`. Du kommer att lära dig hur man återhämtar sig
från fel i kapitel 9.

### Skriva ut värden med `println!`-platshållare

Förutom den avslutande klammerparentesen finns det i koden, så här långt, bara
en rad kvar att diskutera, vilken är följande:

```rust,ignore
println!("You guessed: {}", guess);
```

Denna rad skriver ut strängen vi sparade användarens inmatning i.
Klammerparenteserna, `{}`, är en platshållare: tänk på `{}` som en krabbklo
som håll håller ett värde på plats. Du kan skriva ut mer än ett värde genom att
använda klammerparenteser: den första uppsättningen klammerparenteser håller
det första värdet listat efter formatsträngen, den andra uppsättningen håller
det andra värdet, och så vidare. Att skriva ut flera värden i ett enda anrop
hade sett ut så här:

```rust
let x = 5;
let y = 10;

println!("x = {} and y = {}", x, y);
```

Denna kod skriver ut `x = 5 and y = 10`.

### Testa den första delen

Låt oss testa den första delen av gissningsspelet. Kör det via `cargo run`:

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
     Running `target/debug/guessing_game`
Guess the number!
Please input your guess.
6
You guessed: 6
```

Vid den här punkten är den första delen av spelet klar: vi hämtar inmatning
från tangentbordet och skriver sedan ut den.

## Generera ett hemligt tal

Härnäst måste vi generera ett hemligt tal som användaren ska försöka att gissa.
Det hemliga talet bör vara ett nytt tal varje gång så att spelet är kul att
spela mer än en gång. Låt oss använda ett slumptal mellan 1 och 100 så att
spelet inte blir allt för svårt. Rust inkluderar inte funktionalitet för
slumptal i sitt standardbibliotek än. Men Rust-gruppen tillhandahåller en
[`rand`-crate][randcrate].

[randcrate]: https://crates.io/crates/rand

### Använda en crate för att få mer funktionalitet

Kom ihåg att en crate är en samling Rust-källkodsfiler. Projektet vi håller på
att bygga är en *binär crate*, vilket är en körbar fil. `rand`-crate:n är en
*biblioteks-crate*, vilken innehåller kod avsedd att användas i andra program.

Cargos användning av externa crate:ar är där det är som bäst. Innan vi kan
skriva kod som använder `rand` måste vi modifiera *Cargo.toml*-filen att
inkludera `rand`-crate:n som ett beroende. Öppna den filen nu och lägga till
följande rad på slutet under avsnittsrubriken `[dependencies]` som Cargo
skapade åt dig:

<span class="filename">Filnamn: Cargo.toml</span>

```toml
[dependencies]

rand = "0.3.14"
```

I *Cargo.toml*-filen tillhör allting efter en rubrik ett avsnitt som fortsätter
till nästa avsnitt börjar. `[dependendencies][`-avsnittet är där du berättar
för Cargo vilka externa crate:ar ditt projekt beror på och vilka versioner av
dessa crate:ar du kräver. I detta fall kommer vi att ange `rand`-crate:n med
den semantiska versionsangivningen `0.3.14`. Cargo förstår [Semantisk
versionering][semver]<!-- ignore --> (vilket ibland kallas *SemVer*), det är en
standard för att skriva versionsnummer. Numret `0.3.14` är en förkortning för
`^0.3.14` vilket betyder ”vilken version som helst som har ett publikt
API-kompatibelt med version 0.3.14”.

[semver]: http://semver.org

Låt oss nu, utan att ändra på någon kod, bygga projektet så som visas i
listning 2-2.

```text
$ cargo build
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading rand v0.3.14
 Downloading libc v0.2.14
   Compiling libc v0.2.14
   Compiling rand v0.3.14
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

<span class="caption">Listning 2-2: Utmatningen från att köra `cargo build`
efter att ha lagt till rand-craten:n som ett beroende</span>

Du kan komma att se olika versionsnummer (men de kommer alla att vara
kompatibla med koden, tack vare SemVer!), och raderna kan komma i olika
ordning.

Nu när vi har ett externt beroende kommer Cargo att hämta de senaste
versionerna av allting från *registret*, vilket är en kopia av data från
[Crates.io][cratesio]. Crates.io är där personer i Rust-ekosystemet postar sina
öppna källkodsprojekt som använder Rust så att andra kan använda dem.

[cratesio]: https://crates.io

Efter att ha uppdaterat registret kontrollerar Cargo avsnittet `[dependencies]`
och hämtar de crate:er du inte har än. I detta fallet hämtade Cargo också en
kopia av `libc`, trots att vi bara listade `rand` som ett beroende, eftersom
`rand` beror på `libc` för att fungera. Efter att ha hämtat crate:erna
kompilerar Rust dem och bygger sedan projektet med de tillgängliga beroendena.

Om du omedelbart kör `cargo build` igen utan att göra några ändringar kommer du
inte att få någon utmatning förut raden `Finished`. Cargo vet att det redan har
hämtat och kompilerat beroendena och du har inte ändrat något som rör dem i din
*Cargo.toml*-fil. Cargo vet också att du inte har ändrat något i din kod så den
kommer inte att kompilera den heller. Då det inte finns något att göra kommer
den helt enkelt att avsluta.

Om du öppnar din *src/main.rs*-fil, gör en trivial ändring och sedan sparar den
och bygger på nytt kommer du endast att se två raders utmatning:

```text
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

Dessa rader visar att Cargo endast uppdaterar bygget med dina små ändringar i
*src/main.rs*-filen. Dina beroenden har inte ändrats så Cargo vet att det kan
återanvända det som den redan hämtat och kompilerat. Den bygger bara om din
del av koden.

#### Säkerställ reproducerbara byggen med *Cargo-lock*-filen

Cargo har en mekanism som säkerställer att du kan bygga om samma artefakt
varje gång du eller någon annan bygger din kod: Cargo kommer endast att
använda de versionerna av beroendena du angett tills du indikerar något annat.
Vad händer t.ex. om version 0.3.15 av `rand`-crate:n kommer ut nästa vecka och
innehåller en viktig programfix men som också innehåller en regression som
kommer att bryta din kod?

Svaret på detta problem är *Cargo.lock*-filen, vilken skapades första gången du
körde `cargo build` och finns nu i din *guessing_game*-katalog. När du bygger
ett projekt för första gången listar Cargo ut alla versionerna av beroendena
som passar kriterierna och skriver sedan ner dem i *Cargo.lock*-filen. När du
bygger ditt projekt i framtiden kommer Cargo att se att *Cargo.lock*-filen
existerar och använda de versioner som anges där snarare än att på nytt göra
allt arbete med att lista ut vilka versioner som passar. Med andra ord kommer
ditt projekt, tack vare *Cargo.lock*-filen, att kvarstå på `0.3.14` tills du
uttryckligen uppgraderar.

#### Uppdatera en crate för att få en ny version

När du *vill* uppdatera en crate erbjuder Cargo ett annat kommando, `update`,
som kommer att hoppa över *Cargo.lock*-filen och lista ut vilka alla de senaste
versionerna är som passar dina specifikationer i *Cargo.toml*. Om det fungerar
kommer Cargo att skriva de versionerna i *Cargo.lock*-filen.

Men som standard kommer Cargo endast att leta efter versioner större än `0.3.0`
och mindre än `0.4.0`. Om `rand`-crate:n har släppt två nya versioner, `0.3.15`
och `0.4.0` hade du sett följande om du hade kört `cargo update`:

```text
$ cargo update
    Updating registry `https://github.com/rust-lang/crates.io-index`
    Updating rand v0.3.14 -> v0.3.15
```

Vid den här punkten kommer du också att notera en ändring i din
*Cargo.lock*-file som noterar att versionen av `rand`-crate:n du nu använder är
`0.3.15`.

Om du skulle vilja använda `rand` version `0.4.0` eller en senare version i
`0.4.x`-serien måste du uppdatera *Cargo.toml*-filen så att sen ser ut så här:

```toml
[dependencies]

rand = "0.4.0"
```

Nästa gång du köra `cargo build` kommer Cargo att uppdatera registret över
tillgängliga crate:ar och omvärdera dina `rand`-krav enligt den nya versionen
du har angett.

Det finns mycket mer att säga om [Cargo][doccargo]<!-- ignore --> och [dess
ekosystem][doccratesio]<!-- ignore --> vilket vi kommer att diskutera i kapitel
14, men tills vidare är det allt du behöver veta. Cargo gör det enkelt att
återanvända bibliotek, så Rust-användare kan skriva små projekt som byggs ihop
av ett antal olika paket.

[doccargo]: http://doc.crates.io
[doccratesio]: http://doc.crates.io/crates-io.html

### Generera ett slumptal

Nu när du har lagt till `rand`-crate:n i *cargo.toml*, låt oss börja använda
`rand`. Nästa steg är att uppdatera *src/main.rs* enligt listning 2-3.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
use std::io;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
```

<span class="caption">Listning 2-3: Lägg till kod för att generera ett
slumptal</span>

Allra först ska vi lägga till en `use`-rad: `use rand::Rng`. Egenskapen `Rng`
definierar metoder som slumptalsgeneratorn implementerar och denna egenskap
måste vara inom räckvidd för att låta oss använda dessa metoder. Kapitel 10
kommer att gå in i detalj kring egenskaper.

Nästa steg är att lägga till två rader i mitten. Funktionen `rand::thread_rng`
kommer att ge oss den specifika slumptalsgeneratorn som vi kommer att behöva:
en som är lokal till den aktuella körtråden och den har fått ett frö av
operativsystemet. Denna metod definieras av egenskapen `Rng` som vi tog in inom
räckvidd med satsen `use rand::Rng`. Metoden `gen_range` tar två tal som
argument och generera ett slumptal mellan dessa. Vid den nedre gränsen är
intervallet stängt, men det är öppet i vid den övre gränsen, så vi måste ange
`1` och `101` till anropet för att begära ett tal mellan 1 och 100.

> Notera: Det går inte att bara veta vilka egenskaper man ska använda och vilka
> metoder och funktioner som man kan anropa från en crate. Instruktioner för
> att använda en crate finns i varje crate:s dokumentation. En annan fiffig
> funktion hos Cargo är att du kan köra `cargo doc --open`-kommandot, vilket
> kommer att lokalt bygga dokumentationen som kommer med alla dina beroendenden
> och öppna den i din webbläsare. Om du t.ex. är intresserad av övrig
> funktionalitet i `rand`-crate:n, kör `cargo doc --open` och klicka på `rand`
> i sidopanelen till vänster.

Den andra raden som vi lade till i mitten av koden skriver ut det hemliga
numret. Detta är användbart medan vi utvecklar programmet för att kunna testa
det, men vi kommer att ta bort utskriften i den slutgiltiga versionen. Det blir
inte mycket till spel om programmet skriver ut svaret så fort det startar!

Prova att köra programmet ett par gånger:

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 7
Please input your guess.
4
You guessed: 4
$ cargo run
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 83
Please input your guess.
5
You guessed: 5
```

Du bör få olika slumptal och de ska alla vara tal mellan 1 och 100. Bra jobbat!

## Jämföra gissningen med det hemliga talet

Nu när vi har användarinmatning och ett slumptal kan vi jämföra dem. Det steget
visas i listning 2-4. Notera att denna kod inte kommer att kompilera riktigt
än, anledningen förklarar vi strax.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {

    // ---klipp---

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal => println!("You win!"),
    }
}
```

<span class="caption">Listning 2-4: Hantering av eventuella returvärden från
att jämföra två tal</span>

Den första nya biten här är ytterligare en `use`-sats, vilken tar in en typ
från standard biblioteket inom räckvidd, denna heter namn
``std::cmp::Ordering`. På samma sätt som `Result` är `Ordering` en uppräkning,
men varianterna för `Ordering` är `Less`, `Greater` och `Equal`. Dessa är de
finns tre möjliga utfallen när du jämför två värden.

Vi kan därefter lägga till fem nya rader längst ner som använder
`Ordering`-typen. Metoden `cmp` jämför två tal och kan anropas på vad som helst
som kan jämföras. Den tar en referens till vad som helst som du vill jämföra
med: här jämför den `guess` med `secret_number`. Den returnerar variant av
`Ordering`-uppräkningen som vi tagit in inom räckvidd med `use`-satsen. Vi
använder ett [`match`][match]<!-- ignore -->-uttryck för att avgöra vad vi ska
göra i nästa steg, baserat på vilken variant av `Ordering` som returnerades
från anropet till `cmp` med värdena `guess` och `secret_number`.

[match]: ch06-02-match.html

Ett `match`-uttryck utgörs av flera *armar*. En arm består av ett *mönster*{
och koden som ska köras om värdet som anges i början av `match`-uttrycket
passas armens mönster. Rust tar värden angivna vid `match` och letar i tur och
ordning genom varje arms mönster. `match`-konstruktionen och mönster är
kraftfulla funktioner i Rust som låter dig uttrycka en mängd olika situationer
som din kod kan stöta på och säkerställer att du hanterar dem allihop. Dessa
funktioner kommer att beskrivas i detalj i kapitel 6 respektive kapitel 18.

Låt oss gå igenom ett exempel på vad som skulle hända med `match`-uttrycket som
används här. Låt oss säga att användaren har gissat 50 och det slumpmässigt
genererade hemliga värdet denna gång är 38. När koden jämför 50 med 38 kommer
`cmp`-metoden att returnera `Order::Greater` eftersom 50 är större än 38.
`match`-uttrycket erhåller värdet `Ordering::Greater` och börjar jämföra det
med varje arms mönster. Den tittar på den första armens mönster,
`Ordering::Less` och ser att värdet `Ordering::Greater` inte matchar
`Ordering::Less`, så den hoppar över koden i den armen och går till nästa arm.
Nästa arms mönster `Ordering::Greater` *stämmer* med `Ordering::Greater`! Den
associerade koden i den armen kommer att köras och skriva ut `Too big!` på
skärmen. `match`-uttrycket avslutas eftersom det inte behöver undersöka den
sista armen i detta scenario.

Men koden i listning 2-4 kommer inte att kompilera än. Låt oss prova:

```text
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
error[E0308]: mismatched types
  --> src/main.rs:23:21
   |
23 |     match guess.cmp(&secret_number) {
   |                     ^^^^^^^^^^^^^^ expected struct `std::string::String`, found integral variable
   |
   = note: expected type `&std::string::String`
   = note:    found type `&{integer}`

error: aborting due to previous error
Could not compile `guessing_game`.
```

Kärnan i felet säger att det finns *omatchade typer*. Rust har ett starkt,
statiskt typsystem. Men det har också typinferens. När vi skrev `let mut guess
= String::new()` kunde Rust komma till slutledningen att `guess` borde vara en
`String` så vi tvingades inte att skriva ut typen. `secret_number` å andra
sidan är av numerisk typ. Ett antal olika numeriska typer kan ha värden mellan
1 och 100: `i32`, ett tal om 32 bitar; `u32` ett teckenlöst tal om 32 bitar;
`i64` ett tal om 64 bitar; samt ett antal andra. Rust använder som standard
`i32` vilket blir typen för `secret_number` om du inte lägger till
typinformation någon annanstans som får Rust att komma till slutledning att en
annan numerisk typ ska användas. Anledningen till felet är att Rust inte kan
jämföra en sträng och en numerisk typ.

I slutändan vill vi konvertera den `String` som programmet läser som inmatning
till en riktig numerisk typ så att vi kan jämföra den numeriskt med det hemliga
talet. Vi kan göra det genom att lägga till två tal i `main`-funktionens kropp:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
// --klipp--

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    let guess: u32 = guess.trim().parse()
        .expect("Please type a number!");

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal => println!("You win!"),
    }
}
```

De två nya raderna är:

```rust,ignore
let guess: u32 = guess.trim().parse()
    .expect("Please type a number!");
```

Vi skapar en variabel med namnet `guess`. Men vänta! Har inte programmet redan
en variabel med namnet `guess`? Det har det, men Rust låter dig *skugga* det
föregående värdet av `guess` med ett nytt. Denna funktion används ofta i
situationer då du vill konvertera ett värde från en typ till en annan.
Skuggning låter oss återanvända variabelnamnet `guess` snarare än tvinga oss
att skapa två unika variabler så som `guess_str` och `guess`. (Kapitel 3
förklarar skuggning mer detaljerat.)

Vi binder `guess` till uttrycker `guess.trim().parse()`. `guess` i det
uttrycker refererar till original-`guess` som var en `String` med inmatningen.
`trim`-metoden på en `String`-instans kommer att eliminera eventuella
blanktecken i början eller slutet. Även om `u32` endast kan innehåller
numeriska tecken måste användaren trycka p[ <span
class="keystroke">retur</span>, då läggs ett nyradstecken till i strängen. Om
användaren till exempel skriver <span class="keystroke">5</span> och trycker
<span class="keystroke">retur</span>, kommer `guess att se ut så här: `5\n`.
Där `\n` representerar ”nyrad”, resultatet av att trycka på <span
class="keystroke">retur</span>. Metoden `trim` kommer att eliminera `\n`, och
resultatet blir bara `5`.

[`parse`-metoden på strängar][parse]<!-- ignore --> tolkar en sträng till någon
form av tal. Eftersom denna metod kan tolka en mängd olika numeriska typer
måste vi berätta för Rust den specifika numeriska typ vi vill ha genom att
använda `let guess: u32`. Kolonet (`:`) efter `guess` berättar för Rust att vi
kommer att förse variabeln med en not om vilken typ som önskas. Rust har ett
antal inbyggda numeriska typer; `u32` som ses här är ett teckenlöst heltal om
32 bitar. Det är en bra standardtyp för små positiva heltal. Du kommer att lära
dig om andra typer i kapitel 3. Därutöver kommer `u32`-noten i detta exempel
tillsammans med jämförelsen med `secret_number` att innebära att Rust kan komma
till slutledningen att `secret_number` också bör vara en `u32`. Så nu kommer
jämförelsen att vara två värden av samma typ!

[parse]: ../std/primitive.str.html#method.parse

Anropet till `parse` skulle enkelt kunna resultera i ett fel. Om strängen
tillvilket diskuterats tidigare i [” exempel innehöll `A👍%`, skulle den under
inga omständigheter kunna konverteras till ett tal. Eftersom den kan misslyckas
returnerar `parse`-metoden en `Result`-typ, på samma sätt som
`read_line`-metoden gör (vilket diskuterats tidigare i [”Hantera eventuella fel
med `Result`-typen”][#handling-potential-failure-with-the-result-type)<!--
ignore -->). Vi kommer att behandla detta `Result` på samma sätt genom att igen
använda `expect`-metoden. Om `parse` returnera `Result`-varianten `Err`
eftersom den inte kunde skapa ett tal från strängen kommer `expect`-anropet att
krascha spelet och skriva ut meddelandet vi anger. Om `parse` framgångsrikt kan
konvertera strängen till ett tal kommer den att returnera `Result`-varianten
`Ok` och `expect` kommer då att returnera talet vi önskade från `Ok`-värdet.

Låt oss köra programmet nu!

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 0.43 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 58
Please input your guess.
  76
You guessed: 76
Too big!
```

Bra! Även om mellanslag lades till innan gissningen så listade programmet ändå
ut att användaren gissade 76. Kör programmet ett par gånger för att verifiera
de olika beteendena med olika typer av inmatning: gissa det korrekta talet,
gissa ett tal som är för stort, gissa ett tal som är för litet.

Vi har merparen av spelet fungerande nu, men användaren kan bara göra en
gissning. Låt oss ändra på detta genom att lägga till en loop!

## Tillåt flera gissningar genom att lägga till en loop

Nyckelordet `loop` skapar en oändlig loop. Vi kommer att lägga till det nu för
att ge användare fler chanser att gissa talet:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
// --klipp--

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        // --klipp--

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => println!("You win!"),
        }
    }
}
```

Som du kan se har flytta allting från uppmaningen till gissningsinmatning och
framåt in i en loop. Se till att indentera raderna inuti loopen ytterligare
fyra blanksteg vardera och kör programmet igen. Notera att det finns en nytt
problem då programmet gör exakt vad vi bad det göra: fortsätt för evigt att
fråga efter en gissning! Det verkar inte som användaren kan avsluta!

Användaren kan alltid avbryta programmet genom tangentbordsgenvägen <span
class="keystroke">ctrl-c</span>. Men det finns ytterligare ett sätt att
undkomma detta omättliga monster som vi nämnde i diskussionen kring `parse` i
[”Jämföra gissningen med det hemliga
talet”](#comparing-the-guess-to-the-secret-number)<!-- ignore -->: om
användaren matar in ett svar som inte är ett tal kommer programmet att krascha.
Användaren kan dra nytta av detta för att avsluta, vilket visas här:

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50 secs
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 59
Please input your guess.
45
You guessed: 45
Too small!
Please input your guess.
60
You guessed: 60
Too big!
Please input your guess.
59
You guessed: 59
You win!
Please input your guess.
quit
thread 'main' panicked at 'Please type a number!: ParseIntError { kind: InvalidDigit }', src/libcore/result.rs:785
note: Run with `RUST_BACKTRACE=1` for a backtrace.
error: Process didn't exit successfully: `target/debug/guess` (exit code: 101)
```

Genom att skriva in `quit` avslutas faktiskt spelet, men det gäller även för
vilken icke-numerisk inmatning som helst. Detta är inte optimalt, minst sagt.
Vi vill att spelet automatiskt ska avslutas när rätt tal gissas.

### Avsluta efter en korrekt gissning

Låt oss programmera spelet att avsluta när användaren vinner genom att lägga
till en `break`-sats:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
// --klipp--

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }
}
```

Att lägga till `break`-raden efter `You win!` får programmet att avsluta loopen
när användaren gissar rätt på det hemliga talet. Att avsluta loopen innebär
också att programmet avslutas eftersom loopen är den sista delen av `main`.

### Hantera ogiltig inmatning

För att vidare raffinera spelets beteende, låt oss få spelet att hoppa över
svar som inte är tal, snarare än att krascha programmet när en sådan inmatning
sker. På så sätt kan användaren fortsätta gissa. Vi kan göra det genom att
ändra raden där `guess` konverteras från en `String` till en `u32`, så som
visas i listning 2-5.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
// --klipp--

io::stdin().read_line(&mut guess)
    .expect("Failed to read line");

let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};

println!("You guessed: {}", guess);

// --klipp--
```

<span class="caption">Listning 2-5: Hoppa över en icke-numerisk gissning och
fråga efter en ny gissning istället för att krascha programmet</span>

Att ändra från ett `expect`-anrop till ett `match`-uttryck är så du i allmänhet
går från att krascha vid ett fel till faktiskt felhantering. Kom ihåg att
`parse` returnerar en `Result`-typ och att `Result` är en uppräkning som har
varianterna `Ok` och `Err. Vi använder ett `match`-uttryck här på samma sätt
som vi gjorde med `Ordering`-resultett från `cmp`-metoden.

Om `parse` framgångsrikt kan konvertera strängen till ett ta kommer den att
returnera ett `Ok`-värde som innehåller det önskade talet. Det `Ok`-värdet
kommer att matcha den första armens mönster och `match`-uttrycker kommer att
helt enkelt returnera värdet `num` som `parse`-producerat och placerat inuti
`Ok`-värdet. Det talet kommer att placeras precis där vi vill ha det i den nya
`guess`-variabeln som vi skapar.

Om `parse` *inte*{ kan konvertera strängen till ett tal, kommer den att
returnera ett `Err`-värde som innehåller mer information om felet. `Err`-värdet
matchar inte mönstret `Ok(num)` i den den första armen för `match`, men det
matchar mönstret `Err({_)` i den andra armen. Understrecket, `_`, är ett så
kallat fånga-allt-värdet; i detta exempel innebär det att vi vill matcha alla
`Err`-värden oavsett vilken information de har inuti sig. Så programmet kommer
att köra koden för den andra armen, `continue` berättar för programmet att det
ska hoppa till nästa iteration av `loop` och fråga efter en ny gissning. Så, i
praktiken kommer programmet att hoppa över alla fel som `parse` kan tänkas
träffa på!

Nu borde allting i programmet fungera som förväntat. Låt oss prova:

```text
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 61
Please input your guess.
10
You guessed: 10
Too small!
Please input your guess.
99
You guessed: 99
Too big!
Please input your guess.
foo
Please input your guess.
61
You guessed: 61
You win!
```

Fantastiskt! Med en sista, liten ändring kommer vi att avsluta gissningsspelet.
Kom ihåg att programmet fortfarande skriver ut det hemliga talet. Det fungerade
bra under testningen, men nu förstör det spelet. Låt oss tal bort `println!`
som matar ut det hemliga talet. Listning 2-6 visar den slutgiltiga koden.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
    }
}
```

<span class="caption">Listning 2-6: Den kompletta koden för gissningsspelet</span>

## Sammanfattning

Så här långt har du lyckats bygga ett gissningsspel. Grattis!

Detta projekt var ett praktiskt sätt på vilket vi introducerat dig till många
nya Rust-koncept: `let`, `match`, metoder, associerade funktioner, användning
av externa crate:ar, med mera. I de kommande kapitlen kommer du att lära dig
mer om dessa koncept. Kapitel 3 täcker koncept som de flesta
programmeringsspråk har, så som variabler, datatyper och funktioner, och visar
hur du använder dem i Rust. Kapitel 4 utforskar ägandeskap och funktioner som
särskiljer Rust från andra språk. Kapitel 5 diskuterar strukturer och
metodsyntax medan kapitel 6 förklarar hur uppräkningar fungerar.

[variabler-och-föränderlighet]:
ch03-01-variables-and-mutability.html#variables-and-mutability
