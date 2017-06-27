# encoding: utf-8
require "thor"
require "sboot"
require "fileutils"

module Sboot
  class CLI < Thor
    include Thor::Actions

    source_root "#{File.dirname __FILE__}/scaffolds/"

    desc "new [package] [progetto]", "il comando genera un nuovo progetto a partire dall'archetype maven"
    def new(package, progetto)
      run "mvn archetype:generate --batch-mode -DarchetypeGroupId=it.insiel -DarchetypeArtifactId=sboot-archetype -DarchetypeVersion=1.0.0-SNAPSHOT -DgroupId=#{package} -DartifactId=#{progetto} -Dversion=1.0.0-SNAPSHOT -Dlibrary-name=dummyLibrary -Dresource-name=info"
      Dir.chdir "#{progetto}"
      init(package)
    end

    desc "init [package]",
         "il comando init genera il file di configurazione per il generatore sboot"
    def init(package)
      project_name = File.basename(Dir.pwd)
      writer = Sboot::ConfigWriter.new :project_name => project_name,:package => package
      writer.write
    end


    desc "generate [ENV] {entita'} {proprieta'[:tipo][:constraint]}",
      "la flag [ENV] accetta come parametri: fullstack(default),api,backend,business,conversion,persistence"
    method_options :env => "fullstack"
    def generate(name, *args)
      begin
        environment = options[:env] || 'fullstack'
        # Inizializzo il repository di sboot, utile per ricaricare le entità (o altro)
        repo = Sboot::ConfigRepository.new config: Sboot::Config.new("#{ Dir.pwd }/.sbootconf")
        # Provo a vedere se l'entità era stata definita in precedenza
        entity = repo.load_entity(domain_names(name)[:name])
        
        if entity.nil?
            # Entità non trovata, suppongo sia nuova
            entity = domain_entity(name, generate_attributes(args), environment)
        else
            # Entità trovata, aggiorno l'elenco degli attributi/proprietà
            entity.define_properties generate_attributes(args) # TODO: L'environment serve?
        end

        generate_code entity, environment
        generate_npm environment
        
        # Salvo la definizione per usi futuri (ad esempio definizione di relazioni)
        repo.save_entity entity
      rescue ArgumentError => e
        puts e.message
      end
    end

    desc "schema {file[svg|xml}",
         "genera lo stack di sboot a partire da un diagramma di draw.io"
    method_options :env => "fullstack"
    def schema file
      environment = options[:env] || "fullstack"
      run "schema2script sboot --env=#{environment} #{file}"
      lines = File.open("sboot_generate.sh", "r+"){ |file| file.read }
      lines.scan(/sboot[\s]+.+/){ |command| run command}
      run "schema2script ddl #{file}"
      FileUtils.rm_rf "sboot_generate.sh"
    end
    
    desc "relation [options] master:proprietà[:nome] relation detail:proprietà[:nome]", "Definisce relazioni tra entità"
    method_option :env,    :enum    => [ "fullstack", "api", "backend", "business", "conversion", "persistence" ],
                           :default => "fullstack",
                           :desc    => "tipo di stack da generare"
    def relation(*args)
      # configurazione
      config = Sboot::Config.new "#{ Dir.pwd }/.sbootconf"
      # Inizializzo il repository di sboot, utile per ricaricare le entità (o altro)
      repo = Sboot::ConfigRepository.new config: config
      # Carico le precedenti definizioni delle entità, se esistono
      master_def = parse_entity repo, args[0]
      detail_def = parse_entity repo, args[2]
        
      master = master_def[:entity]
      detail = detail_def[:entity]
        
      relation = case args[1].downcase
        when /one_?to_?one/
