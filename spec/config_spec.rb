require 'spec_helper'

describe Sboot::Config do

  subject(:config){ Sboot::Config.new "#{File.dirname __FILE__}/assets/.sbootconf" }

  describe 'initialization' do

    it "should be correctly initialized" do
      expect(config['main_path']).to eql('src/main/java')
    end

  end
end
