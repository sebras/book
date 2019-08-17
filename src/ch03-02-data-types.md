## Datatyper

Varje värdet i Rust är av en särskild *datatyp*, vilken berättar för Rust
vilken type av data som anges så att det vet hur det ska arbeta med denna data.
Vi kommer att titta på två delmängder av datatyper: skalärer och sammansatta
datatyper.

Kom ihåg att Rust är ett *statiskt typat* språk, vilket innebär att det måste
känna till typerna för alla variabler vid kompileringstid. Kompilatorn kan
vanligtvis härleda vilken type vi vill använda baserat på värdet och hur vi
använde det. I fall då många typer är möjligt, så som när vi konverterade en
`String` till en numeriskt typ med `parse` i avsnittet [”Jämföra en gissning
med det hemliga talet`][jämföra-gissningen-med-det-hemliga-talet]<!-- ignore
--> i kapitel 2, måste vi på detta sätt lägga till en typmarkering:

```rust
let guess: u32 = "42".parse().expect("Not a number!");
```

Om vi inte lägger till typmarkeringen här kommer Rust att visa följande fel,
vilket innebär att kompilatorn behöver mer information från oss för att veta
vilken typ vi vill använda:

```text
error[E0282]: type annotations needed
 --> src/main.rs:2:9
  |
2 |     let guess = "42".parse().expect("Not a number!");
  |         ^^^^^
  |         |
  |         cannot infer type for `_`
  |         consider giving `guess` a type
```

Framöver kommer du att se olika typmarkeringar för andra datatyper.

### Skalära typer

En *skalär* typ representerar ett enstaka värde. Rust har fyra primära
skalära typer: heltal, flyttal, booleska värden och tecken. Du känner kanske
igen dessa från andra programmeringsspråk. Låt oss direkt hoppa in i hur de
fungerar i Rust.

#### Heltalstype

Ett *heltal* är ett tal utan decimaldel. Vi använde en heltalstyp i kapitel 2,
typen `u32`. Denna typdeklaration indikerar att värdet som den associeras med
bör vara ett teckenlöst heltal (heltalstyper med tecken inleds med `i`,
istället för `u`) vilket upptar 32 bitar. Tabell 3-1 visar de inbyggda
heltalstyper som finns i Rust. Varje variant i kolumnerna ”Med tecken” och
”Teckenlöst” (till exempel `i16`) kan användas för att deklarera typen av ett
heltalsvärde.

<span class="caption">Tabell 3-1: Heltalstyper i Rust</span>

| Längd      | Med tecken | Teckenlöst |
|------------|------------|------------|
| 8 bitar    | `i8`       | `u8`       |
| 16 bitar   | `i16`      | `u16`      |
| 32 bitar   | `i32`      | `u32`      |
| 64 bitar   | `i64`      | `u64`      |
| 128 bitar  | `i128`     | `u128`     |
| arkitektur | `isize`    | `usize`    |

Varje variant kan antingen vara med tecken eller teckenlöst och har en
uttrycklig storlek. *Med tecken* och *teckenlöst* refererar till huruvida det är
möjligt för talet att vara negativt eller positivt — med andra ord, huruvida
talet måste ha ett tecken (med tecken) eller huruvida det enbart kan bara
positivt och därför kan representeras utan ett tecken (teckenlöst). Det är som
att skriva tal på ett papper: när tecknet spelar roll skrivs ett tal med ett
plustecken eller ett minustecken; men om det går att förutsätta att talet är
positivt skrivs inget tecken ut. Tal med tecken sparas enligt
[två-komplementsrepresentation](https://sv.wikipedia.org/wiki/Tv%C3%A5komplementsform).

Varje variant med tecken kan lagra tecken från -(2<sup>n - 1</sup>) till
2<sup>n - 1</sup> - 1, där *n* är antalet bitar som den varianten använder. Så
en `i8` kan lagra tal från -(2<sup>7</sup>) till 2<sup>7</sup> -1, det vill
säga från -128 till 127. Teckenlösa varianter kan lagra tal från 0 till
2<sup>n</sup> - 1, så en `u8` kan lagra tal från 0 till 2<sup>8</sup>, det vill
säga från 0 till 255.

Dessutom beror typerna `isize` och `usize` på vilken dator ditt program kör på:
64 bitar om du kör på en 64-bitarsarkitektur och 32 bitar om du kör på en
32-bitarsarkitektur.

Du kan skriva heltalsliteraler enligt formerna som visas i Tabell 3-2. Notera
att alla numeriska literaler förutom byte-literalen tillåter ett typsuffix, så
som `57u8` och `_` som en visuell separator, som i `1_000`.

<span class="caption">Tabell 3-2: Heltalsliteraler i Rust</span>

| Numeriska literaler | Exempel       |
|---------------------|---------------|
| Decimal             | `98_222`      |
| Hex                 | `0xff`        |
| Octal               | `0o77`        |
| Binär               | `0b1111_0000` |
| Byte (endast `u8`)  | `b'A'`        |

Så hur kan du veta vilken type av heltal som du ska använda? Om du är osäker är
Rust standardval generellt bra val, och heltal blir som standard `i32`: denna
type är generellt sett den snabbaste, även på 64-bitarssystem. Den primära
situation då du bör använda `isize` eller `usize` är när du indexerar i någon
form av samling.

> ##### Heltalsöverspill
>
> Låt oss säga att du har en variabel av typen `u8` som kan lagra värden mellan
> 0 och 255. Om du försöker att ändra variabeln till ett värde som ligger
> utanför det intervallet, så som 256, kommer *heltalsöverspill* att inträffa.
> Rust har en del intressanta regler för detta beteende. När du kompilerar i
> felsökningsläge inkluderar Rust kontroller för heltalsöverspill som får ditt
> program få en *panik* om detta beteende inträffar. Rust använder termen
> *panik* när ett program avslutas med ett fel; vi kommer i detalj att
> diskutera *paniker* i avsnittet [”Oåterkalleliga fel med
> `panic!`”][oåterkalleliga-fel-med-panic] i kapitel 9.
>
> När du kompilerar i utgåvoläge med flaggan `--release` inkluderar Rust *inte*
> kontroller för heltalsöverspill som orsakar paniker. Om överspill inträffar
> kommer Rust istället att utföra *tvåkomplementsvikning*. I korta drag kommer
> värden som är större än det största värdet som typen kan lagra att ”vikas
> runt” till det lägsta värdet som typen kan lagra. I fallet med en `u8` kommer
> 256 att bli 0, 257 blir 1, och så vidare. Programmet kommer inte att få
> panik, men variabeln kommer att få ett värdet som du förmodligen inte
> förväntade dig att den skulle få. Att förlita sig på vikningsbeteendet vid
> heltalsöverspill anses vara ett fel. Om du uttryckligen vill använda vikning
> så kan du använda standardbibliotekstypen [`Wrapping`][viking].

### Flyttalstyper

Rust har också två primitiva typer för *flyttal*, vilket är tal med
decimaldel. Rusts flyttalstyper är `f32` och `f64`, vilkas storlek är 32
respektive 64 bitar. Standardtypen är `f64` eftersom på moderna CPU:er går
beräkningar med dessa ungefär lika fort som `f32`, men kan hantera en större
precision.

Här är ett exempel som visar hur flyttal användas:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let x = 2.0; // f64

    let y: f32 = 3.0; // f32
}
```

Flyttal representeras enligt standarden IEEE-754. Typen `f32` är ett
enkelprecisionsflyttal, och `f64` har dubbelprecision.

#### Numeriska operatorer

Rust har stöd för det grundläggande matematiska operationerna som du förväntar
dig av taltyper: addition, subtraktion, multiplikation, division och rest.
Följande kod visar hur du använder var och en i en `let`-sats:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    // addition
    let sum = 5 + 10;

    // subtraktion
    let difference = 95.5 - 4.3;

    // multiplikation
    let product = 4 * 30;

    // division
    let quotient = 56.7 / 32.2;

    // rest
    let remainder = 43 % 5;
}
```

Varje uttryck i dessa satser använder en matematisk operator och utvärderas
till ett enstaka värde vilket sedan vinds till en variabel. Bilaga B innehåller
en lista över alla operatorer som Rust tillhandahåller.

#### Den booleska typen

Som i de flesta andra programmeringsspråk har en boolesk typ i Rust två möjliga
värden: `true` och `false`. Booleska typer är en byte stora. Den booleska
typen i Rust anges genom att använda `bool`, till exempel:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let t = true;

    let f: bool = false; // med uttrycklig typmarkering
}
```

