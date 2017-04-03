require 'spec_helper'

describe Sboot::Stack do

  subject(:config){ Sboot::Config.new "#{File.dirname __FILE__}/assets/.sbootconf" }
  subject(:stack){ Sboot::Stack.new config: config }

  describe 'initialize' do

    it 'should be correctly initialized' do
      expect(stack).to be_an_instance_of Sboot::Stack
    end

  end

  describe 'behavior' do

    it 'should return the stacks hash' do
      expect(stack.define_stacks('fullstack')).to be_an Hash
    end

    it 'should contain an array of filetypes' do
      expect(stack.define_stacks('fullstack')[:code][:files]).to be_an Array
    end

    it 'array for fullstack should have length fixed' do
      expect(stack.define_stacks('fullstack')[:code][:files].length).to be 7
    end

    it 'code fullstack files each should be instances of FileType' do
      expect(stack.define_stacks('fullstack')[:code][:files][0]).to be_an_instance_of FileType
    end

    it 'code fullstack files each should have reference and extension' do
      expect(stack.define_stacks('fullstack')[:code][:files][0].ref).to eql 'persistence/entities'
      expect(stack.define_stacks('fullstack')[:code][:files][0].ext).to eql ''
    end
  end

  describe 'helper methods' do

    it 'should return an empty array' do
      expect(stack.send('create_filetype_array','')).to eql []
    end

    it 'should return an array' do
      expect(stack.send('create_filetype_array','fullstack')).to be_an Array
    end

    it 'should return an 7 elements array for fullstack' do
      expect(stack.send('create_filetype_array','fullstack').length).to be 7
    end

    it 'should return an array of FileType' do
      stack.send('create_filetype_array','fullstack').each do |filetype|
        expect(filetype).to be_an_instance_of FileType
      end
    end

    it 'should each file be correctly populated' do
      file = stack.send('create_filetype_array','fullstack')[1]
      expect(file.key).to be (:repository)
      expect(file.reference).to eql ('persistence/repositories')
      expect(file.extension).to eql ('Repository')
    end

    it 'should say html is needed' do
      expect(stack.send('html_needed?', 'fullstack')).to be true
    end

    it 'should say html is not needed' do
      expect(stack.send('html_needed?', 'api')).to be false
    end

    it 'should say tests are needed' do
      expect(stack.send('test_needed?', 'fullstack')).to be true
      expect(stack.send('test_needed?', 'backend')).to be true
      expect(stack.send('test_needed?', 'api')).to be true
      expect(stack.send('test_needed?', 'business')).to be true
    end

    it 'should say test are not needed' do
      expect(stack.send('test_needed?', 'persistence')).to be false
      expect(stack.send('test_needed?', 'conversion')).to be false
    end

    it 'should determine test level' do
      expect(stack.send('determine_test_level','fullstack')).to be :fulltest
      expect(stack.send('determine_test_level','backend')).to be :fulltest
      expect(stack.send('determine_test_level','business')).to be :servicetest
      expect(stack.send('determine_test_level','api')).to be :apitest
    end

  end
end