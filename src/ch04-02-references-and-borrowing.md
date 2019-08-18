## Referenser och lån

Problemet med tupel-koden i listning 4-5 är att vi måste returnera `String`
till den anropande funktionen så vi fortfarande kan använda `String` efter
anropet till `calculate_length`, eftersom `String` flyttades in i
`calculate_length`.

Så här skulle du kunna definiera och använda en `calculate_length`-funktion som
har en referens till ett objekt som en parameter istället för att ta ägandeskap
över värdet:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

För det första, notera att all tupelkoden i variabeldeklarationen och
funktionens returvärde är borta. För det andra, notera att vi skickar in `&s1`
i `calculate_length` och i dess definition tar vi `&String` snarare än
`String`.

Dessa och-tecken är *referenser* och de låter dig referera till värden utan att
ta ägandeskap över dem. Figur 4-5 visare ett diagram.

<img alt="&String s pointing at String s1" src="img/trpl04-05.svg" class="center" />

<span class="caption">Figur 4-5: Ett diagram över hur `&String s` pekar på `String
s1`</span>

> Notera: Motsatsen till att referera genom att använda `&` är att
> *dereferera*, vilket åstadkoms med derefereringsoperatorn, `*`. Vi kommer
> att se användning av derefereringsoperatorn i kapitel 8 och diskutera
> detaljerna kring dereferering i kapitel 15.

Låt oss ta en närmare titt på funktionsanropet här:

```rust
# fn calculate_length(s: &String) -> usize {
#     s.len()
# }
let s1 = String::from("hello");

let len = calculate_length(&s1);
```

Syntaxen `&s1` låter oss skapa en referens som *refererar* till värdet i `s1`,
men äger inte det. Eftersom det inte äger det kommer värdet den pekar till inte
att frigöras när referensen faller utom räckvidd.

På samma sätt använder signaturen för funktionen `&` för att indikera att typen
för parametern `s` är en referens. Låt oss lägg till lite förklarande
noteringar:

```rust
fn calculate_length(s: &String) -> usize { // s är en referens till en String
    s.len()
} // Här faller s utom räckvidd. Men då den inte har något ägandeskap över det
  // som den refererar till händer ingenting.
```

Räckvidden inom vilken variabeln `s` är giltig är samma som för andra
funktionsparameterars räckvidd, men vi frigör inte det som referensen pekar på
när den faller utom räckvidd eftersom vi inte har tagit ägandeskap. När
funktioner har referenser som parametrar istället för de faktiska värdena
behöver vi inte returnera värdena för att återge ägandeskapet, då vi aldrig
tagit ägandeskapet från första början.

Vi kallar att ha funktionsparametrar som referenser för *lån*. På som samma
sätt som in verkliga livet, om en person äger någonting kan du låna det från
dem. När du är klar måste du ge tillbaka det du lånat.

Så vad händer om vi försöker att modifiera någonting vi lånat? Prova koden i
listning 4-6. Tips: det fungerar inte!

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let s = String::from("hello");

    change(&s);
}

fn change(some_string: &String) {
    some_string.push_str(", world");
}
```

<span class="caption">Listning 4-6: Försök att modifiera att lånat värde</span>

Här är felet:

```text
error[E0596]: cannot borrow immutable borrowed content `*some_string` as mutable
 --> error.rs:8:5
  |
