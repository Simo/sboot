require 'spec_helper'
require 'fileutils'

xdescribe Sboot::Writer do

  subject(:writer){ Sboot::Writer.new package: 'it.insiel.siagri.nitrati', name: 'Casa', properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}] }

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
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/entities/#{writer.name.capitalize}.java").to be(true)
    end

    it 'write repository' do
      writer.write_repository 'repository'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
    end

    it "write exception EntityNotFound" do
      writer.write_exception 'exception'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/exceptions/EntityNotFoundException.java").to be(true)
    end

    it 'write dto' do
      writer.write_dto 'dto'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/dtos/#{writer.name.capitalize}DTO.java").to be(true)
    end

    it "write dto_rest" do
      writer.write "business/dtos",'dto_rest','DTO'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/dtos/#{writer.name.capitalize}DTO.java").to be(true)
    end

    it 'write service interface' do
      writer.write_service 'service'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/services/#{writer.name.capitalize}Service.java").to be(true)
    end

    it 'write service implementation' do
      writer.write_service_impl 'serviceimpl'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/services/impl/#{writer.name.capitalize}ServiceImpl.java").to be(true)
    end

    it 'write controller' do
      writer.write_controller 'controller'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/web/controllers/#{writer.name.capitalize}Controller.java").to be(true)
    end

    it 'write controller_rest' do
      writer.write_controller_rest 'controller_rest'
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/web/controllers/api/#{writer.name.capitalize}Controller.java").to be(true)
    end

    it "write messagedto" do
      writer.write_messagedto "message"
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/dtos/MessageDTO.java").to be(true)
    end

    it "write layout.html" do
      writer.write_layout 'layout'
      expect(File.exists? "#{writer.basic_path}/webapp/WEB-INF/views/layout/layout.html").to be(true)
    end

    it 'write index.html' do
      writer.write_html 'list'
      expect(File.exists? "#{writer.basic_path}/webapp/WEB-INF/views/#{writer.name.downcase}/index.html").to be(true)
    end

    it "write show.html" do
      writer.write_show 'show'
      expect(File.exists? "#{writer.basic_path}/webapp/WEB-INF/views/#{writer.name.downcase}/dettaglio.html").to be(true)
    end

    it "write swaggerconfig" do
      writer.write_swaggerconfig
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/configurations/SwaggerConfig.java").to be(true)
    end

    it "write controller test" do
      writer.write_controller_test 'controller_test'
      expect(File.exists? "#{writer.test_basic_path}/#{writer.package_to_path}/web/controllers/#{writer.name.capitalize}ControllerTest.java").to be(true)
    end

    after(:all) { Dir.glob(['it','webapp']).each { |f| FileUtils.rm_rf f } }
  end

  describe 'enviromental callings' do

    it 'call persistence' do
      writer.persistence
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
    end

    it 'call conversion' do
      writer.conversion
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
    end

    it 'call business' do
      writer.business
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/services/#{writer.name.capitalize}Service.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/services/impl/#{writer.name.capitalize}ServiceImpl.java").to be(true)
    end

    it 'call backend' do
      writer.backend
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/entities/#{writer.name.capitalize}.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/persistence/repositories/#{writer.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/dtos/#{writer.name.capitalize}Dto.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/services/#{writer.name.capitalize}Service.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/business/services/impl/#{writer.name.capitalize}ServiceImpl.java").to be(true)
      expect(File.exists? "#{writer.basic_path}/#{writer.package_to_path}/web/controllers/#{writer.name.capitalize}Controller.java").to be(true)
    end

    after(:each) { Dir.glob(['it','webapp']).each { |f| FileUtils.rm_rf f } }

  end

end
