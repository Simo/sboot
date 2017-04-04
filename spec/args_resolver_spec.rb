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
      expect(resolver.resolve(%w{ name })[0][:name]).to eql 'name'
      expect(resolver.resolve(%w{ name })[0][:type]).to eql 'String'
      expect(resolver.resolve(%w{ name })[0][:constraint]).to be nil
    end

    it 'should resolve arg with two values' do
      expect(resolver.resolve(%w{ civico:number })[0][:name]).to eql 'civico'
      expect(resolver.resolve(%w{ civico:number })[0][:type]).to eql 'Long'
      expect(resolver.resolve(%w{ civico:number })[0][:constraint]).to be nil
    end

    it 'should resolve arg with two values' do
      expect(resolver.resolve(%w{ id:pk })[0][:name]).to eql 'id'
      expect(resolver.resolve(%w{ id:pk })[0][:type]).to eql 'Long'
      expect(resolver.resolve(%w{ id:pk })[0][:constraint]).to eql 'pk'
    end

    it 'should resolve arg with three values' do
      expect(resolver.resolve(%w{idiom:string:pk})[0][:name]).to eql 'idiom'
      expect(resolver.resolve(%w{idiom:number:pk})[0][:type]).to eql 'Long'
      expect(resolver.resolve(%w{idiom:string:pk})[0][:constraint]).to eql 'pk'
    end

    it 'should resolve arg with mixed values' do
      expect(resolver.resolve(%w{name civico:number idiom:number:pk}).length).to be 3
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[0][:name]).to eql 'name'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[0][:name]).to eql 'name'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[0][:type]).to eql 'String'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[0][:constraint]).to be nil
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[1][:name]).to eql 'civico'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[1][:type]).to eql 'Long'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[1][:constraint]).to be nil
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[2][:name]).to eql 'idiom'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[2][:type]).to eql 'Long'
      expect(resolver.resolve(%w{name civico:number idiom:number:pk})[2][:constraint]).to eql 'pk'
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

  end


end
