require 'erb'
require 'fileutils'
require 'sboot/source_writer'

module Sboot
  class HtmlWriter<SourceWriter
    include Sboot::HtmlHelper

    attr_accessor :entity

    def initialize options={}
      super
      @entity = options[:entity]
    end

    def write stack
      create_package_json unless package_json_exists?
      unless @entity.environment == 'ng'
        stack[:files].each do |file|
          path = "#{stack[:path]}/#{create_path file}"
          write_file "#{path}/#{file.ext}.html", ERB.new(getTemplate(file.key),nil,'-').result(binding)
        end
      else
        stack[:files].each do |file|
          path = "#{stack[:path]}/src/app/#{create_path_ng file}"
          File.write path, ERB.new(getTemplateNg(file.key),nil,'-').result(binding)
        end
      end
    end

    private

    def create_package_json
        write_file "src/main/webapp/resources/package.json", ERB.new(getPackageJson,nil,'-').result(binding)
    end

    def package_json_exists?
      File.exists? "src/main/webapp/resources/package.json"
    end

    def create_path file
      if file.ref == file.ext
        "#{@entity.name.downcase}"
      else
        "#{file.ref}"
      end
    end

    def create_path_ng file
      a = file.path.split '_'
      if a.length == 2
        if a[0] == 'entities'
          file_path = "#{@entity.collection_downcase}/#{@entity.collection_downcase}-#{a[1]}/#{@entity.collection_downcase}-#{a[1]}.#{file.ext}"
        else
          file_path = "#{@entity.collection_downcase}/#{@entity.single_downcase}-#{a[1]}/#{@entity.single_downcase}-#{a[1]}.#{file.ext}"
        end
      end
      if a.length == 1
        file_path = "#{@entity.collection_downcase}/#{@entity.single_downcase}.#{file.ext}"
      end
      file_path
    end

    def getTemplate template_name
      File.read "#{File.dirname __FILE__}/scaffolds/html/#{template_name}.erb"
    end

    def getPackageJson
      File.read "#{File.dirname __FILE__}/scaffolds/config/package.erb"
    end

  end
end
