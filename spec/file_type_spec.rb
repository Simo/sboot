require 'spec_helper'

describe FileType do

  subject(:file_type){ FileType.new(key: :repository, reference: 'repository', extension: 'Repository')}

  describe 'initialization' do

    it "should correctly initialize" do
      expect(file_type).to be_an_instance_of FileType
    end

    it "should have key equals to repository" do
      expect(file_type.key).to be :repository
    end

    it "should have reference equals to repository" do
      expect(file_type.reference).to eql 'repository'
    end

    it "should have extension equals to Repository" do
      expect(file_type.extension).to eql 'Repository'
    end

  end

  describe 'helper methods' do

    it "should return reference, sended ref" do
      expect(file_type.ref).to eql 'repository'
    end

    it "should return extension, sended ext" do
      expect(file_type.extension).to eql 'Repository'
    end

  end
end