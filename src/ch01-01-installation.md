## Installation

Det första steget är att installera Rust. Vi kommer att hämta Rust via
`rustup`, ett kommandoradsverktyg för att hantera Rust-versioner och
tillhörande verktyg. Du kommer att behöva en internetuppkoppling för
hämtningen.

> Notera: Om du av någon anledning föredrar att inte använda `rustup`, se
> [installationssidan för Rust](https://www.rust-lang.org/tools/install) för
> andra alternativ.

Följande steg installerar den senaste stabila versionen av Rust-kompilatorn.
Rusts stabilitetsgarantier säkerställer att alla exemplen i boken som
kompilerar kommer att fortsätta att kompilera med nyare Rust-versioner. Utdatan
kanske skiljer sig något mellan versioner då Rust ofta förbättrar fel- och
varningsmeddelanden. Med andra ord, oavsett vilken nyare stabila version av
Rust som du installerar via dessa steg bör fungera som förväntat med den här
bokens innehåll.

> ### Notation för kommandorader
>
> I detta kapitel och genom hela boken kommer vi att visa vissa kommandon som
> används i terminalen. Alla rader som du kan skriva in i en terminal börjar
> med `$`. Du behöver inte skriva in dollartecknet `$`; det indikerar början av
> varje kommando. Rader som inte börjar med `$` visar typiskt utmatning från
> det föregående kommandot. PowerShell-specifika exempel kommer att använda `>`
> snarare än `$`.

### Installera `rustup` under Linux eller macOS

Om du använder Linux eller macOS, öppna en terminal och mata in följande
kommando:

```text
$ curl https://sh.rustup.rs -sSf | sh
```

Kommandot hämtar ett skript och startar installationen av verktyget `rustup`,
vilket installerar den senaste stabila versionen av Rust. Du kan eventuellt bli
tillfrågad om ditt lösenord. Om installationen är framgångsrik kommer följande
rad att visas:

```text
Rust is installed now. Great!
```

Om du föredrar det går det bra att hämta skriptet och inspektera det innan du
kör det.

Installationsskriptet lägger automatiskt till Rust till din systemsökväg (PATH)
efter nästa inloggning. Om du vill börja använda Rust direkt istället för att
starta om din terminal, kör följande kommando i ditt skal för att manuellt
lägga till Rust till din systemsökväg (PATH):

```text
$ source $HOME/.cargo/env
```

Alternativt kan du lägga till följande rad i din *~/.bash_profile*:

```text
$ export PATH="$HOME/.cargo/bin:$PATH"
```

Du behöver dessutom en länkare av något slag. Det är troligt att det redan
finns en installerad, men när du försöker att kompilera ett Rust-program och
får fel som indikerar att en länkare inte kan köra då innebär det att en
länkare inte är installerad på ditt system och att du kommer att behöva att
installera en manuellt. C-kompilatorer kommer ofta med den rätta länkaren.
Kontrollera dokumentationen för din plattform för hur du installerar en
C-kompilator. En del vanliga Rust-paket beror på C-kod så de behöver därför en
C-kompilator. Det kan därför vara löna sig att installera en nu.

### Installera `rustup` under Windows

Under Windows, gå till [https://www.rust-lang.org/tools/install][installera]
och följ instruktionerna för hur du installerar Rust. Vid en punkt i
installationen kommer du att få ett meddelande som förklarar att du också
behöver byggverktyg för C++ från Visual Studio 2013 eller senare. Det enklaste
sättet att få tag på byggverktygen är att installera [Byggverktyg för Visual
Studio 2019][visualstudio]. Verktygen finns under avsnittet "Other Tools and
Frameworks".

[installera]: https://www.rust-lang.org/tools/install
[visualstudio]: https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2019

Resten av denna bok använder kommandon som ska fungera i både *cmd.exe* och
PowerShell. Om det finns specifika skillnader kommer vi att förklarar vilket du
kan använda.

### Uppdatera och avinstallera

Efter att du installera Rust via `rustup` kan du enkelt uppdatera till den
senaste versionen. Från ditt skal, kör följande uppdateringsskript:

```text
$ rustup update
```

För att avinstallera Rust och `rustup`, kör följande avinstallationsskript från
ditt skal:

```text
$ rustup self uninstall
```

### Felsökning

För att kontrollera huruvida du har Rust installerat korrekt, öppna ett skal
och skriv in denna rad:

```text
$ rustc --version
```

Du för se versionsnumret, commit-hashen och commit-datum för den senaste
stabila versionen som har släppts enligt följande format:

```text
rustc x.y.z (abcabcabc yyyy-mm-dd)
```

Om du ser denna information har du framgångsrikt installerat Rust! Om du inte
ser denna information och du kör under Windows, kontrollera att Rust finns i
systemvariabeln `%PATH%`. Om allt det är korrekt och Rust fortfarande inte
fungerar, finns det ett flertal ställen där du kan få hjälp. Det enklaste är
kanalen #beginners på [Rusts officiella Discord][discord]. Där kan du chatta
med andra Rust-användare (ibland kallas de på engelska för Rustaceans) som kan
hjälpa dig. Andra bra resurser är [användarforumen][forum] och [Stack
Overflow][stackoverflow].

[discord]: https://discord.gg/rust-lang
[forum]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust

### Lokal dokumentation

Installationen inkluderar också en kopia av dokumentationen lokalt så att du
kan läsa den även om du är frånkopplad. Kör `rustup doc` för att öppna den
lokala dokumentationen i din webbläsare.

När en typ eller en funktion tillhandahålls av standardbiblioteket och du inte
är säker på vad den gör eller hur man använder den, använd dokumentationen för
applikationsprogrammeringsgränssnittet (Application Programming Interface, API)
för att ta reda på det!
