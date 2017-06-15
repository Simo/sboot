require 'sboot/source_writer'
require 'fileutils'
require 'erb'

# sboot new it.insiel.gcs progetto
# cd progetto
# sboot generate casa:case casa_id:integer:pk indirizzo:string
# sboot generate persona:persone pesona_id:int:pk nome cognome
# sboot relation casa:casa_id OneToMany persona:persona_id
#
# src/main/java/tex/software/prova/persistence/entities/Persona.java

module Sboot
    class CodeInjector<SourceWriter
        attr_accessor :config, :master, :detail
        
        def initialize options={}
            @config   = options[:config]
            super sboot_repo_path: @config['sboot_repo_path']
        end
        
        def inject_code master, detail, code, filetype
            filename    = file_path(master, filetype)
            fileToPatch = File.read("#{@config['sboot_repo_path']}/#{filename}")
            # Verifico se il codice è già presente
            unless fileToPatch =~ Regexp.new(Regexp.escape code)
                # Inserisco il nuovo codice nel punto desiderato, prima del primo metodo pubblico
                newFile = fileToPatch.sub(/(\n\s+public\s+\w+\s+\w+\()/, "\n\n#{code}\\1")
                # Salvo il file, preservando le modifiche utente
                write_file filename, newFile
            end
        end
        
        def persistence_file
            FileType.new key: 'persistence', reference: @config["entity.path"], extension: @config["entity.extension"]
        end
        
        private
        
        def file_path master, file
            path = "#{@config['main_path']}/#{create_path file}"
            "#{path}/#{ master.name.split('_').collect(&:capitalize).join unless file.key == :messagedto }#{file.ext}.java"
        end
        
        def get_template template_name
            File.read "#{File.dirname __FILE__}/scaffolds/#{template_name}.erb"
        end

        def package_to_path
            @config['package'].gsub(/\./,"/")
        end
        
        def create_path file
            "#{package_to_path}/#{file.ref}"
        end

        def camel_rather_dash name,options={}
            ret = name.split('_').collect(&:capitalize).join if options[:firstLetter] == 'upcase'
            ret = name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } if options[:firstLetter] == 'downcase'
            ret = name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } unless options.key? :firstLetter
            ret
        end
        
    end
end
