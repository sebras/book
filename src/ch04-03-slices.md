## Skivtypen

En annan datatyp som inte har något ägandeskap är *skivan*. Skivor låter dig
referera till en kontinuerlig sekvens av element i en samling snarare än hela
samlingen.

Här är ett litet programmeringsproblem: skriv en funktion som tar en sträng och
som returnerar det första order det hittar i den strängen. Om funktionen inte
hittar ett blanksteg i strängen, måste hela strängen vara ett ord, så hela
strängen bör returneras.

Låt oss tänka kring signaturen för denna funktion:

```rust,ignore
fn first_word(s: &String) -> ?
```

Denna funktion, `first_word`, har en `&String` som en parameter. Vi vill inte
ha ägandeskap så detta går bra. Men vad ska vi returnera? Vi har egentligen
inget sätt att tala om en *delmängd* av en sträng. Men vi skulle kunna
returnera indexet för slutet på ordet. Låt oss prova det i listning 4-7.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn first_word(s: &String) -> usize {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return i;
        }
    }

    s.len()
}
```

<span class="caption">Listning 4-7: Funktionen `first_word` som returnerar ett
byteindex in i `String`-parametern</span>

Eftersom vi måste gå genom `String` element för element och kontrollera
huruvida värdet är ett blanksteg kommer vi att konvertera vår `String` till en
array av bytes med hjälp av metoden `as_bytes`:

```rust,ignore
let bytes = s.as_bytes();
```

Härnäst skapar vi en iterator över bytearrayn via metoden `iter`:

```rust,ignore
for (i, &item) in bytes.iter().enumerate() {
```

Vi kommer att diskutera iteratorer i ytterligare detalj i Kapitel 13. För
närvarande räcker det att veta att `iter` är en metod som returnerar varje
element i en samling och att `enumerate` omsluter resultatet från `iter` och
returnerar varje element som en del av en tupel istället. Det första element i
tupeln som returneras från `enumerate` är indexet och det andra elementet är en
referens till elementet. Detta är lite bekvämare än om vi beräknar indexet
själva.

Då metoden `enumerate` returnerar en tupel kan vi använda mönster för att
destrukturera denna tupel, precis som på all andra platser i Rust. Så i
`for`-loopen anger vi ett mönster som har `i` för indexert i tupeln och `&item`
för den enskilda byten i tupeln. Eftersom vi får en referens till elementet
från `.iter().enumerate()` använder vi `&` i mönstret.

Inuti `for`-loopen söker vi efter byten som representerar blanksteg genom att
använda syntaxen för byteliteraler. Om vi hittar ett blanksteg returnerar vi
positionen. Annars returnerar vi längden på strängen genom att använda
`s.len()`:

```rust,ignore
    if item == b' ' {
        return i;
    }
}

s.len()
```
Vi har nu ett sätt att hitta vårt index på slutet av det första ordet i
strängen, men det finns ett problem. Vi returnerar en separat `usize`, men det
är bara ett meningsfullt nummer i samband med vår `&String`. Med andra ord, då
det är ett värde separat från vår `String` så finns det ingen garanti att den
fortfarande kommer att vara giltig i framtiden. Betänk programmet i listning
4-8 som använder funktionen `first_word` från listning 4-7.

<span class="filename">Filnamn: src/main.rs</span>

```rust
# fn first_word(s: &String) -> usize {
#     let bytes = s.as_bytes();
#
#     for (i, &item) in bytes.iter().enumerate() {
#         if item == b' ' {
#             return i;
#         }
#     }
#
#     s.len()
# }
#
fn main() {
    let mut s = String::from("hello world");

    let word = first_word(&s); // word kommer att få värdet 5

    s.clear(); // detta tömmer strängen, vilket likställer den med ""

    // word har fortfarande värdet 5 här, men det finns inte längre någon
    // sträng som vi på ett meningsfullt sätt kan använda värdet 5 med. word är
    // nu heltigenom ogiltigt!
}
```

<span class="caption">Listning 4-8: Att spara värdet från anropet från
funktionen `first_word` och sedan ändra innehållet i `String`</span>

Detta program kompilerar utan några fel och skulle även göra det om vi använde
`word` efter att ha anropat `s.clear()`. Då `word` inte alls är länkat till
tillståndet i `s` kommer `word` fortfarande att innehålla värdet `5`. Vi skulle
kunna använda värdet `5` tillsammans med variabeln `s` för att extrahera det
första ordet, men detta skulle vara ett programfel då innehållet i `s` har
ändrats sedan vi sparade `5` i `word.

