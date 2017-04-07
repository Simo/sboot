require 'spec_helper'

describe Sboot::HtmlHelper do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String',constraint: 'pk'),Sboot::Property.new(name: 'civico',type: 'Long', constraint: nil)], environment: 'fullstack' }
  subject(:writer){ Sboot::HtmlWriter.new entity: domain_entity }

  describe 'initialize' do

    it 'should correctly initialized' do
      expect(writer.entity).to be_an_instance_of DomainEntity
    end

    it 'should have an array of properties' do
      expect(writer.entity.properties.length).to eql 2
    end

    it 'should have the first property set as primary key' do
      expect(writer.entity.properties[0]).to be_an_instance_of Sboot::Property
      expect(writer.entity.properties[0].name).to eql 'indirizzo'
    end

  end

  describe 'behavior' do

    it 'should print an input tag with hidden type' do
      expect(writer.hidden_field writer.entity.properties[0]).to eql '<input type="hidden" th:field="${casa.indirizzo}" />'
    end

    it 'should print a label for property' do
      expect(writer.label writer.entity.properties[1]).to eql '<label for="civico">Civico</label>'
    end

    it 'should pring an input tag with text type' do
      expect(writer.text_field writer.entity.properties[1]).to eql"<input type=\"text\" class=\"form-control\" th:field=\"${casa.civico}\" placeholder=\"Civico\"/>"
    end
  end
end