# Introduktion

> Not: Denna upplaga av boken är densamma som [Programmeringsspråket
> Rust][nsprust] tillgänglig i tryckt format och som e-bok från [No Starch
> Press][nsp].

[nsprust]: https://nostarch.com/rust
[nsp]: https://nostarch.com/

Välkommen till *Programmeringsspråket Rust*, en inledande bok om Rust.
Programmeringsspråket Rust hjälper dig att skriva snabbare, mer pålitlig
programvara. Högnivåergonomi och lågnivåkontroll är ofta i strid med varandra
inom design av programmeringsspråk; Rust utmanar denna konflikten. Genom att
balansera kraftfull tekniskt kapacitet med en fantastisk utvecklarupplevelse
ger Rust dig möjligheten till kontroll över lågnivådetaljer (så som
minnesanvändning) utan allt krångel som traditionellt associeras med sådan
kontroll.

## Vem är Rust till för

Rust är lämpligt för många människor av ett antal anledningar. Låt oss titta på
några av de viktigaste grupperna.

### Grupper av utvecklare

Rust visar sig vara ett produktivt verktyg för samarbete mellan stora grupper
av utvecklare med olika nivåer av kunskap inom systemprogrammering. Lågnivåkod
är benägen att ha en mängd subtila fel, vilket i de flesta andra språk bara kan
fångas upp genom omfattande testning och noggrann kodgranskning av erfarna
utvecklare. I Rust fungerar kompilatorn som portvakt genom att vägra att
kompilera kod med denna typ av svårfångade fel, inklusive samtidighetsfel.
Genom att arbeta tillsammans med kompilatorn kan utvecklargrupper spendera sin
tid på att fokusera på programmets logik snarare än att jaga fel.

Rust tillhandahåller också med samtida utvecklarverktyg till
systemprogrammeringsvärlden:

* Cargo, den medföljande beroendehanteraren och byggverktyget, gör tillägg,
  kompilering och hantering av beroenden smärtfritt och konsekvent genom hela
  Rusts ekosystem.
* Rustfmt säkerställe en konsekvent kodningsstil för alla utvecklare.
* Rusts språkserver understödjer integrerade utvecklingsmiljöer (Integrated
  Development Environment, IDE) vad det gäller kodkomplettering och infogade
  felmeddelanden.

Genom dessa och andra verktyg i Rusts ekosystem kan utvecklare vara produktiva
medan de skriver systemnivåkod.

### Studerande

Rust är till för studerande och de som är intresserad av att lära sig som
systemkoncept. Genom att använda Rust har många människor lärt sig om områden
så som operativsystemsutveckling. Gemenskapen är välkomnande och svarar
gladeligen på frågor från studerande. Genom insatser så som denna bok vill
Rust-grupperna göra systemkoncept mer tillgängliga för fler människor,
speciellt de för vilka programmering är nytt.

### Företag

Hundratals företag, stora och små, använder Rust i produktion för en mängd
olika uppgifter. Dessa uppgifter inkluderar kommandoradsverktyg, webbtjänster,
DevOps-verktyg, inbäddad mjukvara, ljud- och videoanalys och transkodning,
kryptovalutor, bioinformatik, söktjänster, applikationer inom Sakernas
internet, maskinlärning och till och med signifikanta delar av webbläsaren
Firefox.

### Utvecklare inom öppen programvara

Rust är till för de som vill bygga programmeringsspråket Rust, gemenskapen,
utvecklarverktyg och bibliotek. Vi skulle gärna se att du bidrar till Rust.

### Människor som värdesätter hastighet och stabilitet

Rust är till för människor som kräver hastighet och stabilitet i ett språk. Med
hastighet menar vi hastigheten hos de program du kan skapa med Rust samt
hastigheten med vilken Rust låter dig skriva dem. Rust kompilatorns kontroller
säkerställer stabilitet genom funktionstillägg och omfaktorisering. Detta står
i kontrast till gammal, skör kod i språk som saknar dessa kontroller, som
utvecklare ofta är rädda för att ändra. Genom att sträva efter abstraktioner
med noll kostnad, högnivå funktioner som kompileras till lågnivå som är lika
snabb som manuellt skriven kod, försöker Rust att få säker kod att också vara
snabb kod.

Språket Rust hoppas på att även ge stöd till många andra användare; de som
nämns här är endast några av de största intressenterna. Rusts största ambition
är att eliminera de avvägningar som programmerare har accepterat under
årtionden genom att tillhandahålla säkerhet *och* produktivitet, hastighet
*och* ergonomi. Prova Rust och se om dess val fungerar för dig.

## Vem är denna bok till för

Denna bok förutsätter att du har skrivit kod i ett annat programmeringsspråk
men gör inga förutsättningar kring vilket språk. Vi har försökt att göra
materialet allmänt tillgängligt för varierande programmeringsbakgrunder. Vi
spenderar inte en massa tid på att tala om vad programmering *är* eller hur man
ska tänka kring det. Om programmering är helt nytt för dig, är du troligen
bättre betjänt av att läsa en bok som specifikt introducerar programmering.

## Hur du använder denna bok

I allmänhet förutsätter denna bok att du läser den i sekvens från början till
slut. Senare kapitel bygger på koncept från tidigare kapitel och tidigare
kapitel går kanske inte på djupet inom ett område; vi återkommer vanligen till
ett område i ett senare kapitel.

Du hittar två typer av kapitel i denna ok: konceptkapitel och projektkapitel. I
konceptkapitel kommer du att lära dig om en aspekt av Rust. I projektkapitel
kommer vi att bygga små projekt tillsammans, genom att tillämpa vad du lärt dig
så långt. Kapitlen 2, 12 och 20 är projektkapitel; resten är konceptkapitel.

