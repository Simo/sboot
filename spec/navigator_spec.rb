require 'spec_helper'

describe Sboot::Navigator do

  subject(:navigator){ Sboot::Navigator.new }

  describe 'Instantiation' do

    it 'should be correctly instantiated' do
      expect(navigator).instance_of? Sboot::Navigator
    end

  end

  describe 'behavior' do

    before(:each) { Dir.chdir File.dirname __FILE__ }

    it 'should not change the execution folder' do
      navigator.starting_pos = Dir.pwd
      here = Dir.pwd
      navigator.nav_to_root_folder(Dir.pwd)
      expect(Dir.pwd).to eql here
      Dir.chdir navigator.starting_pos
      puts Dir.pwd
    end

    it 'should change the execution folder' do
      Dir.chdir 'assets'
      root_folder = Dir.pwd
      Dir.chdir 'empty'
      navigator.nav_to_root_folder(Dir.pwd)
      expect(Dir.pwd).to eql root_folder
    end

    it 'should set original path back to command line' do
      Dir.chdir 'assets'
      root_folder = Dir.pwd
      Dir.chdir 'empty'
      origin = Dir.pwd
      navigator.nav_to_root_folder Dir.pwd
      expect(Dir.pwd).to eql root_folder
      navigator.set_original_path_back
      expect(Dir.pwd).to eql origin
    end

    it 'should raise an exception if doesnt find any .sbootconf' do
      Dir.chdir('../../../')
      puts Dir.pwd
      expect {navigator.nav_to_root_folder Dir.pwd}.to raise_error ArgumentError
    end

    it 'should give a specific message as error raised' do
      Dir.chdir('../../../')
      puts Dir.pwd
      expect {navigator.nav_to_root_folder Dir.pwd}.to raise_error 
 'Naviga all\'interno di un progetto per utilizzare i comandi di sboot'
    end
  end

end
