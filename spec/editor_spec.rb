require 'spec_helper'

describe Sboot::Editor do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String', constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'fullstack' }
  subject(:editor){ Sboot::Editor.new domain_entity, "#{File.dirname __FILE__}/assets/.sbootconf" }


  describe 'initialization' do

    it "should be correctly initialized" do
      expect(editor).to be_an_instance_of Sboot::Editor
      expect(editor.domain_entity).to be_an_instance_of DomainEntity
      expect(editor.domain_entity.name).to eql'Casa'
      expect(editor.domain_entity.name_pluralized).to eql'Case'
      expect(editor.domain_entity.properties.length).to eql 2
      expect(editor.domain_entity.environment).to eql "fullstack"
      expect(editor.config).to be_an_instance_of Sboot::Config
      expect(editor.config['package']).to eql 'it.insiel.gcs.progetto'
      expect(editor.code_writer).to be_an_instance_of Sboot::CodeWriter
      expect(editor.code_writer.package).to eql 'it.insiel.gcs.progetto'
      expect(editor.html_writer).to be_an_instance_of Sboot::HtmlWriter
      expect(editor.test_writer).to be_an_instance_of Sboot::TestWriter
    end

  end

  xdescribe 'should publish the stack' do

    it 'should publish fullstack' do
      editor.publish
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/entities/Casa.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/repositories/CasaRepository.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/dtos/CasaDTO.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/exceptions/CasaEntityNotFoundException.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/CasaService.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/impl/CasaServiceImpl.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/controllers/CasaController.java").to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/layouts/layout.html').to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/index.html').to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/show.html').to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/new.html').to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/edit.html').to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/form.html').to be(true)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/business/services/CasaServiceTest.java").to be(true)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/web/controllers/CasaControllerTestIT.java").to be(true)
    end

    it 'should publish api stack' do
      domain_entity_api = DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String', constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'api'
      editor = Sboot::Editor.new domain_entity_api, "#{File.dirname __FILE__}/assets/.sbootconf"
      editor.publish
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/entities/Casa.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/repositories/CasaRepository.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/dtos/CasaDTO.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/exceptions/CasaEntityNotFoundException.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/CasaService.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/impl/CasaServiceImpl.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/utilities/MessageDTO.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/controllers/api/CasaController.java").to be(true)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/business/services/CasaServiceTest.java").to be(true)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/web/controllers/api/CasaControllerTestIT.java").to be(true)
    end

    it 'should publish backend' do
      domain_entity_backend = DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String', constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'backend'
      editor = Sboot::Editor.new domain_entity_backend, "#{File.dirname __FILE__}/assets/.sbootconf"
      editor.publish
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/entities/Casa.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/repositories/CasaRepository.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/dtos/CasaDTO.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/exceptions/CasaEntityNotFoundException.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/CasaService.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/impl/CasaServiceImpl.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/controllers/CasaController.java").to be(true)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/layouts/layout.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/index.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/show.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/new.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/edit.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/form.html').to be(false)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/business/services/CasaServiceTest.java").to be(true)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/web/controllers/CasaControllerTestIT.java").to be(true)
    end

    it 'should publish business' do
      domain_entity_business = DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String', constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'business'
      editor = Sboot::Editor.new domain_entity_business, "#{File.dirname __FILE__}/assets/.sbootconf"
      editor.publish
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/entities/Casa.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/repositories/CasaRepository.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/dtos/CasaDTO.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/exceptions/CasaEntityNotFoundException.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/CasaService.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/impl/CasaServiceImpl.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/controllers/CasaController.java").to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/layouts/layout.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/index.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/show.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/new.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/edit.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/form.html').to be(false)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/business/services/CasaServiceTest.java").to be(true)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/web/controllers/CasaControllerTestIT.java").to be(false)
    end

    it 'should publish conversion' do
      domain_entity_conversion = DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String', constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'conversion'
      editor = Sboot::Editor.new domain_entity_conversion, "#{File.dirname __FILE__}/assets/.sbootconf"
      editor.publish
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/entities/Casa.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/repositories/CasaRepository.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/dtos/CasaDTO.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/exceptions/CasaEntityNotFoundException.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/CasaService.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/impl/CasaServiceImpl.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/controllers/CasaController.java").to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/layouts/layout.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/index.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/show.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/new.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/edit.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/form.html').to be(false)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/business/services/CasaServiceTest.java").to be(false)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/web/controllers/CasaControllerTestIT.java").to be(false)
    end

    it 'should publish persistence' do
      domain_entity_persistence = DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String', constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'persistence'
      editor = Sboot::Editor.new domain_entity_persistence, "#{File.dirname __FILE__}/assets/.sbootconf"
      editor.publish
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/entities/Casa.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/persistence/repositories/CasaRepository.java").to be(true)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/dtos/CasaDTO.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/exceptions/CasaEntityNotFoundException.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/CasaService.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/business/services/impl/CasaServiceImpl.java").to be(false)
      expect(File.exists? "src/main/java/it/insiel/gcs/progetto/web/controllers/CasaController.java").to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/layouts/layout.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/index.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/show.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/new.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/edit.html').to be(false)
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/form.html').to be(false)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/business/services/CasaServiceTest.java").to be(false)
      expect(File.exists? "src/test/java/it/insiel/gcs/progetto/web/controllers/CasaControllerTestIT.java").to be(false)
    end

    after(:each) { Dir.glob(['src']).each { |f| FileUtils.rm_rf f } }

  end

end
