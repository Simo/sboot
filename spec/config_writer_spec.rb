require 'spec_helper'

describe Sboot::ConfigWriter do

  subject(:config_writer){ Sboot::ConfigWriter.new package: 'it.insiel.gcs.progetto' }

  describe 'initialization' do

    it 'initialization works' do
      expect(config_writer).to be_an_instance_of Sboot::ConfigWriter
    end

    describe 'raising errors' do

      it 'missing :package' do
        expect { Sboot::ConfigWriter.new }.to raise_error ':package non presente'
      end

    end

  end

  describe 'writing config file' do

    it "write the configuration file in the same folder" do
      config_writer.write
      expect(File.exists? '.sbootconf').to be(true)
    end

    #after(:each) { Dir.glob(['.sbootconf']).each { |f| FileUtils.rm f } }

  end

end