Kapitel 1 förklarar hur du installerar Rust och hur skriver ett "Hello,
world!"-program, och hur man använder Cargo, Rusts pakethanterare och
byggverktyg. Kapitel 2 är en praktisk introduktion till språket Rust. Här
omfattas koncept på en hög nivå, där senare kapitel kommer att ge ytterligare
detaljer. Om du vill börja med en gång är kapitel 2 en lämplig start. Till en
början kanske du till och med vill hoppa över kapitel 3, vilket omfattar Rusts
funktioner som liknar de från andra programmeringsspråk och gå direkt till
kapitel 4 för att lära dig om Rusts ägarsystem. Skulle du vara en särskilt
noggrann elev som föredrar att lära dig varje detalj innan du går vidare till
nästa så kanske du bör hoppa över kapitel 2 och gå direkt till kapitel 3 för
att återgå till kapitel 2 när du vill arbeta på ett projekt som tillämpar de
detaljer du har lärt dig.

Kapitel 5 diskuterar strukturer och metorder och kapitel 6 beskriver
uppräkningar, `match`-uttryck och kontrollflödeskonstruktionen `if let`. Du
kommer att använda strukturer och uppräkningar för att skapa anpassade typer i
Rust.

I kapitel 7 kommer du att lära dig om Rusts modulsystem och om sekretessregler
för att organisera din kod och dess publika
applikationsprogrammeringsgränssnitt (Application Programming Interface, API).
Kapitel 8 diskuterar några vanliga samlingsdatastrukturer som
standardbiblioteket erbjuder, så som vektorer, strängar och hashmappningar.
Kapitel 9 utforskar Rusts felhanteringsfilosofi och tillhörande tekniker.

Kapitel 10 gräver sig in i generisk programmering, drag och livstider, vilket
ger dig möjligheten att definiera kod som fungerar för flera olika typer. Hela
kapitel 11 handlar om testning, vilket trots Rusts alla säkerhetsgarantier är
nödvändigt för att säkerställa att ditt programs logik är korrekt. I kapitel 12
kommer vi att bygga vår egen implementation av en delmängd av funktionen hos
kommandoradsverktyget `grep` som söker efter text inom filer. När vi gör detta
kommer vi att använda många av de koncept som diskuteras i de tidigare
kapitlen.

Kapitel 13 utforskar höljen och iteratorer: funktioner hos Rust som kommer
från funktionella programmeringsspråk. I kapitel 14 kommer vi att i detalj
undersöka Cargo och tala om bästa praxis för att dela dina bibliotek med andra.
Kapitel 15 diskuterar smarta pekare som tillhandahålls av standard biblioteket
och de drag som möjliggör att de fungerar.

I kapitel 16 kommer vi att gå genom olika modeller för samtidig programmering
och tala om hur Rust hjälper dig att orädd utveckla med multipla trådar.
Kapitel 17 tittar på hur Rust-idiom kan jämföras med principer från
objekt-orienterad programmering som du eventuellt är bekant med.

Kapitel 18 är en referens för mönster och mönstermatchning vilket är ett
kraftfullt sätt att uttrycka idéer genom hela Rust-program. Kapitel 19
innehåller ett smörgåsbord av avancerade områden, inklusive osäker Rust, makron
och mer om livstider, drag, typer, funktioner och höljen.

I Kapitel 20 kommer vi att färdigställa ett projekt i vilket vi kommer att
implementera en flertrådad lågnivå webbserver!

Avslutningsvis finns det ett antal bilagor som på ett mer referensliknande sätt
innehåller användbar information om språket. Bilaga A omfattar Rusts nyckelord,
bilaga B beskriver Rusts operatorer och symboler, bilaga C täcker härledda drag
som tillhandahålls av standardbiblioteket, bilaga D omfattar några användbara
utvecklingsverktyg och bilaga E beskriver Rusts versioner.

Det finns inget felaktigt sätt att läsa denna boken på: om du vill hoppa
framåt, gör det! Du kanske måste hoppa tillbaka till tidigare kapitel om du
blir förvirrad, men läs den på det sätt som fungerar för dig.

<span id="ferris"></span>

En viktig del av processen att lära sig Rust är att lära sig att läsa
felmeddelanden som visas av kompilatorn: dessa kommer att vägleda dig till
fungerande kod. Därför kommer vi att ha många exempel som inte kompilerar
tillsammans med felmeddelandet som kompilatorn kommer att visa sig i respektive
situation. Du bör veta att om du matar in och kör ett slumpmässigt exempel, så
kanske det inte kommer att kompilera! Säkerställ att du har läst den
omkringliggande texten för att se huruvida exemplet du försöker köra borde ge
ett fel. Ferris kommer också att hjälpa dig att urskilja kod som inte är menad
att fungera:

| Ferris                                                                 | Innebörd                                         |
|------------------------------------------------------------------------|--------------------------------------------------|
| <img src="img/ferris/does_not_compile.svg" class="ferris-explain"/>    | Denna kod kompilerar inte!                       |
| <img src="img/ferris/panics.svg" class="ferris-explain"/>              | Denna kod slutar med panik!                      |
| <img src="img/ferris/unsafe.svg" class="ferris-explain"/>              | Detta kodblock innehåller osäker kod.            |
| <img src="img/ferris/not_desired_behavior.svg" class="ferris-explain"/>| Denna kod producerar inte det önskade beteendet. |

I de flesta situationer kommer vi att vägleda dig till den korrekta versionen
av koden som inte kompilerar.

## Källkod

Källkodsfilerna från vilka denna bok är genererad kan hittas på [GitHub][bok].

[bok]: https://github.com/rust-lang/book/tree/master/src
