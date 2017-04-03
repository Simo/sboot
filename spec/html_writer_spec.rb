require 'spec_helper'

describe Sboot::HtmlWriter do

  subject(:domain_entity){ DomainEntity.new name: 'Casa', name_pluralized: 'Case', properties: [{name: 'indirizzo',type: 'String'},{name: 'civico',type: 'Long'}], environment: 'fullstack' }
  subject(:writer){ writer = Sboot::HtmlWriter.new entity: domain_entity }

  describe 'initialization' do

    it 'should be correctly initialized' do
      expect(writer.entity).to be_an_instance_of DomainEntity
    end

  end

  describe 'writing files' do

    it "should write layout file" do
      stack = {files: [FileType.new(key: :layout, reference: 'layouts', extension: 'layout')], path: 'src/main/webapp/WEB-INF/views'}
      writer.write stack
      expect(File.exists? 'src/main/webapp/WEB-INF/views/layouts/layout.html').to be(true)
    end

    it "should write index file" do
      stack = {files: [FileType.new(key: :index, reference: 'index', extension: 'index')], path: 'src/main/webapp/WEB-INF/views'}
      writer.write stack
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/index.html').to be(true)
    end

    it "should write show file" do
      stack = {files: [FileType.new(key: :show, reference: 'show', extension: 'show')], path: 'src/main/webapp/WEB-INF/views'}
      writer.write stack
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/show.html').to be(true)
    end

    it "should write new file" do
      stack = {files: [FileType.new(key: :new, reference: 'new', extension: 'new')], path: 'src/main/webapp/WEB-INF/views'}
      writer.write stack
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/new.html').to be(true)
    end

    it "should write edit file" do
      stack = {files: [FileType.new(key: :edit, reference: 'edit', extension: 'edit')], path: 'src/main/webapp/WEB-INF/views'}
      writer.write stack
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/edit.html').to be(true)
    end

    it "should write form file" do
      stack = {files: [FileType.new(key: :form, reference: 'form', extension: 'form')], path: 'src/main/webapp/WEB-INF/views'}
      writer.write stack
      expect(File.exists? 'src/main/webapp/WEB-INF/views/casa/form.html').to be(true)
    end

    after(:each) { Dir.glob(['src']).each { |f| FileUtils.rm_rf f } }

  end
end