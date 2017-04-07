require 'spec_helper'

describe Sboot::Property do

  subject(:property){ Sboot::Property.new name: 'dataNascita', type: 'Date', constraint: nil }

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
  end
end