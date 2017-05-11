require "thor"
require "sboot"

module Sboot
  class CLI < Thor
    include Thor::Actions

    source_root "#{File.dirname __FILE__}/scaffolds/"

    desc "init [package]",
         "il comando init genera il file di configurazione per il generatore sboot"
    def init(package)
      writer = Sboot::ConfigWriter.new :package => package
      writer.write
    end


    desc "generate [ENV] {entita'} {proprieta'[:tipo][:constraint]}",
      "la flag [ENV] accetta come parametri: fullstack(default),api,backend,business,conversion,persistence"
    method_options :env => "fullstack"
    def generate(name, *args)
      environment = options[:env] || 'fullstack'
      navigator = Sboot::Navigator.new
      navigator.nav_to_root_folder Dir.pwd
      editor = Sboot::Editor.new domain_entity(name, generate_attributes(args), environment), "#{ Dir.pwd }/.sbootconf"
      editor.publish
      if environment == 'fullstack'
          # procedure per effettuare l'installazione delle dipendenze di npm
          # spostiamo nella cartella del file package.json
          Dir.chdir('src/main/webapp/resources')
          # eseguiamo il comando di installazione delle dipendenze
          run 'npm install'
          # riposizioniamo nella cartella root (importante per i test)
      end
      navigator.set_original_path_back
    end

    desc "generate an ng app as frontend",
         "generate an ng app as frontend"
    def ng
      #generate_ng_app
      folder = Dir.getwd
      Dir.chdir 'ng-app'
      generate_ng_module
      generate_ng_controller
      generate_ng_model
      generate_ng_service
      add_ng_service
    end

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

    def generate_ng_app
      run 'ng new ng-app'
    end

    def generate_ng_model
      run 'ng g class entita/entita'
    end

    def generate_ng_controller
      run 'ng g component entita'
    end

    def generate_ng_service
      run 'ng g service entita/entita'
    end

    def generate_ng_module
      run 'ng g module entitas'
    end

    def add_ng_service
      Dir.chdir 'src/app'
      contents = File.open("app.module.ts", "r+"){ |file| file.read }
      new_contents = contents.gsub /imports: \[([\w\,\.\(\)\n\r\s]+)/, 'imports: [\1,'

      File.open 'app.module.ts', 'w' do |f|
        f.puts new_contents
      end
    end

  end
end
