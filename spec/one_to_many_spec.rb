require 'spec_helper'

describe Sboot::OneToMany do
    
    subject(:config){ Sboot::Config.new "#{File.dirname __FILE__}/assets/.sbootconf"  }
    subject(:master){ DomainEntity.new name: 'Casa'   , name_pluralized: 'Case'   , properties: [] }
    subject(:detail){ DomainEntity.new name: 'Persona', name_pluralized: 'Persone', properties: [], join_column: 'id_casa' }
     subject(:injector){ injector = Sboot::OneToMany.new config: config, master: master, detail: detail }
    
    entity_path = 'src/main/java/it/insiel/gcs/progetto/persistence/entities/'
    
    describe 'initialize' do
        it 'should be correctly initialize' do
            expect(injector).to be_an_instance_of Sboot::OneToMany
        end
    end
    
    describe 'should inject code' do
        before(:each) do
            ['Casa.java','Persona.java'].each do |filename|
                src_file = File.read("#{File.dirname __FILE__}/assets/entity_#{filename}")
                # Creo il file nel repository
                FileUtils.mkdir_p ".sboot-repo/#{entity_path}"
                File.write ".sboot-repo/#{entity_path}/#{filename}", src_file
                # Creo il file nei sorgenti
                FileUtils.mkdir_p entity_path
                File.write "#{entity_path}/#{filename}", src_file
            end
        end
        
        it 'into master entity' do
            injector.apply_changes
            
            expect(File.read ".sboot-repo/#{entity_path}/Casa.java").to eq(File.read("#{File.dirname __FILE__}/assets/entity_OneToMany_Casa.java"))
        end

        it 'into detail entity' do
            injector.apply_changes
            
            expect(File.read ".sboot-repo/#{entity_path}/Persona.java").to eq(File.read("#{File.dirname __FILE__}/assets/entity_OneToMany_Persona.java"))
        end
    end

#     after(:each) { Dir.glob(['src','.sboot-repo']).each { |f| FileUtils.rm_rf f } }
end

