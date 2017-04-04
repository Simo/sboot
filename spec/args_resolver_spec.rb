require 'spec_helper'

describe Sboot::ArgsResolver do

  subject(:resolver){ Sboot::ArgsResolver.new }

  describe 'initialization' do

    it 'should be correctly initialized' do
      expect(resolver).to be_an_instance_of Sboot::ArgsResolver
    end

  end

  describe 'resolving arguments' do

    it 'should resolve arg with one value' do
      array = resolver.resolve(%w{ name })
      expect(array[0][:name]).to eql 'id'
      expect(array[0][:type]).to eql 'Long'
      expect(array[0][:constraint]).to eql 'pk'
      expect(array[1][:name]).to eql 'name'
      expect(array[1][:type]).to eql 'String'
      expect(array[1][:constraint]).to be nil
    end

    it 'should resolve arg with two values' do
      array = resolver.resolve(%w{ civico:number })
      expect(array[0][:name]).to eql 'id'
      expect(array[0][:type]).to eql 'Long'
      expect(array[0][:constraint]).to eql 'pk'
      expect(array[1][:name]).to eql 'civico'
      expect(array[1][:type]).to eql 'Long'
      expect(array[1][:constraint]).to be nil
    end

    it 'should resolve arg with two values and one pk' do
      array = resolver.resolve(%w{ id:pk })
      expect(array.length).to eql 1
      expect(array[0][:name]).to eql 'id'
      expect(array[0][:type]).to eql 'Long'
      expect(array[0][:constraint]).to eql 'pk'
    end

    it 'should resolve arg with three values' do
      array = resolver.resolve(%w{idiom:number:pk})
      expect(array[0][:name]).to eql 'idiom'
      expect(array[0][:type]).to eql 'Long'
      expect(array[0][:constraint]).to eql 'pk'
    end

    it 'should resolve arg with mixed values' do
      array = resolver.resolve(%w{name civico:number idiom:number:pk})
      expect(array.length).to eql 3
      expect(array[0][:name]).to eql 'name'
      expect(array[0][:name]).to eql 'name'
      expect(array[0][:type]).to eql 'String'
      expect(array[0][:constraint]).to be nil
      expect(array[1][:name]).to eql 'civico'
      expect(array[1][:type]).to eql 'Long'
      expect(array[1][:constraint]).to be nil
      expect(array[2][:name]).to eql 'idiom'
      expect(array[2][:type]).to eql 'Long'
      expect(array[2][:constraint]).to eql 'pk'
    end

    it 'should resolve arg with mixed values without explicit pk'  do
      array = resolver.resolve(%w{name civico:number idiom:number})
      expect(array.length).to be 4
      expect(array[0][:name]).to eql 'id'
      expect(array[0][:type]).to eql 'Long'
      expect(array[0][:constraint]).to eql 'pk'
      expect(array[1][:name]).to eql 'name'
      expect(array[1][:type]).to eql 'String'
      expect(array[1][:constraint]).to be nil
      expect(array[2][:name]).to eql 'civico'
      expect(array[2][:type]).to eql 'Long'
      expect(array[2][:constraint]).to be nil
      expect(array[3][:name]).to eql 'idiom'
      expect(array[3][:type]).to eql 'Long'
      expect(array[3][:constraint]).to be nil
    end

  end

  describe 'helper methods' do

    it 'should detect type' do
      expect(resolver.send('detect_type','number'.to_sym)).to eql 'Long'
    end

    it 'should return string for any error' do
      expect(resolver.send('detect_type','nmbr'.to_sym)).to eql 'String'
    end

    it 'should say its a type' do
      expect(resolver.send('is_a_type?', 'string')).to be_truthy
    end

    it 'should say its not a type' do
      expect(resolver.send('is_a_type?', 'pk')).to be_falsey
    end

    it 'should say its a constraint' do
      expect(resolver.send('is_a_constraint?', 'pk')).to be_truthy
    end

    it 'should say its not a constraint' do
      expect(resolver.send('is_a_constraint?', 'string')).to be_falsey
    end

    it 'should set the variable @has_id' do
      resolver.send('is_a_constraint?', 'pk')
      expect(resolver.has_id).to be true
    end

    it 'should not set the variable @has_id' do
      resolver.send('is_a_constraint?', 'kp')
      expect(resolver.has_id).to be false
    end

  end


end
