require 'spec_helper'

describe Sboot::NgWriter do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String',constraint: 'pk'), Sboot::Property.new(name: 'dataInizio',type: 'Date',constraint: nil)], environment: 'fullstack' }

  subject(:writer){ Sboot::NgWriter.new entity: domain_entity}

  describe 'initialization' do

    it 'should be correctly initialized' do
      expect(writer).to be_an_instance_of Sboot::NgWriter
    end

  end

  describe 'inclusion of helper modules' do
    #str = "\nconst routes: Routes = [\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'},\n  { path: #{entity.collection_downcase}, component: #{entity.collection_downcase}ElencoComponent},\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key}', component: #{entity.single_downcase}DettaglioComponent }\n];\n\n@NgModule"
    it 'should expose helper methods' do
      expect(writer.respond_to?('insert_new_route_object')).to be true
    end
  end

end
