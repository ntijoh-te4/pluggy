# Pluggy

Eftersom Servy innehåller en del svårfixade buggar byggde jag en skelettapplikation baserat på [Plug](https://hex.pm/packages/plug) och [Cowboy](https://github.com/ninenines/cowboy). Plug & Cowboy är (som nämndes i de senare Servy-filmerna)  de ramverk som i stort sett alla Elixir-webbramverk är baserade på. 

Pluggy följer samma generella upplägg som Servy, men med andra komponenter.

## Konfigurering och installation av dependencies

### Docker

Vi kommer köra vår Postgres databas-server i en docker.

Skapa ett konto på [https://hub.docker.com/](https://hub.docker.com/) och ladda ner och installera [docker-desktop för mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

OBS: Om du startar om din dator måste du eventuellt starta docker-desktop-applikationen igen (beroende på vilka inställningar du valde när du installerade den).

### Postgres

#### Installation

För att hämta docker-imagen från docker hub: `docker pull postgres`

#### Starta

När docker-imagen är nedladdad kan du starta containern genom

`docker run --rm   --name pg-docker -e POSTGRES_PASSWORD=docker -d -p 5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data  postgres`

Följande växlar skickades till `docker run`:

* `--rm*`: Tar bort containern när vi är klara med den. Detta sparar diskutrymme (speciellt om vi kör många olika containers)

- `-- name`: namnet på containern. Används för att identifera den. Bra att veta om man t.ex måste stoppa containern.
- `-e`: Skicka vidare miljövariablen `POSTGRES_PASSWORD` med värdet `docker` till containern. Detta sätter superuser lösenordet för Postgres. 
- `-d`: Startar containern i bakgrunden (låter oss fortsätta skriva nya kommandon i samma terminalfönster)
- `-p`: Kopplar port 5432 på localhost till port 5432 i containern. Port 5432 är Postgres standardport, vilket innebär att vi inte behöver konfigurera eventuella verktyg för att prata med postgres mer än absolut nödvändigt.
- `-v`: Mounta `/var/lib/postgresql/data` i containern till `$HOME/docker/volumes/postgres` på host-datorn. Detta så att postgresdatabasen överlever även när containern tas bort.

#### PSQL

PSQL är ett program som låter oss koppla upp mot postgres-databas-servrar.

Installation: 

````zsh
brew install libpq
echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
````

Koppla upp mot databasservern:

````zsh
psql -h localhost -U postgres -d postgres
````

Följande växlar skickades till psql:

* `-h`: Host (kan även vara en ip-adress eller hostname)
* `-U`: User- namnet på användaren vi vill logga in som
* `-d`Database - namnet på databasen vi vill koppla upp oss mot

Ange sen lösenordet (`docker`) eller vad som sattes i `docker run` enligt ovan.

I psql kan du använda `help` eller `\?` för att få fram hjälp. `\q` stänger ner psql.

Du kan även använda vanliga SQL-kommandon som t.ex `CREATE TABLE ...` eller `SELECT * FROM ...`

`\d` listar tabellerna `\d+ tabellens-namn` visar tabellens schema.

## Filer och arkitektur

Pluggy använder sig av en [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)-arkitektur med en router.

### Router

Finns i `lib/pluggy/router.ex`

hanterar http-requests och skickar dem vidare till relevant controller

### Controllers

Finns i `lib/pluggy/controllers/<<resurs>>.ex`

Tar emot data från routern, innehåller logik för validering, etc. Pratar med Models (som pratar med databasen), och skickar relevant data till View för rendering till webbläsaren

### Models

Finns i `lib/pluggy/models/<<resurs>>.ex`

Pratar med databasen, skapar structs, kan även innehålla andra relevanta funktioner

### Views

Finns i `lib/pluggy/templates/<<resurs>>/*.(eex|slime)`

Renderar [slime](https://github.com/slime-lang/slime) eller eex-filer i templates-mappen. Gör det även möjligt att använda en layout-fil med gemensam html.

### Statiska filer

Ska ligga i `priv/static/*`

Här lägger ni de filer webbläsaren behöver ha åtkomst till, t.ex css, bilder, js. Observera att när ni länkar in filen i er template inte ska ange `/priv/static/filensnamn.css` som sökväg utan enbart `/filensnamn.css`. 

## Uppstart

### Första gången: 

#### Gruppledare: 

1. Skapa nya repot från template: `gh repo create <pluggy-ditt-lag-namn> --template="https://github.com/ntijoh-te4/pluggy" --clone --public`
2. Gå in på settings på det nya repositoriet och lägg till ditt team under collaborators
3. `git pull origin master`
4. `git branch -u origin/master`

#### Gruppmedlem:
Klona repot som din gruppledare skapade med: `gh repo clone <GH REPO "URL">`

### Samtliga

1. Se till att docker desktop är igång
2. Starta postgres docker enligt ovan
3. `mix deps.get`

### Seeda databasen

I `lib/mix/seed.ex` finns ett mix-script för att nollställa och seeda databasen. Kör `mix seed` för att köra scriptet.

### Starta servern

1. `iex -S mix` eller `mix run --no-halt`
2. Surfa till http://localhost:3000 (eftersom det inte finns nån route för `/` i `router.ex` kan det vara mer givande att surfa till http://localhost:3000/fruits


