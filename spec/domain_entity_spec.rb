require 'spec_helper'

describe DomainEntity do

  subject(:entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}], environment: 'fullstack' }

  describe 'initialize' do

    it "should be correctly initialized" do
      expect(entity).to be_an_instance_of DomainEntity
    end

    it "should have name equals to Casa" do
      expect(entity.name).to eql 'Casa'
    end

  end

  describe 'behavior' do

    it "should return collection name equals to Case" do
      expect(entity.collection).to eql 'Case'
    end

    it "should return collection name equals to Casa if name_pluralized is nil" do
      new_entity = DomainEntity.new name: 'Casa', name_pluralized: nil, properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}], environment: 'fullstack'
      expect(new_entity.collection).to eql 'Casa'
    end

    it "should return true (name_pluralized defined)" do
      expect(entity.collection_defined?).to be(true)
    end

    it "should return false (name_pluralized equals name) " do
      new_entity = DomainEntity.new name: 'Casa', name_pluralized: 'Casa', properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}], environment: 'fullstack'
      expect(new_entity.collection_defined?).to be(false)
    end

    it "should return false (name_pluralized not defined) " do
      new_entity = DomainEntity.new name: 'Casa', name_pluralized: nil, properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}], environment: 'fullstack'
      expect(new_entity.collection_defined?).to be(false)
    end
  end
end