Att behöva bry sig om att indexet i `word` blir osynkroniserat med datan i `s`
är tråkigt och benäget att resultera i fel! Att hantera dessa index blir ännu
mer skört om vi skapare en funktion `second_word`. Dess signatur skulle behöva
se ut något i stil med:

```rust,ignore
fn second_word(s: &String) -> (usize, usize) {
```

Vi måste nu hålla reda på både ett inledande *och* ett avslutande index, och vi
har än fler värden som beräknades från data i ett särskilt tillstånd men som
inte är alls är sammanlänkade. Vi har nu tre orelaterade variabler som flyter
runt men som måste hållas synkroniserade.

Som tur är har Rust en lösning på detta problem: strängskivor.

### Strängskivor

En *strängskiva* är en referens till en delmängd av en `String` och ser ut så
här:

```rust
let s = String::from("hello world");

let hello = &s[0..5];
let world = &s[6..11];
```

Detta liknar att ta en referens till hela strängen `String`, men med den extra
avslutningen `[0..5]`. Snarare än att ta en referens till hela `String` är det
en referens till en del av `String`.

Vi kan skapa skivor genom att använda ett intervall inom klammerparenteser
genom att ange `[startindex..slutindex]` där `startindex` är den första
positionen i skivan och `slutindex` är indexet direktefter den sista positionen
i skivan. Internt sparar datastrukturen för skivan startpositionen och längden
för skivan, vilket motsvararar `slutindex` minus `startindex`. Så i fallet med
`let world = &s[6..11];`, kommer `world` att vara en skiva som innehåller en
pekare till den sjunde byten i `s` med en längd som är 5.

Figur 4-6 visar detta i ett diagram.

<img alt="world innhåller en pekare till den sjätte byten i String s och en längd som är 5" src="img/trpl04-06.svg" class="center" style="width: 50%;" />

<span class="caption">Figur 4-6: Strängskiva som refererar till en delmängd av
en `String`</span>

Med Rusts intervallsyntax `..`, kan du om du vill börja med det första indexet
(noll) genom att hoppa över värdet före de två punkterna. Med andra ord är
dessa två ekvivalenta:

```rust
let s = String::from("hello");

let slice = &s[0..2];
let slice = &s[..2];
```

På samma sätt kan du hoppa över det avslutande talet om din skiva inkluderar
den sista byten i `String. Detta innebär att dessa två är ekvivalenta:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[3..len];
let slice = &s[3..];
```

Du kan också skippa båda värdena för att ta en skiva av hela strängen, så dessa
är också ekvivalenta:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[0..len];
let slice = &s[..];
```

> Notera: Intervallindex för strängskivor måste ske på giltiga teckengränser
> för UTF-8-tecken. Om du försöker att skapa en strängskiva i mitten av ett
> flerbytestecken kommer ditt program att avslutas med ett fel. När vi
> introducerar strängskivor i detta avsnitt antar vi att endast ASCII används;
> en mer genomgripande diskussion kring UTF-8-hantering finns i avsnittet
> [“Lagra UTF-8-kodad text i strängar“][strängar]<!-- ignore --> i kapitel 8.

Med all denna information friskt i minne, låt oss skriva om `first_word` så att
den returnerar en skiva. Typen som betecknar “strängskiva“ skrivs som `&str`:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
```

Vi får ett index för slutet av ordet på samma sätt som vi gjorde i listning
4-7, genom att leta efter den första förekomsten av ett blanksteg. Ni vi hittar
ett blanksteg returnerar vi en stängskiva från starten av strängen till indexet
för blanksteget som start- och slutindex.

När vi nu anropar `first_word` får vi tillbaka ett enstaka värde som är länkar
till den underliggande datan. Värdet består av en referens till startpunkten av
skivan och antalet i element i skivan.

Att returnerar en skiva hade också fungerat för funktionen `second_word`:

```rust,ignore
fn second_word(s: &String) -> &str {
```

Vi har nu ett enkelt API som det är mycket svårare att göra fel med, då
kompilatorn kommer att säkertsälla att referenserna in i `String` kommer att
fortsätta vara giltiga. Kommer du ihåg programfelet i programmet i listning 4-8
när vi fick indexet till det första ordet men sedan rensade strängen så att
vårt index blev ogiltigt? Den koden var logiskt felaktig men visade ingen
uppenbara fel. Problemen hade uppstått senare om vi hade fortsatt att använda
indexet till det första ordet med en tömd sträng. Skivor gör denna typ av
programfel omöjlig och låter oss veta att vi har ett problem med vår kod i ett
mycket tidigare skede. Om vi använder skivversionen av `first_word` kommer vi
att få ett fel vid kompileringstid.

