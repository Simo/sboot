require 'spec_helper'

describe Sboot::Editor do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}], environment: 'fullstack' }
  subject(:editor){ Sboot::Editor.new domain_entity, "#{File.dirname __FILE__}/assets/.sbootconf" }
  subject(:fs){ {code: {files: [FileType.new(key: :entity, reference: 'persistence/entities', extension: ''),
                                      FileType.new(key: :repository, reference: 'persistence/repositories', extension: 'Repository'),
                                      FileType.new(key: :dto, reference: 'business/dtos', extension: 'DTO'),
                                      FileType.new(key: :exception, reference: 'business/exceptions', extension: 'EntityNotFoundException'),
                                      FileType.new(key: :service, reference: 'business/services', extension: 'Service'),
                                      FileType.new(key: :service_impl, reference: 'business/services/impl', extension: 'ServiceImpl'),
                                      FileType.new(key: :controller, reference: 'web/controller', extension: 'Controller')], path: 'src/main/java', active: true},
                        html: {files: [FileType.new(key: :layout, reference: 'layouts', extension: 'layout'),
                                       FileType.new(key: :index, reference: 'index', extension: 'index'),
                                       FileType.new(key: :show, reference: 'show', extension: 'show'),
                                       FileType.new(key: :new, reference: 'new', extension: 'new'),
                                       FileType.new(key: :edit, reference: 'edit', extension: 'edit'),
                                       FileType.new(key: :form, reference: 'form', extension: 'form')], path: 'src/main/webapp/WEB-INF/views', active: true},
                        test: {files: [FileType.new(key: :service_test, reference: 'business/services', extension: 'ServiceTest'),
                                      FileType.new(key: :controller_test, reference: 'web/controllers', extension: 'ControllerTestIT')], path: 'src/test/java', active: true}}}

  describe 'initialization' do

    it "should be correctly initialized" do
      expect(editor).to be_an_instance_of Sboot::Editor
      expect(editor.domain_entity).to be_an_instance_of DomainEntity
      expect(editor.domain_entity.name).to eql'Casa'
      expect(editor.domain_entity.name_pluralized).to eql'Case'
      expect(editor.domain_entity.properties.length).to eql 2
      expect(editor.domain_entity.environment).to eql "fullstack"
      expect(editor.code_writer).to be_an_instance_of Sboot::CodeWriter
      expect(editor.html_writer).to be_an_instance_of Sboot::HtmlWriter
      expect(editor.test_writer).to be_an_instance_of Sboot::TestWriter
    end

  end

end