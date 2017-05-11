require 'spec_helper'

describe Sboot::CodeWriter do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [Sboot::Property.new(name: 'indirizzo',type: 'String',constraint: 'pk'), Sboot::Property.new(name: 'dataInizio',type: 'Date',constraint: nil)], environment: 'fullstack' }
  subject(:writer){ writer = Sboot::CodeWriter.new package: 'it.insiel.gcs.progetto', entity: domain_entity }
  subject(:ps){{files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                        FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository')], path: 'src/main/java', active: true}}
  subject(:cs){{files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                        FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository'),
                        FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO')], path: 'src/main/java', active: true}}
  subject(:bs){{files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                        FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository'),
                        FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO'),
                        FileType.new(key: :exception, reference: 'business/exceptions', extension: 'EntityNotFoundException'),
                        FileType.new(key: :service, reference: 'business/services', extension: 'Service'),
                        FileType.new(key: :service_impl, reference: 'business/services/impl', extension: 'ServiceImpl')], path: 'src/main/java', active: true}}
  subject(:bes){{files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                        FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository'),
                        FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO'),
                        FileType.new(key: :exception, reference: 'business/exceptions', extension: 'EntityNotFoundException'),
                        FileType.new(key: :service, reference: 'business/services', extension: 'Service'),
                        FileType.new(key: :service_impl, reference: 'business/services/impl', extension: 'ServiceImpl'),
                        FileType.new(key: :controller, reference: 'web/controller', extension: 'Controller')], path: 'src/main/java', active: true}}
  subject(:fs){{files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                        FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository'),
                        FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO'),
                        FileType.new(key: :exception, reference: 'business/exceptions', extension: 'EntityNotFoundException'),
                        FileType.new(key: :service, reference: 'business/services', extension: 'Service'),
                        FileType.new(key: :service_impl, reference: 'business/services/impl', extension: 'ServiceImpl'),
                        FileType.new(key: :controller, reference: 'web/controller', extension: 'Controller')], path: 'src/main/java', active: true}}
  subject(:api){{files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                        FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository'),
                        FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO'),
                        FileType.new(key: :exception, reference: 'business/exceptions', extension: 'EntityNotFoundException'),
                        FileType.new(key: :service, reference: 'business/services', extension: 'Service'),
                        FileType.new(key: :service_impl, reference: 'business/services/impl', extension: 'ServiceImpl'),
                        FileType.new(key: :messagedto, reference: 'web/utilities', extension: 'MessageDTO'),
                        FileType.new(key: :controller, reference: 'web/controller/api', extension: 'Controller')], path: 'src/main/java', active: true}}

  describe 'initialize' do

    it 'should be correctly initialize' do
      expect(writer).to be_an_instance_of Sboot::CodeWriter
    end
  end

  describe 'writing files' do

    it 'write entity' do
      stack = {files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: '')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
    end

    it 'write repository' do
      stack = {files: [FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
    end

    it 'write dto' do
      stack = {files: [FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
    end

    it 'write exception' do
      stack = {files: [FileType.new(key: :exception, reference: 'business/exceptions', extension: 'EntityNotFoundException')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/business/exceptions/#{writer.entity.name.capitalize}EntityNotFoundException.java").to be(true)
    end

    it 'write service' do
      stack = {files: [FileType.new(key: :service, reference: 'business/services', extension: 'Service')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}Service.java").to be(true)
    end

    it 'write service_impl' do
      stack = {files: [FileType.new(key: :service_impl, reference: 'business/services/impl', extension: 'ServiceImpl')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/business/services/impl/#{writer.entity.name.capitalize}ServiceImpl.java").to be(true)
    end

    it 'write controller' do
      stack = {files: [FileType.new(key: :controller, reference: 'web/controller', extension: 'Controller')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/web/controller/#{writer.entity.name.capitalize}Controller.java").to be(true)
    end

    it 'write dto_rest' do
      stack = {files: [FileType.new(key: :dto_rest, reference: 'business/dtos', extension: 'DTO')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
    end

    it 'write messagedto' do
      stack = {files: [FileType.new(key: :messagedto, reference: 'web/utilities', extension: 'MessageDTO')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/web/utilities/MessageDTO.java").to be(true)
    end

    it 'write controller_rest' do
      stack = {files: [FileType.new(key: :controller_rest, reference: 'web/controller/api', extension: 'Controller')], path: 'src/main/java'}
      writer.write stack
      expect(File.exists? "#{stack[:path]}/#{writer.send('package_to_path')}/web/controller/api/#{writer.entity.name.capitalize}Controller.java").to be(true)
    end

    after(:each) { Dir.glob(['src']).each { |f| FileUtils.rm_rf f } }

  end

  describe 'writing complete stack' do

    it 'should write the persistence stack' do
      writer.write ps
      expect(File.exists? "#{ps[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
      expect(File.exists? "#{ps[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
    end

    it 'should write the convertion stack' do
      writer.write cs
      expect(File.exists? "#{cs[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
      expect(File.exists? "#{cs[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{cs[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
    end

    it 'should write the business stack' do
      writer.write bs
      expect(File.exists? "#{bs[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
      expect(File.exists? "#{bs[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{bs[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
      expect(File.exists? "#{bs[:path]}/#{writer.send('package_to_path')}/business/exceptions/#{writer.entity.name.capitalize}EntityNotFoundException.java").to be(true)
      expect(File.exists? "#{bs[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}Service.java").to be(true)
      expect(File.exists? "#{bs[:path]}/#{writer.send('package_to_path')}/business/services/impl/#{writer.entity.name.capitalize}ServiceImpl.java").to be(true)
    end

    it 'should write the backend stack' do
      writer.write bes
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/business/exceptions/#{writer.entity.name.capitalize}EntityNotFoundException.java").to be(true)
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}Service.java").to be(true)
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/business/services/impl/#{writer.entity.name.capitalize}ServiceImpl.java").to be(true)
      expect(File.exists? "#{bes[:path]}/#{writer.send('package_to_path')}/web/controller/#{writer.entity.name.capitalize}Controller.java").to be(true)
    end

    it 'should write the fullstack' do
      writer.write fs
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/exceptions/#{writer.entity.name.capitalize}EntityNotFoundException.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}Service.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/services/impl/#{writer.entity.name.capitalize}ServiceImpl.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/web/controller/#{writer.entity.name.capitalize}Controller.java").to be(true)
    end

    it 'should write the api stack' do
      writer.write api
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/persistence/entities/#{writer.entity.name.capitalize}.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/persistence/repositories/#{writer.entity.name.capitalize}Repository.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/dtos/#{writer.entity.name.capitalize}DTO.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/exceptions/#{writer.entity.name.capitalize}EntityNotFoundException.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/services/#{writer.entity.name.capitalize}Service.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/business/services/impl/#{writer.entity.name.capitalize}ServiceImpl.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/web/utilities/MessageDTO.java").to be(true)
      expect(File.exists? "#{fs[:path]}/#{writer.send('package_to_path')}/web/controller/api/#{writer.entity.name.capitalize}Controller.java").to be(true)
    end


    after(:each) { Dir.glob(['src']).each { |f| FileUtils.rm_rf f } }
  end

  describe 'helper methods' do

    it 'should return package as a path' do
      expect(writer.send('package_to_path')).to eql 'it/insiel/gcs/progetto'
    end

  end

end