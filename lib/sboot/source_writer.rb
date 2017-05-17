require 'diff_match_patch_native'

module Sboot
    class SourceWriter
        attr_accessor :sboot_repo_path
        
        def initialize(options={})
            @repository_path = options[:sboot_repo_path]
            @src_path        = "."
        end
        
        def write_file(filename, text)
            unless File.exists? "#{@src_path}/#{filename}"
                write_source_file filename, text
                write_repo_file   filename, text
                return
            end
            
            # Controllo di sicurezza
            abort "File '#{repo_file filename}' not found" unless File.exists? "#{repo_file filename}"
            
            dmp         = DiffMatchPatch.new
            refFile     = File.read(repo_file filename)
            fileToPatch = File.read(filename)
            patches     = dmp.patch_make(refFile, text) 
            result      = dmp.patch_apply(patches, fileToPatch)
            
            # Verifico che tutte le patch siano state applicate
            unless result[1].all?
                STDERR.puts "WARNING: Patch del file '#{filename}' non completa"
                backup_file filename
            end
            
            # Salvo il sorgente modificato
            write_source_file filename, result[0]
            # Salvo il nuovo file di riferimento
            write_repo_file   filename, text
        end
        
        private
        
        def write_repo_file(filename, text)
            puts "#{filename}"
            FileUtils.mkdir_p "#{File.dirname(repo_file filename)}"
            File.write "#{repo_file filename}", text
        end
        
        def write_source_file(filename, text)
            FileUtils.mkdir_p "#{@src_path}/#{File.dirname(filename)}"
            File.write "#{@src_path}/#{filename}", text
        end
        
        def repo_file(filename)
            "#{@repository_path}/#{filename}"
        end
        
        def backup_file(filename)
            File.write "#{filename}.orig", File.read(filename)
        end
    end
end
