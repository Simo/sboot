require 'spec_helper'

describe Sboot::ConfigRepository do
    
    subject(:config){ Sboot::Config.new "#{File.dirname __FILE__}/assets/.sbootconf" }
    subject(:repo){ Sboot::ConfigRepository.new config: config }
    
    describe 'initialize' do
        it 'should be correctly initialize' do
            expect(repo).to be_an_instance_of Sboot::ConfigRepository
        end
    end
    
    describe 'manage' do
        it 'should save an entity as YAML' do
            entity = DomainEntity.new name: 'casa', name_pluralized: 'case', properties: [
                  Sboot::Property.new(name: 'casa_id'  , type: 'Integer', constraint: 'pk'),
                  Sboot::Property.new(name: 'indirizzo', type: 'String' , constraint: nil)
                ], environment: 'fullstack'
            repo.save_entity entity
            
            expect(File.exists? "#{config['sboot_repo_path']}/casa.yml").to be(true)
        end

        it 'should load an entity from YAML' do
            FileUtils.mkdir_p config['sboot_repo_path']
            File.write "#{config['sboot_repo_path']}/casa.yml", File.read("#{File.dirname __FILE__}/assets/casa.yml")
            
            entity = repo.load_entity 'casa'
            
            expect(entity.name).to eql('casa')
            expect(entity.name_pluralized).to eql('case')
            expect(entity.properties.detect {|p| p.name == 'casa_id'}.nil?).to be(false)
            expect(entity.properties.detect {|p| p.name == 'indirizzo'}.nil?).to be(false)
        end
    end
end
