## Variabler och föränderlighet

Som nämnts i kapitel 2 är variabler som standard oföränderliga. Detta är en av
flera sätt Rust försöker knuffa dig i rätt riktigt för att skriva kod på ett
sätt som utnyttjar säkerheten och den lättanvända samtidighet som Rust
erbjuder. Men du har fortfarande alternativet att göra dina variabler
föränderliga. Låt oss undersöka hur och varför Rust förespråkar att du i första
hand använder oföränderliga variabler och varför du ibland kan behöva välja
något annat.

När en variabel är oföränderlig kan du inte ändra dess värde efter att ett
värde en gång har bundits till dess namn. För att illustrera detta, låt oss
generera ett nytt projekt kallat *variables* i din *projects*-katalog genom att
använda `cargo new variables`.

Öppna sedan *src/main.rs* i din nya *variables*-katalog och ersätt dess kod med
följande kod, som inte kompilerar riktigt än:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

Spara och kör programmet med `cargo run`. Du bör få ett felmeddelande, så som
visas i denna utmatning:

```text
error[E0384]: cannot assign twice to immutable variable `x`
 --> src/main.rs:4:5
  |
2 |     let x = 5;
  |         - first assignment to `x`
3 |     println!("The value of x is: {}", x);
4 |     x = 6;
  |     ^^^^^ cannot assign twice to immutable variable
```

Detta exempel visar hur kompilatorn hjälper dig att hitta fel i dina program.
Även om kompilatorfel kan vara frustrerande innebär de bara att ditt program
inte gör var du önskar på ett säkert sätt än; de innebär *inte* att du inte är
en bra programmerare! Erfarna Rust-användare får fortfarande kompilatorfel

Felmeddelandet indikerar att orsaken till felet är att du `cannot assign twice
to immutable variable x`, eftersom du försökte att tilldela ett andra värde
till den oföränderliga variabeln `x`.

Det är viktigt att vi får fel vid kompileringstid när vi försöker att ändra ett
värde som vi tidigare betecknat som oföränderligt eftersom just denna situation
kan leda till programfel. Om en del av din kod förutsätter att ett värde aldrig
kommer att förändras och en annan del av koden ändrar det värdet är det möjligt
att den första delen av koden inte gör var den designades till att göra.
Orsaken till denna type av fel kan vara svårt att spåra, speciellt när den
andra delen av koden bara ändra värdet *ibland*.

I Rust garanterar kompilatorn att när du säger att ett värde inte kommer att
ändras, då kommer det verkligen inte att förändras. Detta innebär att när du
läser eller skriver kod, behöver du inte hålla koll på hur och var ett värde
kan ändras. Din kod är därför enklare att resonera kring.

Men föränderlighet kan vara väldigt användbart. Variabler är oföränderliga
enbart som standard; du kan få dem, som du gjorde i kapitel 2, att vara
föränderliga genom att lägga till `mut` före variabelnamnet. Förutom att
tillåta att värdet ändras förmedlar `mut` till framtida läsare av koden att
andra delar av koden kommer att ändra detta variabelvärde.

Låt oss till exempel ändra *src/main.rs* enligt följande:

<span class="filename">Filename: src/main.rs</span>