7 | fn change(some_string: &String) {
  |                        ------- use `&mut String` here to make mutable
8 |     some_string.push_str(", world");
  |     ^^^^^^^^^^^ cannot borrow as mutable
```

Variabler är oföränderliga som standard och det gäller referenser också. Vi får
inte modifiera någonting vi har en referens till.

### Föränderliga referenser

Vi kan fixa felet i koden i listning 4-6 genom en liten ändring:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

Först var vi tvungna att ändra `s` till att vara `mut`. Sedan var vi tvungna
att skapa en föränderlig referens med `&mut s` och acceptera en föränderlig
referens med `some_string: &mut String`.

Men föränderliga referenser har en stor begränsning: du kan bara har en
föränderlig referens till en specifik bit data i en specifik räckvidd. Denna
kod kommer att misslyckas:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
let mut s = String::from("hello");

let r1 = &mut s;
let r2 = &mut s;

println!("{}, {}", r1, r2);
```

Här är felet:

```text
error[E0499]: cannot borrow `s` as mutable more than once at a time
 --> src/main.rs:5:14
  |
4 |     let r1 = &mut s;
  |              ------ first mutable borrow occurs here
5 |     let r2 = &mut s;
  |              ^^^^^^ second mutable borrow occurs here
6 |
7 |     println!("{}, {}", r1, r2);
  |                        -- first borrow later used here
```

Denna restriktion tillåter föränderlighet men på ett väldigt kontrollerat sätt.
Det är något som nya Rust-användare har problem med, då de flesta språk låter
dig förändra saker när du känner för det.

Fördelen med att ha denna begränsning är att Rust kan förhindra kapplöpning vid
kompileringstid. *Kapplösning* liknar ett konkurrenstillstånd och inträffar när
dessa tre beteende förekommer:

* Två eller fler pekare arbetar på samma data samtidigt.
* Åtminstone en av pekarna används för att skriva till datan.
* Det finns ingen mekanism för att synkronisera åtkomst till datan.

Kapplöningar orsakar odefinierat beteende och kan vara svåra att diagnostisera
och åtgärda när du försöka att språka upp dem i körtid; Rust förhindrar dessa
problem från att inträffa då det inte ens kommer att låta kod med kapplöpningar
kompilera!

Som alltid kan vi använda klammerparenteser för att skapa en ny räckvidd,
vilket möjliggör för föränderliga referenser, dock inte *samtidigt*:

```rust
let mut s = String::from("hello");

{
    let r1 = &mut s;

} // r1 faller utom räckvidd här så vi kan skapa en ny referens utan problem.

let r2 = &mut s;
```

En liknande regel existerar för att kombinera föränderliga och oföränderliga
referenser. Denna kod resulterar i ett fel:

```rust,ignore,does_not_compile
let mut s = String::from("hello");

let r1 = &s; // inget problem
let r2 = &s; // inget problem
let r3 = &mut s; // STORT PROBLEM

println!("{}, {}, and {}", r1, r2, r3);
```

Här är felet:

```text
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable
 --> src/main.rs:6:14
  |
4 |     let r1 = &s; // inget problem
  |              -- immutable borrow occurs here
5 |     let r2 = &s; // inget problem
6 |     let r3 = &mut s; // STORT PROBLEM
  |              ^^^^^^ mutable borrow occurs here
7 |
8 |     println!("{}, {}, and {}", r1, r2, r3);
  |                                -- immutable borrow later used here
```

Puh! Vi kan *heller* inte ha en föränderlig referens medan vi har en
oföränderlig referens. Användare av en oföränderlig referens förväntar sig inte
att värdet plötsligt kan ändras under deras fötter! Men flera oföränderliga
referenser är okej eftersom någon som bara läser datan har möjlighet att
påverkar någon annans läsning av datan.


Notera att räckvidden för en referens börjar där den introduceras och
fortsätter fram till sista gången referensen används. Denna koden kommer till
exempel att kompilera eftersom den sista användningen av de oföränderliga
referenserna sker för den oföränderliga referensen introduceras:

<!-- Detta exempel hoppas över eftersom det finns ett fel i rustdoc som gör att
edition2018 inte fungerar. Felet är för närvarande fixat i nightly, så när vi
uppdaterar boken till >= 1.35 kan `ignore` tas bort från detta exempel. -->

```rust,edition2018,ignore
let mut s = String::from("hello");

let r1 = &s; // inget problem
let r2 = &s; // inget problem
println!("{} and {}", r1, r2);
// r1 och r2 används inte längre efter denna punkt

let r3 = &mut s; // inget problem
println!("{}", r3);
```

Räckvidderna för de oföränderliga referenserna `r1` och `r2` slutar efter
`println!` där de sist används, vilket är före den föränderliga referensen `r3`
skapas. Dessa räckvidder överlappar inte, så koden tillåts.

Även om lånfel kan vara frustrerande ibland, kom ihåg att det är
Rust-kompilatorn som pekar ur ut ett eventuellt fel tidigt (vid kompileringstid
snarare än i körtid) och visar dig exakt var problemet är. Då behöver du inte
spåra upp var din data plötsligt inte är som du förväntar dig.

### Hängande referenser

I språk med pekare är det lätt att av misstag skapa en *hängande pekare*, en
pekare som refererar till en position i minnet som också kan ha givits till
någon annan, genom att frigöra en bit minne medan pekaren till det minne
bevaras. I kontrast garanterar kompilatorn i Rust att referenser inte kommer
att vara hängande referenser: om du har en referens till en bit data så kommer
kompilatorn att säkerställa att datan inte kommer att fall utom räckvidd innan
referensen till datan gör det.

Låt oss försöka att skapa en hängde referens, vilket Rust kommer att förhindra
med ett fel i kompileringstid:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String {
    let s = String::from("hello");

    &s
}
```

Här är felet:

```text
error[E0106]: missing lifetime specifier
 --> main.rs:5:16
  |
5 | fn dangle() -> &String {
  |                ^ expected lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but there is
  no value for it to be borrowed from
  = help: consider giving it a 'static lifetime
```

Detta felmeddelande refererar till något som vi inte diskuterat än: livstider.
Vi kommer att diskutera livstider i detalj i kapitel 10. Men om du bortser från
delarna om livstider så innehåller meddelandet nyckeln till varför denna koden
är ett problem:

```text
this function's return type contains a borrowed value, but there is no value
for it to be borrowed from.
```

Låt oss ta en närmare titt på exakt vad som händer vid varje steg i vår
`dangle`-kod:

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore
fn dangle() -> &String { // dangle returnerar en referens till en String

    let s = String::from("hello"); // s är en ny String

    &s // vi returnerar en referens till vår String, s
} // Här faller s utom räckvidd och frigörs. Dess minne försvinner.
  // Farligt!
```

Eftersom `s` skapats inuti `dangle` kommer `s` att avallokeras när koden för
`dangle` tar slut. Men vi försökte att returnera en referens till den. Det
innebär att denna referens skulle ha pekat på en ogiltig `String`. Det är inte
bra! Rust kommer inte tillåta oss att göra detta.

Lösningen här är att returnera `String` direkt:

```rust
fn no_dangle() -> String {
    let s = String::from("hello");

    s
}
```

Detta fungerar utan problem. Ägandeskapet flyttas ut och ingenting avallokeras.

### Reglerna för referenser

Låt oss sammanfatta vad vi diskuterat om referenser:

* Vid varje given tidpunkt kan du ha *antingen* en föränderlig referens *eller*
  ett godtyckligt antal oföränderliga referenser.
* Referenser måste alltid vara giltiga.

Härnäst kommer vi att titta på en annan typ av referens: skivor.