Booleska värden används i huvudsak via villkor, så som ett `if`-uttryck. Vi
kommer att beskriva hur `if`-uttryck fungerar i Rust i avsnittet
[”Kontrollflöde”][kontrollflöde]<!-- ignore -->.

#### Teckentypen

Så här långt har vi bara arbetat med tal, men Rust har även stöd för tecken.
Rusts `char`-typ är språkets mest primitiva alfabetiska typ, och följande kod
visar hur man använder den. (Notera att `char`-literaler anges med apostrof
till skillnad från strängliteraler som använder citationstecken.)

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let c = 'z';
    let z = 'ℤ';
    let heart_eyed_cat = '😻';
}
```

Rusts `char`-typ är fyra byte stor och representera ett Unicode-skalärvärde,
vilket innebär att det kan representera mycket mer än bara ASCII. Bokstäver med
diakritiska tecken, kinesiska, japanska och koreanska tecken, emoji och
nollbreddsblanksteg är alla giltiga `char`-värden i Rust. Unicode-skalärvärden
ligger i intervallen från `U+0000` till `U+D7FF` samt från `U+E000` till
`U+10FFFF`. ”Tecken” är inte ett koncept inom Unicode, så din intuition om vad
ett ”tecken” är stämmer inte nödvändigtvis med var en `char` är i Rust. Vi
kommer att diskutera detta ämne i detalj i [”Lagra UTF-8-kodad text med
strängar”][strängar]<!-- ignore --> i kapitel 8.

### Sammansatta type

*Sammansatta type* kan gruppera ihop flera värden till en typ. Rust har två
primitiva sammansatta typer: tupler och array:er.

#### Tupeltypen

En tupel är ett generellt sätt att gruppera ett antal värden med olika typer i
en sammansatt typ. Tupler har en fix längd: efter att de deklarerats kan de
inte växa eller minska i storlek.

Vi kan skapa en tupel genom att skriva en kommaseparerad lista av värden inuti
parenteser. Varje position i tupeln har en typ och typerna för de olika värdena
i tupeln måste inte vara samma. Vi har lagt till valfri typmarkering i detta
exemplet:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);
}
```

