require 'erb'
require 'fileutils'

module Sboot
  class HtmlWriter

    attr_accessor :entity

    def initialize options={}
      @entity = options[:entity]
    end

    def write stack
      stack[:files].each do |file|
        path = "#{stack[:path]}/#{create_path file}"
        create_missing_folders path
        File.open "#{path}/#{file.ext}.html", 'w' do |f|
          f.write ERB.new(getTemplate(file.ext),nil,'-').result(binding)
        end
      end
    end

    private

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

  end
end
