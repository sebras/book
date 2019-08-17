## Vad är ägarskap?

En central funktionalitet hos Rust är *ägandeskap*. Även om funktionaliteten är
lätt att förklara får den djupgående konsekvenser för resten av språket.

Alla program måste hantera sättet på vilket de använder en dators minne medan
de kör. Vissa språk har skräpsamling som konstant letar efter oanvänt minne så
länge programmet kört; i andra språk måste programmeraren uttryckligen allokera
och frigöra minne. Rust använder ett tredje tillvägagångssätt: minne hanteras
via ett system av ägandeskap med en uppsättning reglar som kompilatorn
kontrollerar vid kompileringstid. Ingen del av ägandeskapsfunktionaliteten gör
ditt program långsammare medan det kör.

Eftersom ägarskap är ett nytt koncept för många programmerare tar det lite tid
att vänja sig vid. De goda nyheterna är att ju mer erfaren du blir av Rust och
reglerna för ägandeskapssystemet, desto mer kommer du att naturligt kunna
utveckla kod som är säker och effektiv. Ge inte upp!

När du förstår ägandeskap kommer du att ha en bra grund för att förstå
funktionalitet som gör Rust unikt. I detta kapitel kommer du att lära dig om
ägandeskap via några exempel som fokuserar på en väldigt vanlig datastruktur:
strängar.

> ### Stacken och heapen
>
> I många programmeringsspråk behöver du inte tänka på stacken och heapen
> särskilt ofta. Men i ett systemprogrammeringsspråk så som Rust, spelar det
> större roll för hur språket beter sig om ett värde ligger på stacken eller på
> heapen och varför du måste göra vissa beslut. Delar ägandeskap kommer att
> beskrivas i relation till stacken och heapen senare i detta kapitel, så här
> kommer en kort förberedande förklaring.
> 
> Både stacken och heapen är delar of minnet som är tillgänglig för din kod
> att använda i körtid, men de är strukturerade på olika sätt. Stacken lagrar
> värden i ordningen den får dem och tar bort värdena i den omvända ordningen.
> Detta kallas för *sist in, först ut*. Tänk på en trave med tallrikar: när du
> läger till fler tallrikar så staplar du dem på toppen av traven, och när du
> behöver en tallrik så tar du en från toppen. Att lägga till eller ta bort
> tallrikar från mitten eller botten av traven skulle inte gå så bra! Att lägga
> till data kallas för att *lägga på data på stacken*, och att ta bort data
> kalls för *att lyfta av data från stacken*.
>
> All data som lagras på stacken måste han en känd, fix storlek. Data med en
> okänd storlek vid kompileringstid eller en storlek som kan ändras måste
> istället lagras på heapen. Heapen är mindre organiserad: när du lägger data
> på heapen begär du en specifik mängd utrymme. Operativsystemet hittar en
> lämplig plats i heapen som som är stor nog, markerar den som använd och
> returnerar en *pekare*, vilket är adressen till platsen. Denna process kallas
> för att *allokera på heapen* och förkortas ofta enbart som *allokera*. Att
> lägga värden på stacken anses inte att vara allokering. Då pekaren är en
> känd, fix storlek kan du lagra pekaren på stacken, men när du vill komma åt
> den faktiska datan måste du följa pekaren.
>
> Tänk på när du väntar på att få bord på en restaurang. När du kommer in
> uppger du antalet människor i ert sällskap varpå någon ur personalen letar
> upp ett tomt bord med plats för alla och leder er dit. Om någon i din grupp
> kommer sent kan de fråga var ni sitter för att hitta er.
>
> Att lägga data på stacken går snabbare än att allokera på heapen eftersom
> operativsystemet aldrig behöver söka efter en plats att lagra den nya datan
> på; den platsen är alltid på toppen av stacken. Att allokera utrymme på
> heapen kräver jämförelsevis mer arbete eftersom operativsystemet först måste
> hitta tillräckligt med utrymme för att hålla datan och sedan utföra lite
> bokföring för att förbereda för nästa allokering.
>
> Att komma åt data på heapen är långsammare än att komma åt data på stacken
> eftersom du måste följa en pekare för att komma dit. Nutida processorer kör
> snabbare om de inte måste hoppa runt så mycket i minnet. För att fortsätta
> jämförelsen, tänk på en servitris på en restaurang som måste ta beställningar
> från många bord. Det är mest effektivt att inhämta alla beställningarna vid
> ett bord innan hon fortsätter till nästa bord. Att först ta en beställning
> från bord A, sedan en beställning från bord B, och sedan en från A igen och
> sedan en från B igen skulle vara en mycket långsammare process. På samma sätt
> kan en processor gör sitt jobb bättre om den arbetar på data som ligger nära
> annan data (så länge den ligger på stacken) snarare än långt bort (eftersom
> den då kan ligga på heapen). Att allokera ett stort utrymme på heapen kan
> också ta tid.
>
> När din kod anropar en funktion läggs värdena som skickas till funktionen
> (inklusive eventuella pekare till data på heapen) samt funktionens lokala
> variabler på stacken. När funktionen är färdig körd kommer de värdena att
> lyftas av från stacken.
>
> Att hålla reda på vilka delar av koden som använder vilken data på heapen,
> minimera mängden duplicerad data på heapen samt att städa upp oanvänd data
> på heapen så att du inte får slut på utrymme är alla problem som ägandeskap
> tar hand om. När du väl förstår ägandeskap kommer du inte att behöva tänka på
> stacken och heapen särskilt ofta, men att känna till att hantering av
> heapdata är orsaken till att ägandeskap existerar kan hjälpa till med att
> förklara varför det fungerar på det sätt det gör.

