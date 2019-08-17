## Kommentarer

Alla programmerare strävar efter att göra deras kod lätt att förstå, men ibland
behövs extra kommentarer. I dessa fall lämnar programmerare noteringar eller
*kommentarer* i källkoden som kompilatorn kommer att hoppa över, men som
människor som läser källkoden kan finna hjälpsamma.

Här är en enkel kommentar:

```rust
// hejsan, världen
```

I Rust måste kommentarer börja med två snedstreck och de fortsätter till slutet
på raden. För kommentarer som är längre än en enstaka rad måste du inkludera
`//` på varje rad, så här:

```rust
// Så, vad vi gör här är komplicerat, lång nog att vi måste ha flera
// rader kommentarer för att göra det! Puh! Förhoppningsvis kommer denna
// kommentar att förklara vad som pågår.
```

Kommentarer kan också placeras på slutet av rader som innehåller kod:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    let lucky_number = 7; // Jag har tur idag
}
```

Men du kommer oftare att se att de används enligt detta format, med kommentaren
på en separat rad ovanför koden den kommenterar:

<span class="filename">Filnamn: src/main.rs</span>

```rust
fn main() {
    // Jag har tur idag
    let lucky_number = 7;
}
```

Rust har också en annan typ av kommentar, dokumentationskommentarer, vilket vi
kommer att diskutera i avsnittet ”Publicering av en crate på crates.io” i
kapitel 14.
