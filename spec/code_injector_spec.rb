require 'spec_helper'

describe Sboot::CodeInjector do
    
    subject(:config){ Sboot::Config.new "#{File.dirname __FILE__}/assets/.sbootconf"  }
    subject(:master){ DomainEntity.new name: 'Casa'   , name_pluralized: 'Case'   , properties: [] }
    subject(:detail){ DomainEntity.new name: 'Persona', name_pluralized: 'Persone', properties: [], join_column: 'id_casa' }
    
    subject(:injector){ injector = Sboot::CodeInjector.new config: config }
    
    describe 'initialize' do
        it 'should be correctly initialize' do
            expect(injector).to be_an_instance_of Sboot::CodeInjector
        end
    end
    
    entity_path = 'src/main/java/it/insiel/gcs/progetto/persistence/entities/'
    
    describe 'when injecting code' do
        it 'should modify source if code is missing' do
            src_file = File.read("#{File.dirname __FILE__}/assets/entity_Casa.java")
            # Creo il file nel repository
            FileUtils.mkdir_p ".sboot-repo/#{entity_path}"
            File.write ".sboot-repo/#{entity_path}/Casa.java", src_file
            # Creo il file nei sorgenti
            FileUtils.mkdir_p entity_path
            File.write "#{entity_path}/Casa.java", src_file
            
            # Inietto del codice
            code = ERB.new(get_template("entity_one_to_many"), nil, '-').result(binding)
            injector.inject_code master, detail, code, injector.persistence_file
            
            expect(File.read ".sboot-repo/#{entity_path}/Casa.java").to eq(File.read("#{File.dirname __FILE__}/assets/entity_OneToMany_Casa.java"))
        end

        it 'should skip if code already present' do
            src_file = File.read("#{File.dirname __FILE__}/assets/entity_OneToMany_Casa.java")
            # Creo il file nel repository
            FileUtils.mkdir_p ".sboot-repo/#{entity_path}"
            File.write ".sboot-repo/#{entity_path}/Casa.java", src_file
            # Creo il file nei sorgenti
            FileUtils.mkdir_p entity_path
            File.write "#{entity_path}/Casa.java", src_file
            
            # Inietto del codice
            code = ERB.new(get_template("entity_one_to_many"), nil, '-').result(binding)
            injector.inject_code master, detail, code, injector.persistence_file
            
            expect(File.read ".sboot-repo/#{entity_path}/Casa.java").to eq(src_file)
        end
    end
    
    after(:each) { Dir.glob(['src','.sboot-repo']).each { |f| FileUtils.rm_rf f } }
    
    private
    
    def get_template template_name
        File.read "#{File.dirname __FILE__}/../lib/sboot/scaffolds/#{template_name}.erb"
    end
    
    # Sarebbe da creare una classe utils, questo metodo è duplicato
    def camel_rather_dash name,options={}
        ret = name.split('_').collect(&:capitalize).join if options[:firstLetter] == 'upcase'
        ret = name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } if options[:firstLetter] == 'downcase'
        ret = name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } unless options.key? :firstLetter
        ret
    end
end
