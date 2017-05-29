require 'spec_helper'

describe Sboot::Property do

  subject(:property){ Sboot::Property.new name: 'dataNascita', type: 'Date', constraint: nil }
  subject(:property2){ Sboot::Property.new name: 'nome_composto', type: 'String', constraint: nil }

  describe 'intialization' do

    it 'should be correctly initialized' do
      expect(property).to be_an_instance_of Sboot::Property
    end

  end

  describe 'behavior' do

    it 'should mantain an hash-like behavior to retrocompatibility' do
      expect(property[:name]).to eql 'dataNascita'
    end

    it 'should return String for a Date type' do
      expect(property.dto_type).to eql 'String'
    end

    it 'should return true for peculiar type' do
      expect(property.peculiar_type?).to be_truthy
    end

    it 'should return false for non peculiar type' do
      property = Sboot::Property.new name: 'dataNascita', type: 'String', constraint: nil
      expect(property.peculiar_type?).to be_falsey
    end

    it 'should return true for a uuid pk' do
      property = Sboot::Property.new name: 'id', type: 'UUID', constraint: 'pk'
      expect(property.is_uuid?).to be_truthy
    end

    it 'should return true for a non-uuid pk' do
      property = Sboot::Property.new name: 'id', type: 'Long', constraint: 'pk'
      expect(property.is_uuid?).to be_falsey
    end

  end

  describe 'helper methods for erbs' do

    it 'camelize first letter upcase' do
      expect(property2.camel_rather_dash(firstLetter: 'upcase')).to eql 'NomeComposto'
    end

    it 'camelize first letter downcase' do
      expect(property2.camel_rather_dash firstLetter: 'downcase').to eql 'nomeComposto'
    end

    it 'camelize first letter downcase automatically' do
      expect(property2.camel_rather_dash).to eql 'nomeComposto'
    end

    xit 'raise an error for bad argument' do
      expect(property2.camel_rather_dash firstLetter: 'non_so').to raise_error ArgumentError
    end
  end
end
