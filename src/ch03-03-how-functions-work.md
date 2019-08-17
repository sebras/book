## Funktioner

Funktioner finns överallt i Rust-kod. Du har redan sett en av de viktigaste
funktionerna i språket: `main`-funktionen, vilket utgör ingångspunkten för
många program. Du har också sett nyckelordet `fn`, vilket låter dig deklarera
nya funktioner.

Rust-kod använder av hävd *ormnotation* som stil för funktions- och
variabelnamn. I ormnotation är alla bokstäver gemena och understreck separerar
ord. Här är ett program som innehåller ett exempel på en funktionsdefinition:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");

    another_function();
}

fn another_function() {
    println!("Another function.");
}
```

Funktionsdefinition i Rust börjar med `fn` och har ett par parenteser efter
funktionsnamnet. Klammerparenteserna berättar för kompilatorn var
funktionskroppen börjar och slutar.

Vi kan anropa en funktion vi har definierat genom att mata in dess namn åtföljt
av ett par parenteser. Eftersom `another_function` definierats i programmet
kan den anropas inuti `main`-funktionen. Notera att vi har definierat
`another_function` *efter* `main`-funktionen i källkoden; vi hade kunnat göra
det före också. Rust bryr sig inte om var du definierar dina funktioner, bara
att de finns definierade någonstans.

Låt oss påbörja ett nytt binärprojekt med namnet *functions* för att utforska
funktioner vidare. Placera `another_function`-exemplet i *src/main.rs* och kör
det. Du bör se följande utmatning:

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.28 secs
     Running `target/debug/functions`
Hello, world!
Another function.
```

Raderna kör i den ordning de kommer i `main`-funktionen. Först skrivs
meddelandet ”Hello, world!” ut, sedan anropas `another_function` och dess
meddelande skrivs ut.

### Funktionsparametrar

Funktioner kan också definieras till att ta *parametrar*, vilket är speciella
variabler som är en del av funktionens signatur. När en funktion har parametrar
kan du ange konkreta värden för de parametrarna. Tekniskt kallas de konkreta
värdena för *argument*, men i vardagligt tal tenderar programmerare till att
använda orden *parameter* och *argument* som synonymer för antingen variabler i
en funktions definition eller de konkreta värden som skickas in när du anropar
en funktion.

Följande version av `another_function` visar hur parametrar ser ut i Rust:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    another_function(5);
}

fn another_function(x: i32) {
    println!("The value of x is: {}", x);
}
```

Prova att kör detta program; du bör få följande utmatning:

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 1.21 secs
     Running `target/debug/functions`
The value of x is: 5
```

Deklarationen av `another_function` har en parameter med namnet `x`. Typen för
`x` är angiven som `i32`. När `5` skickas in till `another_function` kommer
`println!`-makrot att ersätta paret av klammerparenteser i formatsträngen med
`5`.

I funktionssignaturer *måste* du deklarera typen för varje parameter. Detta är
ett avsiktligt beslut i Rusts design: att kräva typnoteringar i
funktionsdefinitioner innebär att kompilatorn nästan aldrig kräver att du
använder dem på andra stället i koden för att kunna härleda vad du menar.

När du vill ha en funktion som tar flera parametrar, separera
parameterdeklarationerna med komman, så här:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    another_function(5, 6);
}

fn another_function(x: i32, y: i32) {
    println!("The value of x is: {}", x);
    println!("The value of y is: {}", y);
}
```

Detta exempel skapar en funktion med två parametrar, båda av typen `i32`.
Funktionen skriver därefter ut värdena i båda dess parametrar. Notera att
alla funktionsparametrar inte måste ha samma typ, de bara råkar ha det i detta
fall.

Låt oss köra denna kod. Ersätt programmet som för närvarande finns i ditt
*functions*-projekts *src/main.rs*-fil med det föregående exemplet och kör det
via `cargo run`:

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/functions`
The value of x is: 5
The value of y is: 6
```

Eftersom vi anropade funktionen med `5` som värdet för `x` och `6` angavs som
värdet för `y`, kommer de två strängarna att skrivas ut med dessa värden.

### Funktionskroppar innehåller satser och uttryck

Funktionskroppar utgörs av en serie av satser som ibland avslutas med ett
uttryck. Så här långt har vi endast gått genom funktioner utan ett avslutande
uttryck, men du har sett ett uttryck som en del av en sats. Eftersom Rust är
ett uttrycksbaserat språk är detta ett viktig skillnad att förstå. Andra språk
har inte samma särmärken, så låt oss titta på vilka satserna och uttrycken är
och hur deras skillnader påverkar funktionernas kroppar.

Vi har redan använt satser och uttryck. *Satser* är instruktioner som utför en
åtgärd och inte returnerar något värde. *Uttryck* utvärderas till ett
returvärde. Låt oss titta på några exempel.

Att skapa en variabel och tilldela den ett värde med nyckelordet `let` är en
sats. I listning 3-1 är `let y = 6;` en sats.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let y = 6;
}
```

<span class="caption">Listning 3-1: Deklaration av en `main`-funktion som
innehåller en sats</span>

Funktionsdefinitioner är också satser; hela det föregående exemplet är en sats
i sig.