Variabeln `tup` binder till hela tupeln, eftersom en tupel anses vara en
enstaka sammansatt element. För att få ut de individuella värdena från en tupel
kan vi använda mönstermatchning för att destrukturera ett tupelvärde, som i
detta fallet:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let tup = (500, 6.4, 1);

    let (x, y, z) = tup;

    println!("The value of y is: {}", y);
}
```

Detta program skapar först en tupel och binder det till variabeln `tup`. Det
använder sedan ett mönster med `let` för att ta `tup` och konvertera det till
tre separata variabler: `x`, `y` och `z`. Detta kallas för *destrukturering*,
eftersom det bryter upp den enstaka tupeln i tre delar. Avslutningsvid skriver
programmer ut värdet för `y`, vilket är `6.4`.

Utöver att destrukturera via mönstermatchning kan vi också nå tupelelement
direkt genom att använda en punkt (`.`) åtföljt av indexet för värdet vi vill
komma åt. Till exempel:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let x: (i32, f64, u8) = (500, 6.4, 1);

    let five_hundred = x.0;

    let six_point_four = x.1;

    let one = x.2;
}
```

Detta program skapar en tupel, `x`, och skapar sedan en ny variabel för varje
element genom att använda deras respektive index. Som för de flesta
programmeringsspråk är 0 det första indexet för en tupel.

#### Array-typen

Ett annat sätt att ha en samling av multipla värden är i en *array*. Till
skillnad från en tupel måste varje element i en array ha samma typ. Array:er i
Rust skiljer sig från array:er i en del andra språk då array:er i Rust har en
begränsad längd, på samma sätt som tupler.

