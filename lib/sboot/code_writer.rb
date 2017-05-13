require 'erb'
require 'fileutils'
require 'sboot/source_writer'

module Sboot
    class CodeWriter<SourceWriter

    attr_accessor :package, :entity

    def initialize options={}
      super
      @package = options[:package]
      @entity  = options[:entity]
    end

    def write stack
      stack[:files].each do |file|
          path = "#{stack[:path]}/#{create_path file}"
          write_file "#{path}/#{ @entity.name.split('_').collect(&:capitalize).join unless file.key == :messagedto }#{file.ext}.java", ERB.new(getTemplate(file.key),nil,'-').result(binding)
      end
    end

    private

    def package_to_path
      @package.gsub(/\./,"/")
    end

    def create_path file
      "#{package_to_path}/#{file.ref}"
    end

    def getTemplate template_name
      File.read "#{File.dirname __FILE__}/scaffolds/#{template_name}.erb"
    end

  end
end