### Ägarskapsregler

För det första, låt oss titta på ägarskapsreglerna. Håll dessa regler i minnet
medan vi arbetar oss igenom exemplen som illustrerar dem:

* Varje värde i Rust har en variable som kallas dess *ägare*.
* Det får endast finnas en ägare åt gången.
* När ägaren faller utanför räckvidd, kommer värdet att släppas.

### Variabel räckvidd

Vi har redan gått genom ett exempel på ett Rust-program i kapitel 2. Nu när vi
kommit förbi den grundläggande syntaxen, kommer vi inte att inkludera hela `fn
main() {`-koden i exemplen, så om du följer med så kommer du att behöva att
lägga följande exempel inuti `main`-funktioner manuellt. Som resultat av det
kommer våra exempel att vara något mer koncisa, vilket låter oss fokusera på de
faktiska detaljerna snarare än standardkoden.

Som ett första exempel på ägandeskap kommer vi att titta på *räckvidden* för
vissa variabler. Räckvidd är intervallet inom ett program där ett objekt är
giltigt. Låt oss säga att vi har en variabel som ser ut så här:

```rust
let s = "hello";
```

Variabeln `s` refererar till en strängliteral där strängens värde hårdkodats i
text i vårt program. Variabeln är giltigt från den punkt den deklareras till
slutet på den aktuella *räckvidden*. Listning 4-1 har kommentarer som noterar
var variabeln `s` är giltig.

```rust
{                      // s är inte giltig här, den är inte deklarerad än
    let s = "hello";   // s är giltigt från och med denna punkt

    // gör saker med s
}                      // räckvidden är nu över, och s är inte längre giltig
```

<span class="caption">Listning 4-1: En variabel och räckvidden inom vilken den
är giltig</span>

Med andra ord finns det två viktiga tidpunkter här:

* När `s` introduceras *inom räckvidd*, är den giltig.
* Den fortsätter att vara giltig tills den *faller utom räckvidd*.

Vid denna punkt liknar sambanden mellan räckvidder och när variabler är giltiga
de som finns i andra programmeringsspråk. Nu kommer vi att bygga vidare på
denna förståelse genom att introducera typen `String`.