```rust
fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

När vi nu kör programmet får vi detta:

```text
$ cargo run
   Compiling variables v0.1.0 (file:///projects/variables)
    Finished dev [unoptimized + debuginfo] target(s) in 0.30 secs
     Running `target/debug/variables`
The value of x is: 5
The value of x is: 6
```

Vi tillåts ändra värdet som `x` binder till från `5` till `6` när `mut`
används. I vissa fall kan du komma att vilja göra en variable föränderlig
eftersom det gör koden enklare att skriva än om den endast hade oföränderliga
variabler.

Det finns flera avvägningar att begrunda utöver förebyggande av buggar. Till
exempel för fall där du använder stora datastrukturer kan det vara snabbare att
förändra en instans på plats snarare än att kopiera och returnera nyallokerade
instanser. Med mindre datastrukturer kan skapande av nya instanser och att
skriva kod i en mer funktionell programmeringsstil vara enklare att resonera
kring, så sämre prestanda kan kanske vara värt det för att få denna bättre
tydlighet.

### Skillnader mellan variabler och konstanter

Att inte kunna ändra en variabels värde kan ha påmint dig om ett annat
programmeringskoncept som de flesta andra språk har: *konstanter*. På samma
sätt som oföränderliga variabler är konstanter värden som är bundna till ett
namn och inte tillåts ändras, men det finns ett antal skillnader mellan
konstanter och variabler.

För det första tillåts du inte använda `mut` med konstanter. Konstanter är inte
bara oföränderliga som standard, de är alltid oföränderliga.

Du deklarerar konstanter med nyckelordet `const` istället för nyckelordet
`let`, och typen för värdet *måste* märkas upp. Vi kommer i nästa avsnitt att
gå in på typer och typmarkeringar, [”Datatyper”][datatyper]<!-- ignore --> så
oroa dig inte över detaljerna just nu. Kom bara ihåg att du alltid måste ange
typen.

Konstanter kan deklareras inom vilken räckvidd som helst, inklusive den globala
räckvidden, vilket gör dem användbara för värden som många delar av koden måste
känna till.

Den sista skillnaden är att konstanter bara får tilldelas ett konstant uttryck,
inte resultatet av ett funktionsanrop eller ett annat värde som endast kan
räknas ut i körtid.

Här är ett exempel på en konstantdeklaration där konstantens namn är
`MAX_POINTS` och dess värde är 100 000. (Rusts namnkonvention för konstanter är
att använda versaler med understreck mellan ord, och understreck kan även
skjutas in i numeriska literaler för förbättrad läsbarhet):

```rust
const MAX_POINTS: u32 = 100_000;
```

Konstanter är giltiga under hela tiden ett program kör, inom den räckvidd de
deklarerats, vilket gör dem till ett bra val för värden i din programdomän som
flera delar av programmet behöver känna till, så som maximalt antal poäng eller
spelar i ett spel kan få eller ljusets hastighet.

Att namnge hårdkodade värden som används i ditt program som konstanter är
användbar för de som i framtiden underhåller koden. Det hjälper också att du
bara behöver ändra på ett stället i koden om det hårdkodade värdet måste
uppdateras i framtiden.

### Skuggning

Som du såg i handledningen för gissningsspelet i avsnittet [”Jämföra gissningen
med det hemliga talet”][jämföra-gissningen-med-det-hemliga-talet]<!--- ignore
--> i kapitel2 kan du deklarera en ny variabel med samma namn som en föregående
variabel, och den nya variabeln kommer att skugga den föregående variabeln.
Rust-användar säger att den första variabeln *skuggas* av den andra, vilket
innebär att den andra variabelns värde är vad som dyker upp när variabeln
används. Vi kan skugga en variable genom att använda samma variabelnamn och
repetera användningen av `let`-nyckelordet på detta sätt:

<span class="filename">Filename: src/main.rs</span>

```rust
fn main() {
    let x = 5;

    let x = x + 1;

    let x = x * 2;

    println!("The value of x is: {}", x);
}
```

Detta program binder först `x` till värdet `5`. Sedan skuggar det `x` genom att
repetera `let x =`, ta originalvärdet och lägga till `1` så att värdet av `x`
blir `6`. Den tredje `let`-satsen skuggar också `x`, genom att multiplicera det
föregående värdet med `2` så att `x` får det slutliga värdet `12`. När du kör
detta program kommer det att mata ut följande:

```text
$ cargo run
   Compiling variables v0.1.0 (file:///projects/variables)
    Finished dev [unoptimized + debuginfo] target(s) in 0.31 secs
     Running `target/debug/variables`
The value of x is: 12
```

Skuggning skiljer sig från att markera en variabel som `mut`, eftersom vi
kommer att få ett fel vid kompileringstid om vi råkar försöka tilldela denna
variabel på nytt utan att använda nyckelordet `let`. Genom att använda `let`
kan vi utföra ett antal transformationer på värdet men låta variabeln vara
oföränderlig efter att de transformationerna har slutförts.

Det andra skillnaden mellan `mut` och skuggning är att eftersom vi i princip
skapar en ny variabel när vi på nytt använder nyckelordet `let`, kan vi ändra
värdets typ, men behålla samma namn. Låt säga att ditt program ber en
användare visa hur många blanksteg den önskar mellan textsträngar genom att
mata in blanksteg, men vi faktiskt vill spara den inmatningen som ett nummer:

```rust
let spaces = "   ";
let spaces = spaces.len();
```

Denna konstruktion är tillåten eftersom den första `spaces`-variabeln är av
strängtyp och den andra `spaces`-variabeln, vilken är en helt ny variabel som
råkar ha samma namn som den första, är av numerisk typ. Skuggning besparar oss
därför från att komma på nya namn, så som `spaces_str` och `spaces_num`;
istället kan vi återanvända det enklare namnet `spaces`. Om vi däremot försöker
använda `mut` för fallet som visas här kommer vi att få ett fel vid
kompileringstid:

```rust,ignore,does_not_compile
let mut spaces = "   ";
spaces = spaces.len();
```

Felet säger att vi inte tillåts förändra en variabels typ:

```text
error[E0308]: mismatched types
 --> src/main.rs:3:14
  |
3 |     spaces = spaces.len();
  |              ^^^^^^^^^^^^ expected &str, found usize
  |
  = note: expected type `&str`
             found type `usize`
```

Nu när vi utforskat hur variabler fungerar, låt oss titta på flera av de
datatyper som de kan ha.

[jämföra-gissningen-med-det-hemliga-talet]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[datatyper]: ch03-02-data-types.html#data-types
