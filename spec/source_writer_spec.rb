require 'spec_helper'

describe Sboot::SourceWriter do

    subject(:writer) { writer = Sboot::SourceWriter.new sboot_repo_path: '.sboot-repo'}

  describe 'initialize' do

    it 'should be correctly initialize' do
      expect(writer).to be_an_instance_of Sboot::SourceWriter
    end
  end
    
  describe 'writing files' do
    it 'write new file' do
        file_contents = File.read("#{File.dirname __FILE__}/assets/source_v1.java")
        
        writer.write_file 'src/WriterTest.java', file_contents
        # Il file deve essere stato salvato senza modifiche
        expect(File.read 'src/WriterTest.java').to eql(file_contents)
        # Il file deve essere stato salvato anche nel repository
        expect(File.read '.sboot-repo/src/WriterTest.java').to eql(file_contents)
    end
    
    it 'patch existing file' do
        # Creo il file nel repository
        FileUtils.mkdir_p '.sboot-repo/src'
        File.write '.sboot-repo/src/WriterTest.java', File.read("#{File.dirname __FILE__}/assets/source_v1.java")

        # Creo il file sorgente pre-modifica (sorgente modificato)       
        FileUtils.mkdir_p 'src'
        File.write 'src/WriterTest.java', File.read("#{File.dirname __FILE__}/assets/source_edited.java")
        
        # Salvo il nuovo file
        file_v2 = File.read("#{File.dirname __FILE__}/assets/source_v2.java")
        writer.write_file 'src/WriterTest.java', file_v2
        
        # Il file nel repository deve essere stato aggiornato
        expect(File.read '.sboot-repo/src/WriterTest.java').to eq(file_v2)

        # Verifico che le modifiche non siano andate perse
        expect(File.read 'src/WriterTest.java').to eq(File.read("#{File.dirname __FILE__}/assets/source_patched.java"))
    end
    
    after(:each) { Dir.glob(['src','.sboot-repo']).each { |f| FileUtils.rm_rf f } }
  end

end