### `String`-typen

För att illustrera reglerna för ägandeskap kommer vi att behöva en datatyp som
är mer komplex än de vi gått genom i avsnittet [”Datatyper”][datatyper]<!--
ignore -->i kapitel 3. Typerna som diskuterats tidigare lagras alla på stacken
och lyftas av från stacken när deras räckvidd är över, men vi vill titta på
data som lagras på heapen och utforska hur Rust vet när det kan städa upp den
data där.

Vi kommer att använda `String` som exempel här och koncentrera oss på de delar
av `String` som relaterar till ägandeskap. Dessa aspekter gäller också för
andra komplexa datatyper tillhandahållna av standardbiblioteket eller de som du
själv skapar. Vi kommer att diskutera `String` mer detalj i kapitel 8.

Vi har redan sett strängliteraler då ett strängvärde hårdkodas i vårt program.
Strängliteraler är bekväma, men de är ofta inte lämpliga för varje situation
där vi vill använda text. En anledning är att de är oföränderliga. En annan är
att alla strängvärden inte är kända när vi skriver vår kod: till exempel hur
gör vi gör vi om vi vill hämta användarinmatning och lagra den? För dessa
situationer har Rust en sekundär strängtyp, `String`. Denna typ allokeras på
heapen och kan därför lagra en vid kompileringstid för oss okänd mängd text. Du
kan skapa en `String` från en strängliteral genom att använda funktionen `from`
så här:

```rust
let s = String::from("hello");
```

Dubbelkolonet (`::`) är en operator som låter oss referera till att denna
specifika `from`-funktion finns i typen `String` snarare än att använda någon
form av namngivningskonvention så som `string_from`. Vi kommer att diskutera
denna syntax i mer detalj i avsnittet [”Metodsyntax”][metodsyntax]<!-- ignore
--> i kapitel 5 och när vi talar om namnrymder i samband med moduler i
[”Sökvägar för att referera till ett objekt i
modulträdet”][sökväg-modulträd]<!-- ignore --> i kapitel 7.

Denna typ av sträng *kan* förändras:

```rust
let mut s = String::from("hello");

s.push_str(", world!"); // push_str() lägger till en literal till en String

println!("{}", s); // Detta kommer att skriva ut `hello, world!`
```

Så vad är skillnaden? Varför kan `String` förändras medan literaler inte kan
det? Skillnaden är hur dessa två typer hanterar minne.

### Minne och allokering

I fallet med en strängliteral känner vi till innehållet vid kompileringstid så
texten hårdkodas direkt i den slutgiltiga körbara filen. Detta är anledningen
till att strängliteraler är snabba och effektiva. Men dessa egenskaper kommer
enbart från strängliteralens oföränderlighet. Tyvärr kan vi inte stoppa in en
klump minne i den körbara filen för varje bit text vars storlek är okänd vid
kompileringstid och vars storlek kan ändras medan programmet kör.

För typen `String`, för att kunna ge stöd för en föränderlig, utvidgningsbar bit
text måste vi allokera en mängd minne på heapen, där mängden är okänd i
kompileringstid, för att lagra innehållet. Detta innebär:

* Minne måste begäras från operativsystemet i körtid.
* Vi måste ha ett sätt att returnera minnet till operativsystemet när vi är
  klara med vår `String`.