#           STDERR.puts "Non implementato".light_red
#           return
          detail.ignore_property detail_def[:property]
          master.one_to_one detail, detail_def[:property], detail_def[:name] || master.name
          detail.inverse_one_to_one master, detail_def[:property], detail_def[:name]
        when /one_?to_?many/
          # La proprietà deve essere ignorata durante la generazione, viene generata come join
          detail.ignore_property detail_def[:property]
          master.one_to_many detail, detail_def[:property], detail_def[:name] || master.name
          # Il legame è dato dal campo del detail
          detail.many_to_one master, detail_def[:property], detail_def[:name]
        when /many_?to_?one/
          master_def, detail_def = detail_def, master_def
          # La proprietà deve essere ignorata durante la generazione, viene generata come join
          detail.ignore_property detail_def[:property]
          master.one_to_many detail, detail_def[:property], master_def[:name] || master.name
          # Il legame è dato dal campo del detail
          detail.many_to_one master, detail_def[:property], detail_def[:name] || master.name
        when /many_?to_?many/
          STDERR.puts "Non implementato".light_red
          return
        else
          abort "Tipo di relazione '#{args[1]}' non riconosciuta"
      end
      
      # Generazione del codice
      generate_code master, options[:env]
      generate_code detail, options[:env]
       
      # Salvo la definizione per usi futuri (ad esempio definizione di relazioni)
      repo.save_entity master
      repo.save_entity detail
    end
    
    desc "modify [options] {entità} {proprieta'[:tipo][:constraint]}", "Aggiunge/modifica proprietà ad un'entità"
    method_option :env,    :enum    => [ "fullstack", "api", "backend", "business", "conversion", "persistence" ],
                           :default => "fullstack",
                           :desc    => "tipo di stack da generare"
    def modify(name, *args)
      environment = options[:env] || 'fullstack'
      # Inizializzo il repository di sboot, utile per ricaricare le entità (o altro)
      repo = Sboot::ConfigRepository.new config: Sboot::Config.new("#{ Dir.pwd }/.sbootconf")
      # Provo a vedere se l'entità era stata definita in precedenza
      entity = repo.load_entity(name)
            
      abort "Entità '#{name}' non definita: usare prima il comando 'generate'".light_red if entity.nil?
            
      # Entità trovata, aggiorno l'elenco degli attributi/proprietà
      entity.define_properties generate_attributes(args) # TODO: L'environment serve?
       
      generate_code entity, environment
      generate_npm environment
        
      # Salvo la definizione per usi futuri (ad esempio definizione di relazioni)
      repo.save_entity entity
    end
      
    desc "remove [options] {entità} {proprietà}", "Rimuove proprietà da un'entità"
    method_option :env,    :enum    => [ "fullstack", "api", "backend", "business", "conversion", "persistence" ],
                           :default => "fullstack",
                           :desc    => "tipo di stack da generare"
    def remove(name, *args)
      environment = options[:env] || 'fullstack'
      # Inizializzo il repository di sboot, utile per ricaricare le entità (o altro)
      repo = Sboot::ConfigRepository.new config: Sboot::Config.new("#{ Dir.pwd }/.sbootconf")
      # Provo a vedere se l'entità era stata definita in precedenza
      entity = repo.load_entity(name)
        
      abort "Entità '#{name}' non definita: usare prima il comando 'generate'".light_red if entity.nil?
        
      # Entità trovata, aggiorno l'elenco degli attributi/proprietà
      args.each {|p| entity.remove_property p}
        
      generate_code entity, environment
      generate_npm environment
        
      # Salvo la definizione per usi futuri (ad esempio definizione di relazioni)
      repo.save_entity entity
    end
    
    map "archetype" => "new"
    map "i" => "init"
    map "g" => "generate"
    map "s" => "schema"
    map "m" => "modify"

    private
    
    def parse_entity repo, entity
      parts = entity.split(':')
      
      entity   = repo.load_entity(parts[0])
      abort "Entità '#{parts[0]}' non definita: usare prima il comando 'generate'".light_red if entity.nil?
      property = if parts.length > 1 then parts[1] else entity.pk end
#       name     = if parts.length > 2 then parts[2] else entity.java_class_name end
      name     = parts[2] if parts.length > 2
      
      { entity: entity, property: property, name: name }
    end
    
    def generate_code entity, environment
      navigator = Sboot::Navigator.new
      navigator.nav_to_root_folder Dir.pwd
      ng_generation_chain entity if environment == 'ng'
      editor = Sboot::Editor.new entity, "#{ Dir.pwd }/.sbootconf"
      editor.publish
#       npm_dependecies_chain if environment == 'fullstack'
      navigator.set_original_path_back
    end
    
    def generate_npm environment
        navigator = Sboot::Navigator.new
        navigator.nav_to_root_folder Dir.pwd
        npm_dependecies_chain if environment == 'fullstack'
        navigator.set_original_path_back
    end

    def domain_names name
      names = {}
      array_of_names = name.split(":")
      if array_of_names.length == 1
        names[:name] = array_of_names[0]
        names[:pluralize] = nil
      else
        names[:name] = array_of_names[0]
        names[:pluralize] = array_of_names[1]
      end
      names
    end

    def generate_attributes args
      resolver = Sboot::ArgsResolver.new
      resolver.resolve args
    end

    def domain_entity name, properties, environment
      DomainEntity.new name: domain_names(name)[:name], name_pluralized: domain_names(name)[:pluralize], properties: properties, environment: environment
    end

    def npm_dependecies_chain
      Dir.chdir('src/main/webapp/resources')
      run 'npm install'
    end

    def ng_generation_chain entity
      started_from = Dir.pwd
      FileUtils.mkdir_p "src/main/webapp/resources"
      Dir.chdir('src/main/webapp/resources')
      new_app = Dir['ng-app'].empty?
      run 'ng new ng-app --skip-git' if new_app
      Dir.chdir('ng-app')
      run 'npm install jquery bootstrap --save' if new_app
      run "ng g component #{entity.collection_downcase}/#{entity.collection_downcase}Elenco"
      run "ng g component #{entity.collection_downcase}/#{entity.single_downcase}Dettaglio"
      run "ng g component #{entity.collection_downcase}/#{entity.single_downcase}Form"
      run "ng g component #{entity.collection_downcase}/#{entity.single_downcase}Formreactive"
      run "ng g interface #{entity.collection_downcase}/#{entity.single_downcase}"
      run "ng g service #{entity.collection_downcase}/#{entity.single_downcase}"
      Dir.chdir started_from
    end
  end
end
