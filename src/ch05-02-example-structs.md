## Ett exempel på ett program som manvänder structar

För att förstå när vi kan vilja använda structar, låt oss skriva ett program
som beräknar arean för en rektangel. Vi börjar med enstaka variabler och
refaktoriserar sedan om programmet tills vi avänder structar istället.

Låt oss skapa ett ny binärprojekt med Cargo kallat *rectangles* som tar bredden
och höjden för en rektangel angivna i pixlar och beräknar arean för rektangeln.
Listning 5-8 visar ett kortat program med ett sätta att göra precis detta i
vårt projekts *src/main.rs*.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let width1 = 30;
    let height1 = 50;

    println!(
        "The area of the rectangle is {} square pixels.",
        area(width1, height1)
    );
}

fn area(width: u32, height: u32) -> u32 {
    width * height
}
```

<span class="caption">Listing 5-8: Beräkning av area för en rektangel angiven
av separata bredd- och höjdvariabler</span>

Låt oss nu köra programmet via `cargo run`:

```text
The area of the rectangle is 1500 square pixels.
```

Även om listning 5-8 fungerar och räknar ut rektangelns area genoma tt anropa
funktionen `area` med varje dimension kan vi göra det bättre. Bredden och
höjden är relaterade till varandra eftersom de beskriver en enda rektangel.

Problemet med denna kod är uppenbart i signaturen för `area`:

```rust,ignore
fn area(width: u32, height: u32) -> u32 {
```

`area`-funktionen är tänkt att beräkna arean för en rektangel, men funktionen
vi skrev har två parametrar. Parametrarna är relaterade, men det uttrycks
aldrig någonstans i vårt program. Det vore mer läsbart och mer hanterbart att
gruppera bredden och höjden tillsammans. Vi har redan disktuerat ett sätt vi
kan göra det i [“Tupeltypen“][tupeltypen]<!-- ignore -->-avsnittet i kapitel 3:
genom att använda tupler.

### Omfaktorisering med tupler

Listning 5-9 visar en annan version av vårt program som använder tupler.

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let rect1 = (30, 50);

    println!(
        "The area of the rectangle is {} square pixels.",
        area(rect1)
    );
}

fn area(dimensions: (u32, u32)) -> u32 {
    dimensions.0 * dimensions.1
}
```

<span class="caption">Listning 5-9: Bredden och höjden för rektangeln anges med
en tupel</span>

På ett sätt är detta program bättre. Tupler låter oss tillföra lite struktur
och vi skickar nu bara ett argument. Men på ett annat sätt är denna version
mindre tylidg: tupler namnger inte sina element,så vår beräkning har blivit mer
förvirrande eftersom vi måste indexera delarna i tupeln.

Det spelar ingen roll om vi blandar ihop bredd och höjd för areauträkningen, men
om vi vill rita rektangeln på skärmen, då hade det spelat roll! Vi måste komma
ihåg att att `width` motsvarar tupelindex `0` och `height` motsvarar tupelindex
`1`. Om någon annan arbetar med denna koden måste de själv lista ut och komma
ihåg det. Eftersom vi inte har angett betydelsen av datan i vår kod vore det
enkelt att glömma eller blanda ihop dessa värden och orsaka fel.

### Omfaktorisering med structar: Lägga till ytterligare betydelse

Vi använder structar för att lätta till betydelse genom att sätta etiketter på
datan. Vi kan transformera tupel vi använder till en datatyp med ett namn för
helheten så väl som namn för delarna, så som visas i listning 5-10.

<span class="filename">Filnamn: src/main.rs</span>

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!(
        "The area of the rectangle is {} square pixels.",
        area(&rect1)
    );
}

