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
#         navigator = Sboot::Navigator.new
#         navigator.nav_to_root_folder Dir.pwd
        # Inizializzo il repository di sboot, utile per ricarica le entità (o altro)
        repo = Sboot::ConfigRepository.new config: Sboot::Config.new("#{ Dir.pwd }/.sbootconf")
        # Provo a vedere se l'entità era stata definita in precedenza
        entity = repo.load_entity(domain_names(name)[:name])
        
        if entity.nil?
            entity = domain_entity(name, generate_attributes(args), environment)
        else
            entity.define_attributes generate_attributes(args) # TODO: L'environment serve?
        end

        generate_code entity, environment
#         ng_generation_chain entity if environment == 'ng'
#         editor = Sboot::Editor.new entity, "#{ Dir.pwd }/.sbootconf"
#         editor.publish
#         npm_dependecies_chain if environment == 'fullstack'
#         navigator.set_original_path_back
        
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
    
    desc "relation master:key relation detail:key", "definisce relazioni tra entità"
    def relation(*args)
        # configurazione
#         navigator = Sboot::Navigator.new
#         navigator.nav_to_root_folder Dir.pwd
        config = Sboot::Config.new "#{ Dir.pwd }/.sbootconf"

        master_def = parse_entity args[0]
        detail_def = parse_entity args[2]
        
        # Inizializzo il repository di sboot, utile per ricarica le entità (o altro)
        repo = Sboot::ConfigRepository.new config: config
        # Provo a vedere se l'entità era stata definita in precedenza
        master = repo.load_entity(master_def[:name])
        detail = repo.load_entity(detail_def[:name])
        
        abort "Entità '#{master_def[:name]}' non definita: usare prima il comando 'generate'" if master.nil?
        abort "Entità '#{detail_def[:name]}' non definita: usare prima il comando 'generate'" if detail.nil?
        
        relation = case args[1].downcase
            when /one_?to_?one/
                'Sboot::OneToOne'
            when /one_?to_?many/
                master.one_to_many detail, detail_def[:key]
                detail.many_to_one master, master_def[:key]
            when /many_?to_?one/
                'Sboot::ManyToOne'
            when /many_?to_?many/
                'Sboot::ManyToMany'
            else
                abort "Tipo di relazione '#{args[1]}' non riconosciuta"
        end
        
        # Generazione del codice
        generate_code master, "fullstack"
        generate_code detail, "fullstack"
        
        # Salvo la definizione per usi futuri (ad esempio definizione di relazioni)
        repo.save_entity master
        repo.save_entity detail
        
#         clazz = relation.split('::').inject(Object) {|o,c| o.const_get c}
# 
#         injector = clazz.new config: config, master: master, relation: relation, detail: detail
#         injector.create_relation
    end

    map "archetype" => "new"
    map "i" => "init"
    map "g" => "generate"
    map "s" => "schema"

    private
    
    def parse_entity entity
        parts = entity.split(':')
        
        { name: parts[0], key: parts[1] }
        
#         DomainEntity.new name: parts[0], name_pluralized: parts[1], join_column: parts[2], properties: [])]
    end
    
    def generate_code entity, environment
        navigator = Sboot::Navigator.new
        navigator.nav_to_root_folder Dir.pwd
        ng_generation_chain entity if environment == 'ng'
        editor = Sboot::Editor.new entity, "#{ Dir.pwd }/.sbootconf"
        editor.publish
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
