[![Build Status](https://travis-ci.org/Simo/sboot.svg?branch=master)](https://travis-ci.org/Simo/sboot)

# Sboot 
Sboot è un'utility a riga di comando per generare funzioni basiliari per applicazioni web e servizi sfruttando Spring Boot, JPA, Hibernate, Swagger ed altre tecnologie.

## Installazione

Per utilizzare `sboot` è necessario avere installato un ambiente Ruby versione > 2.2.0 ed aggiungere il supporto per la compilazione delle estensioni C/C++.
  
  Per l'installazione vera e propria dell'utility digitare da una riga di comando (cmd, PowerShell o altro)

```ruby
gem install sboot
```

## Utilizzo


#### Documentazione

L'utility offre una documentazione in linea per i comandi da chiamare

    $ sboot => mostra tutti i comandi disponibili
    
C'è la possibilità di visualizzare solo la documentazione per uno specifico comando

    $ sboot help [comando]
    
#### Comandi

Ci sono 2 comandi disponibili

1.  il comando per inizializzare `sboot` sull'applicazione in questione, da lanciare dalla root del progetto (dove si trova il file `pom.xml`)

		$ sboot init [package]

	 dove `package` è il percorso relativo all'applicazione (ad esempio quello nel quale risiede la classe di bootstrap dell'applicazione Spring Boot)

		es: sboot init it.insiel.gcs.progetto
    
    Il comando genera il file `.sbootconf` nel quale si trovano i riferimenti ai percorsi relativi per i file da generare. La personalizzazione, al momento, genera alcuni problemi negli import delle varie classi, ma presto sarà completamente funzionante
    
2. il comando per generare il codice vero e proprio

		$ sboot generate [--env] [entity] [properties]
		
	il comando genera lo stack di files richiesto dall'utente partendo dalla definizione dell'entità di dominio sulla quale si vuole lavorare. La flag `env` ha un default impostato a "fullstack".
	
		es: sboot generate --env=backend casa:case id:number:pk indirizzo civico:long dataAcquisto:date
		
		
## Opzioni

Il comando generate nei suoi parametri accetta diverse opzioni

### - - env = {stack}

La lista delle opzioni comprende:

+ persistence: genera l'Entity JPA e il repository associato
+ conversion: arricchisce persistence del DTO corrispondente all'entità
+ business: aggiunge il service corrispondente (interfaccia ed implementazione ed eccezioni), test inclusi
+ backend: completa business sul lato server con il codice di riferimento per il Controller Restful ed esporre i dati in JSON, test inclusi
+ fullstack: genera lo stack end-to-end per il CRUD dell'entità, compresi i test unitari e i test di integrazione, test inclusi
+ api: genera lo stack completo per l'API dell'entità, aggiunge documentazione ed endpoint visuali, test inclusi

		es: sboot generate --env=api casa:case indirizzo civico:long
		
### entity {nome}:{plurale}

L'entity da passare al comando generate è una stringa che può essere composta da un nome semplice e da un un nome e la sua pluralizzazione separati da `:`

+ nome = l'entità ed il suo stack seguono il nome dato
+ nome:plurale = l'entità e il suo stack seguono il nome dato, i percorsi delle risorse rest sfruttano il plurale per definire le collezioni

		es: sboot generate casa
		
		es: sboot generate casa:case
		
	nel primo caso si avrà Casa.java, CasaRepository.java, CasaService.java, CasaController.java ed i percorsi url saranno: "/casa", "casa/{id}"
	nel secondo caso si avrà gli stessi nomi per le classi, ma i percorsi diventeranno: "case", "case/{id}"
	
### properties

Le proprietà dell'entità verranno mappate direttamente sui campi della tabella associata.

+ le proprietà sono stringhe di testo separate da uno spazio
+ le proprietà possono avere 4 forme


| Forma        | Nome           | Tipo  | Constraint |
| ------------- |:---------:|:-----:|:-----:|
| nome      | Nome | String | nessuno |
| nome:tipo      | Nome      |  Tipo | nessuno |
| nome:pk | Nome   | Long | pk |
| nome:tipo:pk | Nome   | Tipo | pk |

+ i tipi riconosciuti sono (valore è case-insensitive)

| Valore | Tipo |
|-------|--------|
| string | 'String' |
| text | 'String' |
| varchar | 'String' |
| varchar2 | 'String' |
| number | 'Long' |
| long | 'Long' |
| int | 'Integer' |
| integer | 'Interger' |
| double | 'Double' |
| numeric | 'Double' |
| date | 'Date' |

 Vengono assunti alcuni default successivamente configurabili:
 
 
 #### nell'Entity

+ la tabella viene chiamata "T_{NOMEENTITA}"
+ viene associata la presenza di una sequence per la generazione dei progressivi dell'id
+ il campo @Id viene inserito di default con tipo "Long" se non viene specificata una colonna con :constraint `pk`.

#### nel Repository

+ viene esposto un metodo "deleteById(Tipo id)"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sboot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