Den första delen görs av oss: när vi anropar `String::from`` begär dess
implementation det minne som den behöver. Detta är ganska allmängiltigt i
programmeringsspråk.

Den andra delen är dock annorlunda. I språk med en *skräpsamlare* (Garbage
Collector, GC), håller GC:n reda på och städar upp minne som inte längre
används, och vi behöver inte bry oss om det. Utan en GC är det vårt ansvar att
identifiera när minne inte längre används och anropa kod för att uttryckligen
returnera det, precis som vi gjorde när vi begärde det. Att göra detta korrekt
har historiskt varit ett svårt programmeringsproblem. Om vi glömmer det, kommer
vi att slösa med minne. Om vi gör det för tidigt kommer vi att ha en ogiltig
variabel. Om vi gör det två gånger är det också ett programmeringsfel. Vi måste
para exakt en `allokering` med exakt en `frigörning`.

Rust går tillväga på ett annat sätt: minne returneras automatiskt när variabeln
som äger det faller utom räckvidd. Här är en version av vårt räckviddsexempel
från listning 4-1 som använder `String` istället för en strängliteral:

```rust
{
    let s = String::from("hello"); // s är giltig från och med denna punkt

    // gör saker med s
}                                  // denna räckvidden är nu slut, och s är
                                   // inte längre giltig
```

Det finns en naturlig punkt vid vilken vi kan returnera minnet som vår `String`
behöver tillbaka till operativsystemet: när `s` faller utom räckvidd. När en
variable faller utom räckvidd anropar Rust en speciell funktion åt oss. Denna
funktion kallas `drop`, och detta är platsen där upphovsmannen till `String`
kan placera kod för att returnera minnet. Rust anropar `drop` automatiskt vid
den avslutande klammerparentesen.

> Notera: I C++ kallas detta mönster för att avallokera resurser vid slutet av
> ett objekts livstid för *resursförvärv är initialisering* (Resource Acquision
> Is Initialization, RAII). Du kommer att känna igen `drop`-funktionen i Rust
> om du använt RAII-mönster.

Detta mönster har en djup inverkar på sättet som Rust-kod skrivs. Det kan
förefalla enkelt just nu, men beteende för kod kan vara oväntat i mer
komplicerade situationer när vi vill ha multipla variabler som använder data
som vi allokerat på heapen. Låt oss nu utforska några av dessa situationer.

#### Sätt på vilka variabler och data interagerar: förflyttning

Flera variabler kan interagera med samma data på olika sätt i Rust. Låt oss
titta på ett exempel som använder ett heltal i listning 4-2.


```rust
let x = 5;
let y = x;
```

<span class="caption">Listning 4-2: Tilldelning av heltalsvärdet för variabel
`x` till `y`</span>

Vi kan antagligen gissa vad detta gör: ”bind värdet `5` till `x`; skapa sedan en
kopia av värdet i `x` och bind det till `y`.” Vi har nu två variabler, `x` och
`y`, och båda är lika med `5`. Detta är faktiskt det som händer, eftersom
heltal är enkla värden med en känd, fix storlek, och dessa två `5`-värden läggs
på stacken.

Låt oss nu titta på `String`-versionen:

```rust
let s1 = String::from("hello");
let s2 = s1;
```

Detta liknar den föregående koden ganska mycket, så vi skulle kunna anta att
sättet på vilket den fungerar är det samma: det vill säga, den andra raden
skapar en kopia av värdet i `s1` och binder det till `s2`. Men det är inte
riktigt vad som händer.

Titta på Figur 4-1 för att se vad som faktiskt händer med `String`. En `String`
har av tre delar vilka visas till vänster: en pekare till minne som lagrar
strängens innehål, en längd och en kapacitet. Denna grupp data lagras på
stacken. Till höger är minnet i heapen som lagrar innehållet.

<img alt="Sträng i minnet" src="img/trpl04-01.svg" class="center" style="width: 50%;" />

<span class="caption">Figur 4-1: Representation i minnet av en `String` som
innehåller värdet `"hello"` bundet till `s1`</span>

Längden är hur mycket minne i bytes som innehåller i `String` använder för
närvarande. Kapaciteten är den totala mängden minne i byte som `String` har
fått från operativsystemet. Skillnaden mellan längden och kapaciteten spelar
roll, men inte i detta sammanhanget, så det går bra att ignorera kapaciteten
för närvarande.

När vi tilldelar `s1` till `s2` kommer data som tillhör `String` att kopieras,
vilket innebär att vi kopierar pekaren, längden och kapaciteten som finns på
stacken. Vi kopierar inte datan på heapen som pekaren refererar till. Med andra
ord, data representationen i minne ser ut som i Figur 4-2.

<img alt="s1 och s2 pekar på samma värde" src="img/trpl04-02.svg" class="center" style="width: 50%;" />

<span class="caption">Figur 4-2: Representation i minne av variabeln `s2` som
har en kopia av pekaren, längden och kapaciteten från `s1`</span>

Representationen ser *inte* ut som i Figur 4-3, vilket hur minne hade sett ut
om Rust istället även hade kopierat heapdatan. Om Rust hade gjort detta så hade
operationen `s2 = s1` kunnat vara mycket dyrt i termer av körtidsprestanda om
data på heapen hade varit stor.

<img alt="s1 och s2 pekar på två platser" src="img/trpl04-03.svg" class="center" style="width: 50%;" />

<span class="caption">Figur 4-3: En annan möjlighet för vad `s2 = s1` skulle
kunna göra om Rust också hade kopierat heapdata</span>

Tidigare sa vi att när en variabel faller utom räckvidd kör Rust automatiskt
`drop`-funktionen och städar upp heapminnet för den variabeln. Men Figur 4-2
visar att båda datapekarna pekar på samma plats. Detta är ett problem: när `s2`
och `s1` faller utom räckvidd kommer de båda att försöka frigöra samma minne.
Detta kallas för ett *dubbelfri*-fel och är en av de minnessäkerhetsfel som vi
nämnt tidigare. Att frigöra minne två gånger kan leda till minneskorruption,
vilket eventuellt kan leda till säkerhetssårbarheter.

För att säkerställa minnessäkerhet finns det ytterligare en detalj kring vad
som händer i Rust under denna situationen. Istället för att försöka att kopiera
det allokerade minne anser Rust att `s1` inte längre är giltigt och därför
behöver Rust inte frigöra någonting när `s1` faller utom räckvidd. Se vad som
händer när du försökta att använda `s1` efter att `s2` skapats; det kommer inte
att fungera:

```rust,ignore,does_not_compile
let s1 = String::from("hello");
let s2 = s1;

