## Kontrollflöde

Att besluta huruvida viss kod ska köras beroende på om ett villkor är sant
eller ej, och att ta beslutet att köra viss kod upprepade gånger medan ett
villkor är sant utgör grundläggande byggstenar i de flesta programmeringsspråk.
De vanligaste konstruktionerna som låter dig styra körflöde i Rust-kod är
`if`-uttryck och loopar.

### `if`-uttryck

Ett `if`-uttryck låter dig förgrena din kod beroende på villkor. Du anger ett
villkor och uppger sedan, ”Om detta villkor uppfylls, kör detta blocket kod. Om
villkoret inte är uppfyllt, kör inte detta block kod.”

Skapa ett nytt projekt kallat *branches* i din *projects*-katalog för att
utforska `if`-uttryck. I filen *src/main.rs*, mata in följande:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let number = 3;

    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }
}
```

Alla `if`-uttryck inleds med nyckelordet `if`, vilket åtföljs av ett villkor. I
detta fall kontrollerar villkoret huruvida variabeln `number` har ett värde
mindre än 5. Blocket kod vi vill köra om villkoret är sant placeras omedelbart
efter villkoret inuti klammerparenteser. Block med kod associerade med
villkoren i `if`-uttryck kallas ibland för *armar*, precis som armarna i
`match`-uttryck som vi diskuterade i avsnittet [”Jämföra gissningen med det
hemliga talet”][jamfora-gissningen-med-det-hemliga-talet]<!-- ignore --> i
kapitel 2.

Vi kan också valfritt inkludera ett `else`-uttryck, vilket vi valde att göra i
detta fallet, för att ge programmet ett alternativt block kod att köra om
villkoret utvärderas till falskt. Om du inte tillhandahåller ett `else`-uttryck
och villkoret är falskt kommer programmet bara att hoppa över `if`-blocket och
köra nästa bit av koden.

Försök att köra denna kod; du bör se följande utmatning:

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/branches`
condition was true
```

Låt oss försöka att ändra värdet på `number` till ett värde som gör villkoret
`false` för att se vad som händer:

```rust,ignore
let number = 7;
```

Kör programmet igen, och titta på utmatningen:

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/branches`
condition was false
```

Det är också värt att notera att villkoret i denna kod *måste* vara en `bool`.
Om villkoret inte är en `bool` kommer vi att få ett fel. Försök till exempel
att köra följande kod:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let number = 3;

    if number {
        println!("number was three");
    }
}
```

`if`-villkoret utvärderas till värdet `3` denna gång, och Rust kastar ett fel:

```text
error[E0308]: mismatched types
 --> src/main.rs:4:8
  |
4 |     if number {
  |        ^^^^^^ expected bool, found integral variable
  |
  = note: expected type `bool`
             found type `{integer}`
```

Felet indikerar att rust förväntade sig en `bool`, men fick ett heltal. Till
skillnad från språk så som Ruby och JavaScript kommer Rust inte automatiskt att
försöka att konvertera icke-booleska typer till en boolesk datatyp. Du måste
vara tydlig och alltid förse `if` med en boolesk datatype som dess villkor. Om
vi vill att `if`-kodblocket ska köras enbart när ett nummer inte är lika med
`0`, kan vi till exempel ändra `if`-uttrycket enligt följande:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let number = 3;

    if number != 0 {
        println!("number was something other than zero");
    }
}
```

Om du kör denna kod kommer den att skriva ut `number was something other than
zero`.

#### Hantera flera villkor med `else if`

Du kan ha flera villkor genom att kombinera `if` och `else` i ett `else
if`-uttryck. Till exempel:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let number = 6;

    if number % 4 == 0 {
        println!("number is divisible by 4");
    } else if number % 3 == 0 {
        println!("number is divisible by 3");
    } else if number % 2 == 0 {
        println!("number is divisible by 2");
    } else {
        println!("number is not divisible by 4, 3, or 2");
    }
}
```