fn area(rectangle: &Rectangle) -> u32 {
    rectangle.width * rectangle.height
}
```

<span class="caption">Listning 5-10: Definition av en `Rectangle`-struct</span>

Här har vi definierat en struct och namngett den `Rectangle`. Inuti
klammerparenteserna har vi definiera fälten `width` och `height`, båda av typen
`u32`. I `main` har vi sedan skapat en särskilt instans av `Rectangle` som har
bredden 30 och höjden 50.

Vår `area`-funktion definieras nu med en parameter vilken vi namngett
`rectangle`, vars typ är ett oföränderligt lån av en struct
`Rectangle`-instans. Som vi nämnde i kapitel 4 vi vill låna structen snarare än
att ta ägandeskap över den. På detta sätt behåller `main` dess ägandeskap och
kan fortsätta använda `rect1`, vilket är anledningen till att vi använder `&` i
funktionssignaturen och dår vi anropar funktionen.

`area`-funktionen använder `width`- och `height`-fälten från
`Rectangle`-instansen. Vår funktionssignature för `area` uttrycker nu exakt vad
vi menar: beräkna arean för `Rectangle` genom att använda `width`- och
`height`-fälten. Detta förmedlar att bredden och höjden är relaterade till
varandra och ger beskrivande namn på värden snarare än använder
tupelindexvärdena `0` och `1`. Detta är en vinst för tydligheten.

### Adding Useful Functionality with Derived Traits

It’d be nice to be able to print an instance of `Rectangle` while we’re
debugging our program and see the values for all its fields. Listing 5-11 tries
using the `println!` macro as we have used in previous chapters. This won’t
work, however.

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!("rect1 is {}", rect1);
}
```

<span class="caption">Listing 5-11: Attempting to print a `Rectangle`
instance</span>

When we run this code, we get an error with this core message:

```text
error[E0277]: `Rectangle` doesn't implement `std::fmt::Display`
```

The `println!` macro can do many kinds of formatting, and by default, the curly
brackets tell `println!` to use formatting known as `Display`: output intended
for direct end user consumption. The primitive types we’ve seen so far
implement `Display` by default, because there’s only one way you’d want to show
a `1` or any other primitive type to a user. But with structs, the way
`println!` should format the output is less clear because there are more
display possibilities: Do you want commas or not? Do you want to print the
curly brackets? Should all the fields be shown? Due to this ambiguity, Rust
doesn’t try to guess what we want, and structs don’t have a provided
implementation of `Display`.

If we continue reading the errors, we’ll find this helpful note:

```text
= help: the trait `std::fmt::Display` is not implemented for `Rectangle`
= note: in format strings you may be able to use `{:?}` (or {:#?} for pretty-print) instead
```

Let’s try it! The `println!` macro call will now look like `println!("rect1 is
{:?}", rect1);`. Putting the specifier `:?` inside the curly brackets tells
`println!` we want to use an output format called `Debug`. The `Debug` trait
enables us to print our struct in a way that is useful for developers so we can
see its value while we’re debugging our code.

Run the code with this change. Drat! We still get an error:

```text
error[E0277]: `Rectangle` doesn't implement `std::fmt::Debug`
```

But again, the compiler gives us a helpful note:

```text
= help: the trait `std::fmt::Debug` is not implemented for `Rectangle`
= note: add `#[derive(Debug)]` or manually implement `std::fmt::Debug`
```

Rust *does* include functionality to print out debugging information, but we
have to explicitly opt in to make that functionality available for our struct.
To do that, we add the annotation `#[derive(Debug)]` just before the struct
definition, as shown in Listing 5-12.

<span class="filename">Filename: src/main.rs</span>

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!("rect1 is {:?}", rect1);
}
```

<span class="caption">Listing 5-12: Adding the annotation to derive the `Debug`
trait and printing the `Rectangle` instance using debug formatting</span>

Now when we run the program, we won’t get any errors, and we’ll see the
following output:

```text
rect1 is Rectangle { width: 30, height: 50 }
```

Nice! It’s not the prettiest output, but it shows the values of all the fields
for this instance, which would definitely help during debugging. When we have
larger structs, it’s useful to have output that’s a bit easier to read; in
those cases, we can use `{:#?}` instead of `{:?}` in the `println!` string.
When we use the `{:#?}` style in the example, the output will look like this:

```text
rect1 is Rectangle {
    width: 30,
    height: 50
}
```

Rust has provided a number of traits for us to use with the `derive` annotation
that can add useful behavior to our custom types. Those traits and their
behaviors are listed in Appendix C. We’ll cover how to implement these traits
with custom behavior as well as how to create your own traits in Chapter 10.

Our `area` function is very specific: it only computes the area of rectangles.
It would be helpful to tie this behavior more closely to our `Rectangle`
struct, because it won’t work with any other type. Let’s look at how we can
continue to refactor this code by turning the `area` function into an `area`
*method* defined on our `Rectangle` type.

[the-tuple-type]: ch03-02-data-types.html#the-tuple-type