<span class="filename">Filnamn: src/main.rs</span>

```rust,ignore,does_not_compile
fn main() {
    let mut s = String::from("hello world");

    let word = first_word(&s);

    s.clear(); // error!

    println!("the first word is: {}", word);
}
```

Här är kompileringsfelet:

```text
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable
  --> src/main.rs:18:5
   |
16 |     let word = first_word(&s);
   |                           -- immutable borrow occurs here
17 |
18 |     s.clear(); // error!
   |     ^^^^^^^^^ mutable borrow occurs here
19 |
20 |     println!("the first word is: {}", word);
   |                                       ---- immutable borrow later used here
```

Kom ihåg från lånereglerna att om vi har en oföränderlig referens till något
kan vi inte samtidigt ha en föränderlig referens. Eftersom `clear` måste kunna
trunkera `String`, måste den få en föränderlig referens. Rust tillåter inte
detta vilket leder till att kompileringen misslyckas. Rust har inte bara gjort
vårt API enklare att använda, utan har också eliminerat en hel typ av fel redan
i kompileringstid!

#### Strängliteraler är skivor

Kom ihåg att vi talade om att strängliteraler lagras inuti den körbara filen.
Nu när vi känner till skivor kan vi korrekt förstå strängliteraler:

```rust
let s = "Hello, world!";
```

Typen av `s` här är `&str`: det är en skriva som pekar på den specifika punkten
av den körbara filen. Detta är också varför strängliteraler är oföränderliga:
`&str` är en oföränderlig referens.

#### Strängskivor som parametrar

Vetskapen om att man kan ta skivor av literaler och `String`-värden leder oss
till ytterligare en förbättring av `first_word` och det är dess signatur:

```rust,ignore
fn first_word(s: &String) -> &str {
```

En mer avancerad Rust-användare skulle skriva signaturen som visas i listning
4-9 istället, då den låter oss använda samma funktion för både `&String`- och
`&str`-värden.

```rust,ignore
fn first_word(s: &str) -> &str {
```

<span class="caption">Listning 4-9: Förbättring av funktionen `first_word`
genom att använda en strängskiva som typ för parametern `s`</span>

Om vi har en strängskiva kan vi skicka den direkt. Om vi har en `String` kan vi
skicka en skiva av hela `String`. Att definiera en funktion som tar en
strängskiva istället för en referens till en `String` gör vårt API mer
generellt och användbart utan att förlora någon funktionalitet:

<span class="filename">Filnamn: src/main.rs</span>

```rust
# fn first_word(s: &str) -> &str {
#     let bytes = s.as_bytes();
#
#     for (i, &item) in bytes.iter().enumerate() {
#         if item == b' ' {
#             return &s[0..i];
#         }
#     }
#
#     &s[..]
# }
fn main() {
    let my_string = String::from("hello world");

    // first_word funerar för skivor av `String`-värden
    let word = first_word(&my_string[..]);

    let my_string_literal = "hello world";

    // first_word fungerar för skivor av strängliteraler
    let word = first_word(&my_string_literal[..]);

    // Då strängliteraler redan *är* skivor fungerar
    // det för dessa också utan skivsyntaxen!
    let word = first_word(my_string_literal);
}
```

### Andra skivor

Strängskivor är, som du förmodligen kan tänka dig, specifika för strängar. Men
det finns även en mer generell skivtyp. Betänk denna array:

```rust
let a = [1, 2, 3, 4, 5];
```

Precis som vi kan vilja referera till en delmängd av en sträng kan vi vilja
referera till en delmängd av en array. Det hade vi gjort på detta sätt:

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];
```

Denna skiva har typen `&[i32]`. Den fungerar på samma sätt som strängskivor,
genom att lagra en referens till det första elementet samt en längd. Du kommer
att använda denna typ av skiva för alla typer av samlingar. Vi kommer att
diskutera dessa samlingar i detalj när vi talar om vektorer i kapitel 8.

## Sammanfattning

Koncepten ägandeskap, lång och skivor säkerställer minnessäkerhet i
Rust-program vid kompileringstid. Programmeringsspråket Rust ger dig kontroll
över din minnesanvändning på samma sätt som andra systemprogrammeringsspråk,
men att låta ägaren av data automatiskt städa upp datan när ägaren faller utom
räckvidd innebär att du inte måste skriva och felsöka extra kod för att få
detta under kontroll.

Ägandeskap påverkar hur många andra delar av Rust fungerar så vi kommer att
tala vidare om dessa koncept genom resten av boken. Låt oss gå vidare till
kapitel 5 och titta på hur man grupperar data tillsammans i en `struct`.

[strängar]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
