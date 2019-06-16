## Hello, Cargo!

Cargo är Rusts byggsystem och pakethanterare. De flesta Rust-användare använder
detta verktyg för att hantera sina Rust-projekt eftersom Cargo-hanterar många
saker, så som att bygg din kod, hämta bibliotek din kod beror på och att bygga
de biblioteken. (Vi kallar bibliotek din kod behöver för *beroenden*.)

De enklaste Rust-programmen, så som det du skrivit så här långt, har inte några
beroenden. Så om vi hade byggt Hello, world!-projektet med Cargo hade det
enbart använt den delen av Cargo som hanterar bygge av din kod. Allt eftersom
du skriver mer komplexa Rust-program kommer du att lägga till beroenden, och om
du påbörjar ett projekt som använder Cargo kommer det att vara mycket enklare
att lägga till beroenden.

Eftersom den stora majoriteten av Rust-projekt använder Cargo kommer resten av
denna boken att förutsätta att du också använder Cargo. När du installerar Rust
installerar även Cargo om du använt den officiella installationsmetoden som
diskuterats i avsnittet [”installation”][installation]<!-- ignore -->. Om du
installerat Rust på något annat sätt, kontrollera huruvida Cargo är installerat
genom att mata in följande i din terminal:

```text
$ cargo --version
```

Om du ser ett versionsnummer så har du Cargo! Om du ser ett felmeddelande så
som `kommandot hittades inte`, leta bland dokumentationen för din
installationsmetod för att hitta hur du installerar Cargo separat.

### Skapa ett projekt med Cargo

Låt oss skapa ett nytt projekt med hjälp av Cargo och se hur det skiljer sig
från vårt första Hello, world!-projekt. Navigera tillbaka till din
*projects*-katalog (eller dit där du bestämde sig för att lagra sin kod). Skriv
sedan följande, oberoende av operativsystem:

```text
$ cargo new hello_cargo
$ cd hello_cargo
```

Det första kommandot skapar en ny katalog kallad *hello_cargo*. Vi kallar vårt
projekt *hello_cargo*, och Cargo skapar dess filer i en katalog med samma namn.

Gå in i *hello_cargo*-katalogen och lista filerna. Du kommer att se att Cargo
har genererat två filer och en katalog åt oss: en *Cargo.toml*-fil och en
*src*-katalog med en *main.rs*-fil inuti. Den har också initierat ett nytt
Git-arkiv tillsammans med en *.gitignore*-fil.

> Notera: Git är ett vanligt versionshanteringssystem. Du kan ändra `cargo new`
> till att använda ett annat versionshanteringssystem, eller att inte använda
> något alls, via flaggan `--vcs`. Kör `cargo new --help` för att se de
> tillgängliga flaggorna.

Öppna *Cargo.toml* i en textredigerare du gillar. Den bör likna koden i
listning 1-2.

<span class="filename">Filnamn: Cargo.toml</span>

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
edition = "2018"

[dependencies]
```

<span class="caption">Listning 1-2: Innehållet i *Cargo.toml* genererat av `cargo
new`</span>

Denna fil är i [*TOM*][toml]<!-- ignore -->-formatet (*Tom's Obvious, Minimal
Language*), vilket är Cargos konfigurationsformat.

[toml]: https://github.com/toml-lang/toml

Den första raden, `[package]`, är en avsnittsrubrik som indikerar att följande
satser konfigurerar ett paket. Allt eftersom vi lägger till mer information i
denna filen kommer vi att lägga till andra avsnitt.

De nästa fyra raderna ställer in den konfigurationsinformation som Cargo
behöver för att kompilera ditt program: namnet, versionen, vem som skrev det
och upplagan av Rust som ska användas. Cargo hämtar ditt namn och din
e-postinformation från din miljö, så om den informationen inte är korrekt,
åtgärda det nu och spara sedan filen. Vi kommer att tala om nyckeln `edition` i
Bilaga E.

Den sista raden `[dependencies]` är början på ett avsnitt där du kan lista ditt
projekts beroenden. I Rust kallas paket med kod för *crates*. Vi kommer inte
att behöva några andra *crates* för detta projektet, men det kommer vi att
behöva i det första projektet i kapitel 2, så vi kommer att använda det här
avsnittet då.

Öppna och titta nu på *src/main.rs*:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo har genererat ett Hello, world!-program åt dig, precis som det vi skrev i
listning 1-1! Så här långt är skillnaden mellan vårt föregående projekt och
projektet Cargo genererat att Cargo placerat koden i *src*-katalogen och att vi
har en *Cargo.toml*-konfigurationsfil i toppnivåkatalogen.

Cargo förväntar sig att dina källkodsfiler finns inuti *src*-katalogen.
I toppnivåkatalogen för projektet är till för README-filer, licensinformation,
konfigurationsfiler och saker som inte är relaterad till din kod. Att använda
Cargo hjälper dig att organisera dina projekt. Det finns en plats för allt och
allting har sin plats.

Om du har påbörjat ett projekt som inte använder Cargo, så som vi gjorde med
Hello, world!-projektet kan du konvertera det till ett projekt som använder
Cargo. Flytta projektkoden in i *src*-katalogen och skapa en lämplig
*Cargo.toml*-fil.

### Bygga och köra ett Cargo-projekt

Nu ska vi titta på vad som skiljer sig när vi bygger och kör Hello,
world!-programmet med Cargo! Från din *hello_cargo*-katalog, bygg ditt projekt
genom att mata in följande kommando:

```text
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

