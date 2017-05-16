require 'spec_helper'

describe Sboot::SourceWriter do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String',constraint: 'pk'), Sboot::Property.new(name: 'dataInizio',type: 'Date',constraint: nil)], environment: 'fullstack' }
  subject(:code_writer){ writer = Sboot::CodeWriter.new package: 'it.insiel.gcs.progetto', entity: domain_entity }

  describe 'initialization' do

    it 'should be correctly initialized by a writer' do
      expect(code_writer.respond_to? 'write_file').to be true
    end

  end

  
end