println!("{}, world!", s1);
```

Du kommer att få ett fel i stil med detta då Rust hindrar dig från att använda
den upphävda referensen.

```text
error[E0382]: use of moved value: `s1`
 --> src/main.rs:5:28
  |
3 |     let s2 = s1;
  |         -- value moved here
4 |
5 |     println!("{}, world!", s1);
  |                            ^^ value used here after move
  |
  = note: move occurs because `s1` has type `std::string::String`, which does
  not implement the `Copy` trait
```

Om du har hört termerna *grund kopia* och *djup kopia* när du arbetat med andra
språk, så låter förmodligen konceptet att kopiera pekaren, längden och
kapaciteten utan att kopiera datan som en grund kopia. Men eftersom Rust också
upphäver den första variabeln så säger vi istället att `s1` *flyttats* in i
`s2`. Så vad som faktiskt hängde visas i Figur 4-4.

<img alt="s1 flyttad till s2" src="img/trpl04-04.svg" class="center" style="width: 50%;" />

<span class="caption">Figur 4-4: Representation i minnet efter att `s1` har
upphävts</span>

Det löser vårt problem! Med enbart `s2` giltig så kommer den, när den faller utom
räckvidd, att frigöra minnet, och allt är klart.

Dessutom finns det ett designval som impliceras av detta: Rust kommer aldrig
automatiskt att skapa ”djupa” kopior av din data. Därför kan *automatisk*
kopiera antas vara billig i termer av körtidsprestanda.

#### Sätt på vilka variabler och data interagerar: Clone

Om vi *vill* göra en djup kopia av heapdatan för `String` och inte bara
stackdatan, kan vi använda en vanlig metod som kallas `clone`. Vi kommer att
diskutera denna metods syntax i Kapitel 5, men eftersom metoder utgör en vanlig
del i många programmeringsspråk har du troligtvis sett den förut.

Här är ett exempel på `clone`-metoden i arbete:

```rust
let s1 = String::from("hello");
let s2 = s1.clone();