Satser har inga returvärden Du kan därför inte tilldela en `let`-sats till en
annan variabel, så som följande kod försöker göra; då kommer du att få ett fel:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let x = (let y = 6);
}
```

När du kör detta program kommer felet du får att se ut så här:

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
error: expected expression, found statement (`let`)
 --> src/main.rs:2:14
  |
2 |     let x = (let y = 6);
  |              ^^^
  |
  = note: variable declaration using `let` is a statement
```

Satsen `let y = 6` returnerar inte något värde, så det finns ingenting för `x`
att binda till. Detta skiljer sig från vad som händer i andra språk, så som C
och Ruby, där tilldelningar returnerar tilldelningens värde. I de språken kan
du skriva `x = y = 6` och få både `x` och `y` att ha värdet `6`; så är inte
fallet med Rust.

Uttryck utvärderas till någonting och utgör större delen av resten av koden som
du kommer att skriva i Rust. Tänk på en enkel matematisk operation, så som `5 +
6`, vilken är ett uttryck som utvärderas till värdet `11`. Uttryck kan vara del
av satser: i listning 3.1 är värdet `6` i satsen `let y = 6;` ett uttryck som
utvärderas till värdet `6`. Att anropa en funktion är ett uttryck. Att anropa
ett makro är ett uttryck. Blocket som vi använde för att skapa nya räckvidder,
`{}` är ett uttryck, till exempel:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let x = 5;

    let y = {
        let x = 3;
        x + 1
    };

    println!("The value of y is: {}", y);
}
```

Detta uttryck:

```rust,ignore
{
    let x = 3;
    x + 1
}
```

är ett block som i detta fall utvärderas till `4`. Det värdet binds till `y`
som en del av `let`-satsen. Notera raden `x + 1` utan ett semikolon på slutet,
vilket skiljer sig från de flesta rader du sett så här långt. Uttryck
kräver inte avslutande semikolon. Om du lägger till ett semikolon på slutet av
ett uttryck förvandlar du det till en sats, vilken därför inte kommer att
returnera något värde. Håll detta i minnet medan du utforskar returvärden från
funktioner och uttryck härnäst.

### Funktioner med returvärden

Funktioner kan returnera värde till koden som anropar dem. Vi namnger inte
returvärden, men vi deklarerar deras typ efter en pil (`->`). I Rust är
returvärdet från en funktion synonymt med värdet av det avslutande uttrycket i
funktionkroppens block. Du kan returnera tidigare från en funktion genom att
använda nyckelordet `return` och ange ett uttryck, men de flesta funktioner
returnerar implicit det sista uttrycket. Här är ett exempel på en funktion som
returnerar ett värde:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn five() -> i32 {
    5
}

fn main() {
    let x = five();

    println!("The value of x is: {}", x);
}
```

Det finns inte några funktionsanrop, makro eller `let`-satser i funktionen
`five` — bara siffran `5`, ensam. Detta är en helt giltig funktion i Rust.
Notera att funktionens returtyp också anges, som `-> i32`. Prova att köra denna
kod; utmatningen bör se ut så här:

```text
$ cargo run
   Compiling functions v0.1.0 (file:///projects/functions)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
     Running `target/debug/functions`
The value of x is: 5
```

`5` i `five` är funktionens returvärde, vilket är varför returtypen är `i32`.
Låt oss undersöka detta mer detaljerat. Det finns två viktiga bitar: den
första, raden `let x = five();` visar att vi använder returvärdet för en
funktion för att initialisera en variabel. då funktionen `five` returnerar `5`,
är den raden detsamma som att göra följande:

```rust
let x = 5;
```

För det andra har funktionen `five` inte några parametrar och definierar typen
av returvärdet, men kroppen för funktionen är ett ensamt tecken `5` utan något
semikolon eftersom det är ett uttryck vars värde vi vill returner.

Låt oss titta på ett annat exempel:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let x = plus_one(5);

    println!("The value of x is: {}", x);
}

fn plus_one(x: i32) -> i32 {
    x + 1
}
```

Om man kör denna kod kommer den att skriva ut `The value of x is: 6`. Men om vi
placerar ett semikolon på slutet av readen som innehåller `x + 1`, kommer vi
att ändra den från ett uttryck till en sats, och kommer därför att få ett fel.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let x = plus_one(5);

    println!("The value of x is: {}", x);
}

fn plus_one(x: i32) -> i32 {
    x + 1;
}
```

Kompilering av denna kod producerar ett fel, så som följer:

```text
error[E0308]: mismatched types
 --> src/main.rs:7:28
  |
7 |   fn plus_one(x: i32) -> i32 {
  |  ____________________________^
8 | |     x + 1;
  | |          - help: consider removing this semicolon
9 | | }
  | |_^ expected i32, found ()
  |
  = note: expected type `i32`
             found type `()`
```

Huvudfelmeddelandet, ”mismatched type” (type stämmer inte), avslöjar
huvudproblemet med koden. Definitionen av funktion `plus_one` säger att den
kommer att returnera en `i32`, men satser evaluerar inte till ett värde,
vilket uttrycks av `()`, en tom tupel. Därför returneras ingenting vilket
motsäger funktionsdefinitionen och resulterar i ett fel. I denna utmatning
tillhandahåller Rust ett meddelande för att försöka hjälpa till att eventuellt
rätta problemet: det föreslår att ta bort semikolonet, vilket hade åtgärdat
problemet.