Detta program har fyra möjliga vägar som det kan ta. Efter att du kört det bör
du se följande utmatning:

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/branches`
number is divisible by 3
```

När detta program exekverar kontrollerar det varje `if`-uttryck i tur och
ordning och kör den första kroppen för vilket villkoret är sant. Notera att
även om 6 är dividerbart med 2 kommer vi inte att se utmatningen `number is
divisible by 2`, inte hellet kommer vi att se texten `number is not divisible
by 4, 3, or 2` från `else`-blocket. Det är för att Rust enbart kör blocket för
det första sanna villkoret, och efter att ett hittats kommer de resterande inte
ens att kontrolleras.

Att använda allt för många `else if`-uttryck kan kladda ner din kod, så om du
har mer än ett kanske du vill omfaktorisera din kod. Kapitel 6 beskriver en
kraftfull förgreningskonstruktion i Rust som kallas `match` för dessa fall.

#### Att använda `if` i en `let`-sats

Eftersom `if` är ett uttryck kan vi använda det på högersidan om en `let`-sats,
så som i listning 3-2.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let condition = true;
    let number = if condition {
        5
    } else {
        6
    };

    println!("The value of number is: {}", number);
}
```

<span class="caption">Listning 3-2: Tilldelning av resultatet från ett
`if`-uttryck till en variabel</span>

`number`-variabeln kommer att bindas till ett värde baserat på utkomsten av
`if`-uttrycket. Kör denna kod för att se vad som händer:

```text
$ cargo run
   Compiling branches v0.1.0 (file:///projects/branches)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
     Running `target/debug/branches`
The value of number is: 5
```

Kom ihåg att block med kod utvärderas till det sista uttrycket i dem och
ensamma tal är också uttryck. I detta fall beror värdet av hela `if`-uttrycket
på om vilket block kod om körs. Detta innebär att värden som har potentialen
att vara resultat från varje arm av `if` måste vara av samma typ; i listning 3-2
är både resultatet från `if`-armen och `else`-armen `i32`-heltal. Om typerna
inte stämmer så som i följande exempel, kommer vi att få ett fel:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let condition = true;

    let number = if condition {
        5
    } else {
        "six"
    };

    println!("The value of number is: {}", number);
}
```

När vi försöker att kompilera denna kod kommer vi att få ett fel. `if` och
`else`-armarna har värdetyper som är inkompatibla och Rust indikerar exakt var
man hittar problemet i programmet:

```text
error[E0308]: if and else have incompatible types
 --> src/main.rs:4:18
  |
4 |       let number = if condition {
  |  __________________^
5 | |         5
6 | |     } else {
7 | |         "six"
8 | |     };
  | |_____^ expected integral variable, found &str
  |
  = note: expected type `{integer}`
             found type `&str`
```

Uttrycket i `if`-blocket utvärderas till ett heltal och uttrycket i
`else`-blocket utvärderas till en sträng. Detta kommer inte att fungera då
variabler måste ha en enda typ. Rust måste vid kompileringstid slutgiltigt veta
vad typen för variabeln `number` är, så att det kan verifiera vid
kompileringstid att dess type är giltig på alla ställen vi använder `number`.
Rust skulle inte kunna göra det om typen för `number` endast bestämts vid
körtid; kompilatorn skulle behöva mycket mer komplex och kunna utfärda färre
garantier om koden om det var tvunget att hålla koll på flera hypotetiska typer
för varje variabel.

### Repetition med loopar

Det är ofta användbart att köra ett block kod mer än en gång. För denna uppgift
tillhandahåller Rust flera olika *loopar*. En loop kör genom koden inuti
loopkroppen till slutet och börjarar därefter direkt om vid början. För att
experimentera med loopar, låt oss skapa ett nytt projekt kallat *loops*.

Rust har tre sorters loopar: `loop`, `while` och `for`. Låt oss prova var och
en.

#### Repetera kod med `loop`

Nyckelordet `loop` berättar för Rust att det ska köra ett block kod om och om
igen för evigt, eller tills du uttryckligen ber det att sluta.

Som ett exempel ändra filen *src/main.rs* i din *loops*-katalog så den ser ut
så här:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
fn main() {
    loop {
        println!("again!");
    }
}
```

När vi kör detta program kommer vi att se `again!` kontinuerligt skrivas ut om
och om igen tills vi avslutar programmet manuellt. De flesta terminaler har stöd
för en tangentbordsgenväg, <span class="keystroke">ctrl-c</span>, för att
avbryta ett program som fastnat i en kontinuerlig loop. Prova det:

```text
$ cargo run
   Compiling loops v0.1.0 (file:///projects/loops)
    Finished dev [unoptimized + debuginfo] target(s) in 0.29 secs
     Running `target/debug/loops`
again!
again!
again!
again!
^Cagain!
```

Symbolen `^C` representerar där du trycket <span
class="keystroke">ctrl-c</span>. Du kan eventuellt se ordet `again!` utskrivet
efter `^C` beroende på var koden var i loopen när det erhöll avbrottssignalen.

Som tur är erbjuder Rust ett annat, tillförlitligare sätt att bryta ut ur en
loop. Du kan placera nyckelordet `break` inuti loopen för att berätta för
programmet när det ska sluta köra loopen. Kom ihåg att vi gjorde detta i
gissningsspelet i avsnittet [”Avsluta efter en korrekt
gissning”][avsluta-efter-en-korrekt-gissning]<!-- ignore --> i kapitel 2 för
att avsluta programmet när användaren vann spelet genom att gissa det korrekta
talet.

#### Returnera värden från loopar

En av användningsområdena för en `loop` är att prova en åtgärd på nytt som du
vet skulle kunna misslyckas, så som att kontrollera huruvida en tråd har
avslutat sitt jobb. Eventuellt behöver du skicka värdet för den åtgärden till
resten av din kod. För att göra detta kan du lägga till värdet du vill
returnera efter `break`-uttrycket du använde för att stoppa loopen; det värdet
kommer att returneras ut från loopen så att du kan använda det, så som visas
här:

```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {}", result);
}
```

Före loopen deklarerar vi en variabel vid namn `counter` och initialiserar den
till `0`. Vi deklarerar sedan en variabel med namnet `result` som håller värdet
som returneras från loopen. För varje iteration i loopen kommer vi att lägga
till `1` till variabeln `counter`, och sedan kontrollera huruvida räknaren är
lika med `10`. När den är det kan vi använda nyckelordet `break` med värdet
`counter * 2`. Efter loopen använder vi ett semikolon för att avsluta satsen
som tilldelar värdet till `result`. Avslutningsvis skriver vi ut värdet i
`result`, vilket i detta fallet är 20.

#### Villkorade loopar med `while`

Det är ofta användbart för att program att utvärdera ett villkor inom en loop.
Så länge villkoret är sant körs loopen. När villkoret slutar att vara sant
anropar programmet `break` och avslutar loopen. Denna looptyp skulle kunna
implementeras med en kombination av `loop`, `if`, `else` och `break`; du skulle
kunna prova det i ett program nu, om du vill.

Detta mönster är dock så pass vanligt att Rust har en inbyggt språkkonstruktion
för detta, kallat en `while`-loop. Listning 3-3 använder `while`: programmet
loopar tre gånger, räknar ner varje gången och sedan, efter loopen, skriver det
ut ett annat meddelande och avslutar.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{}!", number);

        number -= 1;
    }

    println!("LIFTOFF!!!");
}
```

<span class="caption">Listning 3-3: Användning av en `while`-loop för att köra
kod medan ett villkor är sant</span>

Denna konstruktion eliminerar en massa nästling som annars skulle behövas om du
använde `loop`, `if`, `else` och `break`, och det är tydligare. När ett uttryck
är sant kör korden; annars avslutas loopen.

#### Loopa genom en samling med `for`

Du skulle kunna använda `while`-konstruktionen för att loopa över elementen i
en samling, så som en array. Låt oss till exempel titta på listning 3-4.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];
    let mut index = 0;

    while index < 5 {
        println!("the value is: {}", a[index]);

        index += 1;
    }
}
```

<span class="caption">Listning 3-4: Loopa över alla element i en samling med
hjälp av en `while`-loop</span>

Här räknar koden upp för varje element i array:en. Det börjar på index `0` och
loopar sedan tills det når det sista indexet i array:en (det vill säga när
`index < 5` inte längre är sant). Om du kör denna kod kommer den att skriva ut
varje element i array:en:

```text
$ cargo run
   Compiling loops v0.1.0 (file:///projects/loops)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
     Running `target/debug/loops`
the value is: 10
the value is: 20
the value is: 30
the value is: 40
the value is: 50
```

Alla fem arrayvärdena visas i terminalen, precis som väntat. Även än `index`
kommer att nå värdet `5` vid någon punkt, kommer loopen att sluta köras innan
det försöker att hämta ett sjätte värdet från array:en.

Men detta sätt är benäget att ha fel; vi skulle kunna orsaka att programmet får
en panik om indexlängden är felaktig. Det är också långsamt eftersom
kompileratorn lägger till kod i körtid för att utföra den villkorade kontrollen
för varje element vid varje iteration genom loopen.

Som ett mer koncist alternativt kan du använda en `for`-loop och köra viss kod
för varje element i en samling. En `for`-loop ser ut som koden i listning 3-5.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];

    for element in a.iter() {
        println!("the value is: {}", element);
    }
}
```

<span class="caption">Listning 3-5: Loopa genom varje element i en samling via
en `for`-loop</span>

När vi kör denna kod kommer vi att se samma utmatning som för listning 3-4
ovan. Väsentligare är att vi nu förbättrat säkerheten i koden och eliminerat
möjligheten till fel som uppstår när man avancerar bortom slutet på array:en
eller inte avancerar långt nog och hoppar över några element.

Om du till exempel i koden i listning 3-4 tog bort ett element från array:en
`a`, men glömt att uppdatera villkoret till `while index < 4` skulle koden få en
panik. Genom att använda `for`-loopen behöver du inte komma ihåg att ändra
någon annan kod och du ändrade antalet värden i array:en.

Säkerheten och koncisheten för `for`-loopar gör dem till den mest frekvent
använda loopkonstruktionen i Rust. Även i situationer där du kanske vill köra
vissa kod ett specifikt antal gånger, så som i nedräkningen exemplet som
använde en `while`-loop i listning 3-3, hade de flesta Rust-användare använt en
`for`-loop. Sättet att göra det på är genom att använda en `Range`, vilket är
en typ som tillhandahålls av standardbiblioteket som genererar alla tal i
sekvens med start från ett tal och med slut vid ett annat tal.

Så här skulle nedräkningen ha sett ut med en `for`-loop och en annan metod,
`rev`, som vi ännu inte diskuterat, för att vända på intervallet:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    for number in (1..4).rev() {
        println!("{}!", number);
    }
    println!("LIFTOFF!!!");
}
```

Denna koden är lite trevligare, inte sant?

## Sammanfattning

Du klarade det! Det var ett stort kapitel: du har lärt dig variabler, skalära
och sammansatta datatyper, funktioner, kommentarer, `if`-uttryck och loopar! Om
du vill öva på koncepten som diskuteras i detta kapitel, försök att bygga
program för att göra följande:

* Konvertera temperaturer mellan Fahrenheit och Celsius.
* Generera de N:te Fibonacci-talet.
* Skriv ut texten till julsången ”The Twelve Days of Christmas”, genom att dra
  nytta av repetitionerna i sången.

När du är redo att gå vidare, kommer vi att tala om ett koncept i Rust som
vanligen *inte* finns i andra programmeringsspråk: ägarskap.

[jamfora-gissningen-med-det-hemliga-talet]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[avsluta-efter-en-korrekt-gissning]:
ch02-00-guessing-game-tutorial.html#quitting-after-a-correct-guess