println!("s1 = {}, s2 = {}", s1, s2);
```

Detta fungerar utmärkt och uttryckligen har det beteende som visas i Figur 4-3,
där heapdatan *blir* kopierad.

När du ser ett anrop till `clone` vet du att någon form av godtycklig kod körs
och att den koden kan vara kostsam. Det är en visuell indikator på att någon
speciellt pågår.

#### Endast stackdata: Copy

Det finns ytterligare ett problem som vi inte pratar om än. Denna kod som
använder heltal är en del av vad som visades i listning 4-2. Den fungerar och
är giltig:

```rust
let x = 5;
let y = x;

println!("x = {}, y = {}", x, y);
```

Men denna kod ser ut att motsäga vad vi just lärt oss: det finns inget anrop
till `clone`, men `x` är fortfarande giltig och flyttades inte in i `y`.

Anledningen till detta är att typer så som heltal som har en känd storlek i
kompileringstid helt och hållet lagras på stacken, så kopior av de faktiska
värdena går snabbt att göra. Detta innebär att det inte finns någon anledning
till att vi skulle vilja förhindra `x` från att vara giltig efter att vi skapat
variabeln `y`. Med andra ord det finns ingen skillnad mellan djup och grund
kopiering i detta fallet, så att anropa `clone` hade inte gjort något
annorlunda jämfört med en grund kopiering, så vi kan utelämna det anropet.

Rust har en speciell notering som kallas `Copy`-egenskapen som vi kan placera
på typer så som heltal som lagras på stacken (vi kommer att tala mer om
egenskaper i kapitel 10). Om en typ har `Copy`-egenskapen kommer en äldre
variabel fortfarande att vara användbar efter tilldelning. Rust kommer inte låta
oss notera en typ med `Copy`-egenskapen om typen, eller någon av dess delar,
implementerat `Drop`-egenskapen. Om typen kräver något speciellt händer när
värdet fallet utom räckvidd och vi försöker lägga till `Copy`-noteringen till
den typen kommer vi att få ett kompileringstidsfel. För att lära dig om hur du
lägger till `Copy`-noteringen till din typ, se [”Härledda
egenskaper”][härledda-egenskaper]<!-- ignore --> i bilaga C.

Så vilka typer är `Copy`? Du kan kolla i dokumentationen för en given typ för
att vara säker, men den generella regeln är att en grupp av enkla skalära
värden kan vara `Copy`, och ingenting som kräver allokering eller är någon form
av resurs är `Copy`. Här är några av typerna som är `Copy`:

* Alla heltalstyper, så som `u32`.
* Den booleska datatypen, `bool` med värdena `true` och `false`.
* Alla flyttalstyper, så som `f64`.
* Teckentypen `char`.
* Tupler om de enbart innehåller typer som i sin tur är `Copy`. Till exempel
  är `(i32, i32)` `Copy`, men `(i32, String)` är inte det.

### Ägandeskap och funktioner

Semantiken för att skicka ett värde till en funktion liknar de för att tilldela
ett värde till en variabel. Att skicka en variabel till en funktion kommer att
flytta eller kopiera, precis som en tilldelning gör. Listning 4-3 har ett
exempel med noteringar som visar var variabler kommer in inom och faller utom
räckvidd.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let s = String::from("hello");  // s kommer in inom räckvidd

    takes_ownership(s);             // s värde flyttar in i funktionen...
                                    // ...så det är inte längre giltigt här

    let x = 5;                      // x kommer in inom räckvidd

    makes_copy(x);                  // x skulle ha flyttat in i funktionen,
                                    // men i32 är Copy, så det är fortfarande
                                    // OK att använda x efteråt

} // Här faller x utom räckvidd, och sedan s. Men eftersom s värde flyttats
  // kommer inget speciellt att hända.

fn takes_ownership(some_string: String) { // some_string tas in inom räckvidd
    println!("{}", some_string);
} // Här faller some_string utom räckvidd och `drop` anropas. Minnet som
  // används för lagring frigörs.

fn makes_copy(some_integer: i32) { // some_integer tas in inom räckvidd
    println!("{}", some_integer);
} // Här faller some_integer utom räckvidd. Inget speciellt händer.
```

