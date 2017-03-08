require 'spec_helper'
require 'sboot/cli'

describe Sboot::CLI do

  it 'has a version number' do
    expect(Sboot::VERSION).not_to be nil
  end
  
  describe 'user interaction' do

    it 'env to default' do
      subject.generate 'it.insiel.siagri.nitrati','Persona','nome eta:int'
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/Persona.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/PersonaRepository.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/dtos/PersonaDto.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/PersonaService.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/impl/PersonaServiceImpl.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/web/controllers/PersonaController.java").to be(true)
    end

    it 'env to backend' do
      subject.options = {:env => 'backend'}
      subject.generate 'it.insiel.siagri.nitrati','Persona','nome eta:int'
      expect(subject.options[:env]).to eql('backend')
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/entities/Persona.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/persistence/repositories/PersonaRepository.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/dtos/PersonaDto.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/PersonaService.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/business/services/impl/PersonaServiceImpl.java").to be(true)
      expect(File.exists? "lib/sboot/generated/it/insiel/siagri/nitrati/web/controllers/PersonaController.java").to be(true)
    end
    
    after(:each) { Dir.glob('lib/sboot/generated/*').each { |f| FileUtils.rm_rf f } }
  end
  
end
