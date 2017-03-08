require 'spec_helper'
require 'fileutils'

describe Sboot::Writer do

  subject(:writer){ Sboot::Writer.new package: 'it.insiel.siagri.nitrati', name: 'Persona', properties: [{name: 'name',type: 'String'},{name: 'age',type: 'Long'}] }

  describe 'initialization' do

    it 'initialize works' do
      expect(writer).to be_an_instance_of Sboot::Writer
    end

    it ':package is initialize correctly' do
      expect(writer.package).to eql('it.insiel.siagri.nitrati')
    end
  end

  describe 'raising errors' do

    it 'missing :package' do
      expect { Sboot::Writer.new name: 'Persona', properties: %w{ 'name' 'age:int' }}.to raise_error ':package non presente'
    end

    it 'missing :name' do
      expect { Sboot::Writer.new package: 'it.insiel.siagri.nitrati', properties: %w{ 'name' 'age:int' }}.to raise_error ':name non presente'
    end

    it 'missing :properties' do
      expect { Sboot::Writer.new package: 'it.insiel.siagri.nitrati', name: 'Persona'}.to raise_error ':properties non presente'
    end
  end
  
  describe 'utilities' do
    it 'package to path' do
      expect(writer.package_to_path).to eql('it/insiel/siagri/nitrati')
    end
  end

  describe 'writing files' do

    it 'write entity' do
      writer.write_entity 'entity'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/#{writer.name.capitalize}.java").to be(true)
    end
    
    it 'write repository' do
      writer.write_repository 'repository'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
    end
    
    it 'write dto' do
      writer.write_dto 'dto'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
    end
    
    it 'write service interface' do
      writer.write_service 'service'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/#{writer.name.capitalize}Service.java").to be(true)
    end
    
    it 'write service implementation' do
      writer.write_service_impl 'serviceimpl'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/impl/#{writer.name.capitalize}ServiceImpl.java").to be(true)
    end
    
    it 'write controller' do
      writer.write_controller 'controller'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/web/controllers/#{writer.name.capitalize}Controller.java").to be(true)
    end
    
    it 'write index.html' do
      writer.write_html 'list'
      expect(File.exists? "lib/sboot/generated/webapp/WEB-INF/views/#{writer.name.downcase}/index.html").to be(true)
    end
    
    after(:all) { Dir.glob('lib/sboot/generated/*').each { |f| FileUtils.rm_rf f } }
  end
  
  describe 'enviromental callings' do
    
    it 'call persistence' do
      writer.persistence
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
    end
    
    it 'call conversion' do
      writer.conversion
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
    end
    
    it 'call business' do
      writer.business
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/#{writer.name.capitalize}Service.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/impl/#{writer.name.capitalize}ServiceImpl.java").to be(true)
    end
    
    it 'call backend' do
      writer.backend
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/#{writer.name.capitalize}Service.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/impl/#{writer.name.capitalize}ServiceImpl.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/web/controllers/#{writer.name.capitalize}Controller.java").to be(true)
    end
    
    after(:each) { Dir.glob('lib/sboot/generated/*').each { |f| FileUtils.rm_rf f } }
    
  end
  
end