<span class="caption">Listning 4-3: Funktioner med noteringar kring ägandeskap
och räckvidd</span>

Om vi hade försökt att använda `s` efter anropet till `takes_ownership` hade
Rust kastat ett fel vid kompileringstid. Dessa statiska kontroller skyddar oss
från misstag. Prova att lägga till kod i `main` som använder `s` och `x` för
att se var du kan använda dem och var ägandeskapsreglerna hindrar dig från att
göra det.

### Returvärden och räckvidd

Returvärden kan också överföra ägandeskap. Listning 4-4 är ett exempel med
noteringar liknande de i listning 4-3.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let s1 = gives_ownership();         // gives_ownership flyttar sitt
                                        // returvärde in i s1

    let s2 = String::from("hello");     // s2 kommer inom räckvidd

    let s3 = takes_and_gives_back(s2);  // s3 flyttas in i
                                        // takes_and_gives_back, vilket också
                                        // flyttar dess returvärde in i s3
} // Här faller s3 utom räckvidd och frigörs, s2 faller utom räckvidd men
  // flyttades så ingenting händer. s1 faller utom räckvidd och frigörs.

fn gives_ownership() -> String {             // gives_ownership kommer att
                                             // flytta sitt returvärde in i
                                             // funktionen som anropar den

    let some_string = String::from("hello"); // some_string kommer inom
                                             // räckvidd

    some_string                              // some_string returneras och
                                             // flyttas ut till den anropande
                                             // funktionen
}

// takes_and_gives_back kommer att ta en String och returnera en annan
fn takes_and_gives_back(a_string: String) -> String { // a_string kommer inom
                                                      // räckvidd

    a_string  // a_string returneras och flyttas ut till den anropande
              // funktionen
}
```

<span class="caption">Listning 4-4: Överförande av ägandeskap av
returvärden</span>

Ägandeskapet av en variabel följer samma mönster varje gång: tilldelning av ett
värde till en annan variabel flyttar det. När en variabel som inkluderar data
på heapen faller utom räckvidd kommer värdet att städas bort av `drop` om inte
data har flyttats till att ägas av en annan variabel.

Att ta ägandeskap och sedan returnera ägandeskap för varje funktion är lite
tråkigt. Vad händer om vi vill låta en funktion använda ett värde men inte ta
ägandeskap? Det är ganska irriterande att om vi skickar in något måste det också
skickas tillbaka om vi vill använda det igen, förutom data som resulterar från
funktionskroppen som vi eventuellt också vill returnera.

Det är möjligt att returnera flera värde via en tupel, så som visas i listning
4-5.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let s1 = String::from("hello");

    let (s2, len) = calculate_length(s1);

    println!("The length of '{}' is {}.", s2, len);
}

fn calculate_length(s: String) -> (String, usize) {
    let length = s.len(); // len() returnerar längden för en Sträng

    (s, length)
}
```

<span class="caption">Listning 4-5: Returnerar ägandeskap för parametrar</span>

Men detta är allt för mycket jobb för ett koncept som borde vara vanligt. Som
tur är för oss har Rust en funktion för detta koncept som kallas *referenser*.

[datatyper]: ch03-02-data-types.html#data-types
[härledda-egenskaper]: appendix-03-derivable-traits.html
[metodsyntax]: ch05-03-method-syntax.html#method-syntax
[sökväg-modulträd]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
