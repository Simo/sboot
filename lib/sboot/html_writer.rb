require 'erb'
require 'fileutils'

module Sboot
  class HtmlWriter
    include Sboot::HtmlHelper

    attr_accessor :entity

    def initialize options={}
      @entity = options[:entity]
    end

    def write stack
      create_package_json unless package_json_exists?
      stack[:files].each do |file|
        path = "#{stack[:path]}/#{create_path file}"
        create_missing_folders path
        File.open "#{path}/#{file.ext}.html", 'w' do |f|
          f.write ERB.new(getTemplate(file.key),nil,'-').result(binding)
        end
      end
    end

    private

    def create_package_json
      create_missing_folders 'src/main/webapp/resources'
      File.open "src/main/webapp/resources/package.json", 'w' do |f|
        f.write ERB.new(getPackageJson,nil,'-').result(binding)
      end
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

    def create_missing_folders path
      FileUtils.mkdir_p path
    end

    def getTemplate template_name
      File.read "#{File.dirname __FILE__}/scaffolds/html/#{template_name}.erb"
    end

    def getPackageJson
      File.read "#{File.dirname __FILE__}/scaffolds/config/package.erb"
    end

  end
end