Detta kommando skapar en körbar fil i *target/debug/hello_cargo* (eller
*target\debug\hello_cargo.exe* under Windows) snarare än i din aktuella
arbetskatalog. Du kan köra den körbara filen genom detta kommando:

```text
$ ./target/debug/hello_cargo # eller .\target\debug\hello_cargo.exe under Windows
Hello, world!
```

Om allt går bra bör `Hello, world!` skrivas ut på terminalen. Att köra `cargo
build` för första gången får också Cargo att skapa en ny fil på toppnivån:
*Cargo.lock*. Denna fil håller koll på de exakta versionerna av beroendena i
ditt projekt. Detta projekt har inga beroenden så file är ganska tom. Du kommer
aldrig att behöva ändra i den här filen manuellt; Cargo hanterar dess innehåll
åt dig.

Vi har nyss byggt ett projekt med `cargo build` och kört det med
`./target/debug/hello_cargo`, men vi kan också använda `cargo run` för att
kompilera koden och sedan köra den körbara filen med ett kommando:

```text
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Notera att denna gången såg vi inte utmatningen som indikerar att Cargo
kompilerade `hello_cargo`. Cargo listade ut att filerna inte hade ändrats, så
den körde bara den körbara filen. Om du hade modifierat din källkod hade Cargo
byggt om projektet innan den kört det, och du hade sett den här utmatningen:

```text
$ cargo run
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.33 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Cargo tillhandahåller också ett kommando kalalt `cargo check`. Detta kommando
kontrollerar snabbt din kod och säkerställer att den kompilerar men skapar inte
en körbar fil:

```text
$ cargo check
   Checking hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

Varför skulle du inte vilja ha en körbar fil? Ofta är `cargo check` mycket
snabbare än `cargo build` eftersom den hoppar över stegen som producerar en
körbar fil. Om du kontinuerligt kontrollerar din kod medan du skriver koden
kommer att `cargo check` att snabba upp processen! Därför kör många
Rust-användare periodiskt `cargo check` medan de skriver sina program för att
se till att den bygger. De kör sedan `cargo build` när de är redo att använda
den körbara filen:

Låt oss repetera vad vi lärt oss om Cargo så här långt:

* Vi kan bygga ett projekt via `cargo build` eller `cargo check`.
* Vi kan bygga och köra ett projekt i ett steg med `cargo run`.
* Istället för att spara resultatet från bygget i samma katalog som vår kod,
  lagrar Cargo den i katalogen *target/debug*.

Ytterligare en fördel med att använda Cargo är att kommandon är de samma
oavsett vilket operativsystem du arbetar under. Så hädanefter kommer vi inte
längre att tillhandahålla specifika instruktioner för Linux och macOS vs.
Windows.

### Bygga för utgivning

När ditt projekt till slut är redo för utgivning kan du använda `cargo build
--release` för att kompilera det med optimeringar. Detta kommando kommer att
skapa en körbar fil i *target/release* istället för *target/debug*.
Optimeringarna kommer att göra att din Rust-kod kör fortare, men att slå på dem
kommer att göra att tiden som behövs för att kompilera ditt program blir
längre. Det är därför det finns två olika profiler: en för utveckling när du
vill att ombyggnation ska gå fort och det görs ofta, och en annan för att bygga
det slutliga programmet som du ger till en användare som inte kommer att byggas
om så ofta och som ska köra så fort som möjligt. Om du ska mäta ditt programs
körtid, se till att köra `cargo build --release` och mät prestandan på den
körbara filen i *target/release*.

### Cargo som konvention

Med enkla projekt erbjuder Cargo inte mycket mervärde utöver att bara använda
`rustc`, men det kommer att visa sig värt att använda när din program blir mer
intrikata. Med komplexa projekt som består av flera crates är det mycket
enklare att låta Cargo koordinera bygget.

Även om `hello_cargo`-projektet är enkelt använder det nu det riktiga
verktygsuppsättningen som du kommer att använda under resten av din
Rust-karriär. Faktum är att för att kunna arbeta på något existerande projekt
kan du använda följande kommandon för att checka ut koden med hjälp av Git,
byta över till det projektets katalog och bygga det:

```text
$ git clone someurl.com/someproject
$ cd someproject
$ cargo build
```

För mer information om Cargo, se [dess dokumentation].

[dess dokumentation]: https://doc.rust-lang.org/cargo/

## Sammanfattning

Du har redan fått god start på ditt Rust-äventyr! I detta kapitel har du lärt
dig att:

* Installera den senaste stabila versionen av Rust med hjälp av `rustup`
* Uppdatera till en nyare Rust-version
* Öppna lokalt installerad dokumentation
* Direkt skriva och köra ett Hello, world!-program med `rustc`
* Skapa och köra ett nytt projekt enligt konvention med Cargo

Detta är en bra tidpunkt att bygga ett större program för att vänja sig vid att
läsa och skriva Rust-kod. Därför kommer vi i kapitel 2 att bygga ett program
med ett gissningsspel. Om du hellre skulle vilja lära dig hur vanliga
programmeringskoncept fungerar i Rust, se kapitel 3 och återgå sedan till
kapitel 2.

[installation]: ch01-01-installation.html#installation
