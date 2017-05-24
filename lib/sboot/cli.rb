require "thor"
require "sboot"

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
      navigator = Sboot::Navigator.new
      navigator.nav_to_root_folder Dir.pwd
      entity = domain_entity(name, generate_attributes(args), environment)
      ng_generation_chain entity if environment == 'ng'
      editor = Sboot::Editor.new entity, "#{ Dir.pwd }/.sbootconf"
      editor.publish
      npm_dependecies_chain if environment == 'fullstack'
      navigator.set_original_path_back
      rescue ArgumentError => e
        puts e.message
      end
    end

    desc "schema {file[svg|xml}",
         "genera lo stack di sboot a partire da un diagramma di draw.io"
    method_options :env => "fullstack"
    def schema file
      run "schema2script #{file}, #{options[:env]}"
      cmd = File.open("sboot_generate.sh", "r+"){ |file| file.read }
      run cmd
    end


    map "archetype" => "new"
    map "i" => "init"
    map "g" => "generate"
    map "s" => "schema"

    private

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
      run 'ng new ng-app --skip-git' if Dir['ng-app'].empty?
      Dir.chdir('ng-app')
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