I Rust skrivs värden som ska in i en array som en kommaseparerad list inuti
hakparenteser:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let a = [1, 2, 3, 4, 5];
}
```

Array:er är användbara när du vill att din data ska allokeras på stacken
snarare än heapen (vi kommer att diskutera stacken och heapen grundligt i
kapitel 4) eller när du vill säkerställa att du alltid har ett fixt antal
element. En array är dock inte lika flexibel som vektortypen. En vektor är en
liknande samlingstyp som tillhandahålls av standardbiblioteket som *kan* växa
eller minska in storlek. Om du är osäker på huruvida du ska använda en array
eller en vektor för du antaligen använda en vektor. Kapitel 8 diskuterar
vektorer utförligt.

Ett exempel på när du kanske bör använda en array istället för en vektor är i
ett program som behöver känns till namnen på årets månader. Det är väldigt
osannolikt att ett sådant program kommer att behöva lägga till eller ta bort
månader, så du kan använda en array eftersom du alltid vet att det kommer att
finnas 12 element:

```rust
let months = ["January", "February", "March", "April", "May", "June", "July",
              "August", "September", "October", "November", "December"];
```

Du skriver an array:s typ genom att använda hakparenteser, inom hakparenteserna
inkludera typen för varje element, ett semikolon och sedan antalet element i
array:en, på följande sätt:

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
```

Här är `i32` typen för varje element. Efter semikolonet indikerar talet `5` att
array:en innehåller fem element.

Att skriva en array:s typ på detta sätt liknar en alternativ syntax för att att
initiera en array: om du vill skapa en array som innehåller samma värde för
varje element kan du ange det initiala värdet åtföljt av ett semikolon och
sedan arraylängden inom hakparenteser, så som visas här:

```rust
let a = [3; 5];
```

Array:en med namnet `a` kommer att innehålla `5` element som alla initialt
kommer att sättas till värdet `3`. Detta är detsamma som att skriva `let a =
[3, 3, 3, 3, 3];`, men på ett mer koncist sätt.

##### Åtkomst av arrayelement

En array är en enstaka bit minne allokerad på stacken. Du kan komma åt element
i en array genom att använda indexering, på följande sätt:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let a = [1, 2, 3, 4, 5];

    let first = a[0];
    let second = a[1];
}
```

I detta exempel kommer variabeln `first` att få värdet `1`, då detta är värdet
på index `[0]` i array:en. Variabeln med namnet `second` kommer att få värdet
`2` från index `[1]` i array:en.

##### Ogiltig åtkomst av arrayelement

Vad händer om du försöker att få åtkomst till ett element i sen array som är
förbi slutet på array:en? Säg att till exempel du ändrar exemplet kod enligt
följande, vilken kommer att kompilera men avsluta utan fel när den körs:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,panics
fn main() {
    let a = [1, 2, 3, 4, 5];
    let index = 10;

    let element = a[index];

    println!("The value of element is: {}", element);
}
```

Att köra denna kod via `cargo run` producerar följande resultat:

```text
$ cargo run
   Compiling arrays v0.1.0 (file:///projects/arrays)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/arrays`
thread 'main' panicked at 'index out of bounds: the len is 5 but the index is
 10', src/main.rs:5:19
note: Run with `RUST_BACKTRACE=1` for a backtrace.
```

Kompileringen producerade inga fel men programmet resulterade i ett
*körtidsfel* och avslutades inte framgångsrikt. När du försökter att komma åt
ett element via indexering kommer Rust att kontrollera att det index du anger
är mindre än arraylängden. Om indexet är större än eller lika med array längden
kommer Rust att få panik.

Detta är det första exemplet på Rusts säkerhetsprinciper. I många lågnivåspråk
görs inte denna typ av kontroller, så när du anger ett felaktigt index kan
ogiltig åtkomst av minne genomföras. Rust skyddar dig mot denna type av fel
genom att omedelbart avsluta istället för att försöka komma åt minnet och
fortsätta. Kapitel 9 diskuterar Rusts felhantering i närmre detalj.

[jämföra-gissningen-med-det-hemliga-talet]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[kontrollflöde]: ch03-05-control-flow.html#control-flow
[strängar]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[oåterkalleliga-fel-med-panic]: ch09-01-unrecoverable-errors-with-panic.html
[viking]: ../std/num/struct.Wrapping.html
