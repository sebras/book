## Definiera och instantiera structar

Structar liknar tupler, vilka diskuterades i kapitel 3. Likt tupler kan delarna
i en struct vara av olika typer. Till skillnad från tupler måste du namnge
varje datadel för att det är tydligt vad värdet innebär. Som resultat av dessa
namn, är structar mer flexibla än tupler: du behöver inte förlita dig på
ordningen av datan för att ange eller komma åt värdena i en instans.

För att definiera en struct kommer vi att ange nyckelordet `struct` och namnet
på hela structen. En structs namn bör beskriva betydelsen av den data som
grupperas ihop. Därefter definierar vi, inom klammerparenteser, namnen och
typer på varje datadel, vilka vi kallar *fält*. Listning 5-1 visar till exempel
en struct som lagrar information om ett användarkonto.

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}
```

<span class="caption">Listning 5-1: En definition av en `User`-struct</span>

För att använda en struct efter att vi definierat den skapar vi en *instans* av
den structen genom att ange konkreta värden för vart och ett av fälten. Vi
skapar en instans genom att ange namnet på structen och sedan lägger till
klammerparenteser innehållandes `nyckel: värde`-par, där nycklarna är namnen på
fälten och värdena är den data vi vill lagra i fälten. Vi måste inte ange
fälten i samma ordning som vi deklarerade dem i structen. Med andra ord
structdefinitionen är som en allmän mall för typen och instanserna fyller i den
mallen med specifik data för att skapa värden av typen. Vi kan till exempel
deklarera en specifik användare så som visas i listning 5-2.

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
let user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};
```

<span class="caption">Listning 5-2: Att skapa en instans av
`User`-structen</span>

För att få tag i ett specifikt värde från en struct kan vi använda
punktnotation. Om vi bara vill ha denna användarens epostadress skulle vi kunna
använda `user1.email` på de platser vi vill använda detta värde. Om instansen
är föränderlig kan vi ändra ett värde genom att använda punktnotation och
tilldela ett specifikt fält. Listning 5-3 visar hur man ändrar värdet i
`email`-fältet för en föränderlig `User`-instans.

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
let mut user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};

user1.email = String::from("anotheremail@example.com");
```

<span class="caption">Listning 5-3: Hur man ändrar värdet för `email`-fältet av
en `User`-instans</span>

Notera att hela instansen måste vara föränderlig: Rust tillåter inte oss att
endast markera vissa fält som föränderliga. Som med vilket uttryck som helst
kan vi konstruera en ny instans av structen som sista uttryck i en
funktionskropp för att implicit returnera denna nya instans.

Listning 5-4 visar en `build_user`-funktion som returnerar en `User`-instans
med angiven epostadress och användarnamn. Fältet `active` får värdet `true` och
`sign_in_count` får värdet `1`.

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
fn build_user(email: String, username: String) -> User {
    User {
        email: email,
        username: username,
        active: true,
        sign_in_count: 1,
    }
}
```

<span class="caption">Listning 5-4: En funktion `build_user` som tar en
epostadress och ett användarnamn och returnerar en `User`-instans</span>

Det är vettigt att namnge funktionsparametrarna med samma namn som
structfälten, men att behöva upprepa fältnamnen `email` och `username` är lite
trist. Om structen hade haft fler fält hade upprepning av varje namn varit än
mer irriterande. Lyckligtvis finns det en bekväm kortform!

### Användning av kortformen för fältinitiering när variabler och fler har samma namn

Eftersom parameternamn och structfältsnamn är exakt de samma i listning 5-4 kan
vi använda *kortformen för fältinitiering* för att skriva om `build_user` så
att den beter sig på exakt samma sätt men inte repeterar `email` och
`username`, så som visas i listning 5-5.

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
fn build_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

<span class="caption">Listning 5-5: En `build_user`-funktion som använder
kortformen för fältinitiering då parametrarna `email` och `username` har samma
namn som structfälten</span>

Här skapar vi en ny instans av `User`-structen vilken har ett fält vid namn
`email`. Vi vill sätta `email` fältets värde till samma värde som
`build_user`-funktionens `email`-parameter har. Eftersom `email`-fältet och
`email`-parametern har samma namn behöver vi bara skriva `email` snarare än
`email: email`.

### Skapa instanser från andra instanser med structuppdateringssyntax

Det är ofta användbart att skapa en ny instans av en struct som använder
merparten av en gammal instans värden men ändra några stycken. Du kan göra
detta genom att använda structuppdateringssyntaxen.

