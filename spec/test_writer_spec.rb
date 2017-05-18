require 'spec_helper'

describe Sboot::TestWriter do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [{name: 'indirizzo',type: 'String',constraint: 'pk'},{name: 'civico',type: 'Long', constraint: nil}], environment: 'fullstack' }
  subject(:writer){ writer = Sboot::TestWriter.new package: 'it.insiel.gcs.progetto', entity: domain_entity, sboot_repo_path: '.sboot-repo' }

  subject(:ft){{files: [FileType.new(key: :service_test, reference: 'business/services', extension: 'ServiceTest'),
                        FileType.new(key: :controller_test, reference: 'web/controllers', extension: 'ControllerTestIT')], path: 'src/test/java', active: true}}
  subject(:at){{files: [FileType.new(key: :service_test, reference: 'business/services', extension: 'ServiceTest'),
                        FileType.new(key: :controller_rest_test, reference: 'web/controllers/api', extension: 'ControllerTestIT')], path: 'src/test/java', active: true}}
  subject(:st){{files: [FileType.new(key: :service_test, reference: 'business/services', extension: 'ServiceTest')], path: 'src/test/java', active: true}}

  describe 'initialize' do

    it 'should be correctly initialize' do
      expect(writer).to be_an_instance_of Sboot::TestWriter
    end
  end

  describe 'writing files' do

    it 'write service test' do
      stack = {files: [FileType.new(key: :service_test, reference: 'business/services', extension: 'ServiceTest')], path: 'src/test/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}ServiceTest.java").to be(true)
    end

    it 'write controller test' do
      stack = {files: [FileType.new(key: :controller_test, reference: 'web/controllers', extension: 'ControllerTestIT')], path: 'src/test/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/web/controllers/#{writer.entity.name.capitalize}ControllerTestIT.java").to be(true)
    end

    it 'write controller_rest test' do
      stack = {files: [FileType.new(key: :controller_rest_test, reference: 'web/controllers/api', extension: 'ControllerTestIT')], path: 'src/test/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/web/controllers/api/#{writer.entity.name.capitalize}ControllerTestIT.java").to be(true)
    end

    after(:each) { Dir.glob(['src','.sboot-repo']).each { |f| FileUtils.rm_rf f } }

  end

  describe 'writing complete stack' do

    it 'should write the fulltest stack' do
      writer.write ft
      expect(File.exists? "#{ft[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}ServiceTest.java").to be(true)
      expect(File.exists? "#{ft[:path]}/#{writer.send('package_to_path')}/web/controllers/#{writer.entity.name.capitalize}ControllerTestIT.java").to be(true)
    end

    it 'should write the service test stack' do
      writer.write st
      expect(File.exists? "#{st[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}ServiceTest.java").to be(true)
    end

    it 'should write the api test stack' do
      writer.write at
      expect(File.exists? "#{at[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}ServiceTest.java").to be(true)
      expect(File.exists? "#{at[:path]}/#{writer.send('package_to_path')}/web/controllers/api/#{writer.entity.name.capitalize}ControllerTestIT.java").to be(true)
    end

    after(:each) { Dir.glob(['src','.sboot-repo']).each { |f| FileUtils.rm_rf f } }

  end

end
