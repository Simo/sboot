require 'spec_helper'

describe Sboot::NgWriter do

  describe 'inclusion of helper modules' do

    it 'should expose helper methods' do
      expect(subject.instance_method(:write_dependencies)).to be_an_instance_of UnboundMethod
    end

  end

end
