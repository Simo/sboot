require 'spec_helper'
require 'sboot/cli'

describe Sboot::CLI do

  it 'has a version number' do
    expect(Sboot::VERSION).not_to be nil
  end

  describe 'user interaction' do

    it 'should write a .sbootconf' do
      subject.init 'it.insiel.gcs.progetto'
      expect(File.exists? ".sbootconf").to be(true)
    end

    it 'should publish fullstack' do
      subject.generate 'casa:case', 'indirizzo civico:number'
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

    #after(:all) { Dir.glob(['src', '.sbootconf']).each { |f| FileUtils.rm_rf f } }
  end

  describe 'helper methods' do

    it 'should generate an hash with domain_names' do
      expect(subject.send('domain_names','casa:case')).to be_an_instance_of Hash
    end

    it 'should generate both keys casa:case' do
      expect(subject.send('domain_names','casa:case')[:name]).to eql 'casa'
      expect(subject.send('domain_names','casa:case')[:pluralize]).to eql 'case'
    end

    it 'should generate only the name key with casa' do
      expect(subject.send('domain_names','casa')[:name]).to eql 'casa'
      expect(subject.send('domain_names','casa')[:pluralize]).to be nil
    end
  end

end