Listning 5-6 visar först hur vi skapar en ny `User`-instans i `user2` utan att
använda uppdateringsyntaxen. Vi sätter nya värden för `email` och `username`,
men använder för övrigt samma värden från `user1` som vi skapade i listning
5-2.

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
# let user1 = User {
#     email: String::from("someone@example.com"),
#     username: String::from("someusername123"),
#     active: true,
#     sign_in_count: 1,
# };
#
let user2 = User {
    email: String::from("another@example.com"),
    username: String::from("anotherusername567"),
    active: user1.active,
    sign_in_count: user1.sign_in_count,
};
```

<span class="caption">Listning 5-6: Skapa en ny `User`-instans som använder
några av värdena från `user1`</span>

Med hjälp av structuppdateringsyntaxen kan vi åstadkomma samma effekt med
mindre kod, som visas i listning 5-7. Syntaxen `..` anger att återstående
värden som inte sätts uttryckligen ska ha samma värde som fälten i den angivna
instansen.

```rust
# struct User {
#     username: String,
#     email: String,
#     sign_in_count: u64,
#     active: bool,
# }
#
# let user1 = User {
#     email: String::from("someone@example.com"),
#     username: String::from("someusername123"),
#     active: true,
#     sign_in_count: 1,
# };
#
let user2 = User {
    email: String::from("another@example.com"),
    username: String::from("anotherusername567"),
    ..user1
};
```

<span class="caption">Listning 5-7: Användning av structuppdateringsyntaxen för
att sätta nya `email`- och `username`-värden i en `User`-instans, men använder
resten av värden från fälten från `user1`-variabeln</span>

Koden i listning 5-7 skapar också en instans i `user2` som har andra värden för
`email` och `username`, men som har samma värden för `active`- och
`sign_in_count`-fälten som `user1`.

### Användning av tupelstructar utan namngivna fält för att skapa olika typer

Du kan också definiera structar som ser ut som tupler, kallade *tupelstructar*.
Tupelstructar har den ytterligare innebörden som structnamn tillhandahåller men
har inte namn associerade med sina fält; de har bara typerna för respektive
fält. Tupelstructar är användbara när du vill ge hela tupeln ett namn och göra
tupeln till en annan typ än andra tupler, men att namnge varje fält som för en
vanlig struct hade varit pratigt eller redundant.

För att definiera en tupelstruct, börja med nyckelordet `struct` och
structnamnet åtföljt av typerna i tupel. Här är till exempel definition och
användning av två tupelstructar vid namn `Color` och `Point`:

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

Notera att värdena `black` och `origin` är olika typer eftersom de är instanser
av olika tupelstructar. Varje struct du definierar är sin egen type, även om
fälten inom structen har samma typer. En funktion som till exempel tar en para
meter av typen `Color` kan ta ta en `Point` som argument, även om båda typerna
består av tre `i32`-värden. I övrigt beter sig tupelstructar som tupler: du kan
destrukturera dem till delar, du kan använda `.` följt av ett index för att
komma åt ett individuellt värde, och så vidare.

### Enhetsliknande structar utan några fält

Du kan också definiera structar som inte har några fält! Dessa kallas för
*enhetsliknande structar* då de beter sig liknande enhetstypen `()`.
Enhetsliknande structar kan vara användbara i situationer där du måste
implementera en egenskap för en type men inte har någon data som du vill lagra
i typen i sig. Vi kommer att diskutera egenskaper i kapitel 10.

> ### Ägandeskap av structdata
>
> I structdefinitionen av `User` i listning 5-1 använde vi den ägda
> `String`-typen snarare än strängskivetypen `&str`. Detta är ett avsiktligt
> val då vi vill att instanser av denna struct äger all sin data och att datan
> är giltig så länge som hela structen är giltig.
>
> Det är möjligt för structar att lagra referenser till data som ägs av
> någonting annat, men när man gör det så kräver det användning av *livstider*,
> en Rust-funktion som vi kommer att diskutera i kapitel 10. Livstider
> försäkraratt datan som refereras till av en struct är giltigt lika länge som
> structen är giltig. Låt oss säga att du på detta sätt försöker att lagra en
> referens i en struct utan att ange livstider, då kommer det inte att fungera:
>
> <span class="filename">Filnamn: src/main.rs</span>
>
> ```rust,ignore,does_not_compile
> struct User {
>     username: &str,
>     email: &str,
>     sign_in_count: u64,
>     active: bool,
> }
>
> fn main() {
>     let user1 = User {
>         email: "someone@example.com",
>         username: "someusername123",
>         active: true,
>         sign_in_count: 1,
>     };
> }
> ```
>
> Kompilatorn kommer att klaga på att livstidsangivare behövs:
>
> ```text
> error[E0106]: missing lifetime specifier
>  -->
>   |
> 2 |     username: &str,
>   |               ^ expected lifetime parameter
>
> error[E0106]: missing lifetime specifier
>  -->
>   |
> 3 |     email: &str,
>   |            ^ expected lifetime parameter
> ```
>
> I kapitel 10 kommer vi att diskutera hur man kan fixa dessa fel så att du kan
> lagra referenser i structar, men tills vidare kommer vi att fixa problem som
> detta genom att använda ägda typer som `String` istället för
> `&str`-referenser.
