require 'erb'
require 'fileutils'

module Sboot
  class CodeWriter

    attr_accessor :package, :entity

    def initialize options={}
      @package = options[:package]
      @entity = options[:entity]
    end

    def write stack
      stack[:files].each do |file|
        path = "#{stack[:path]}/#{create_path file}"
        create_missing_folders path
        File.open "#{path}/#{ @entity.name.capitalize unless file.key == :message }#{file.ext}.java", 'w' do |f|
          f.write ERB.new(getTemplate(file.key),nil,'-').result(binding)
        end
      end
    end

    private

    def package_to_path
      @package.gsub(/\./,"/")
    end

    def create_path file
      "#{package_to_path}/#{file.ref}"
    end

    def create_missing_folders path
      FileUtils.mkdir_p path
    end

    def getTemplate template_name
      File.read "#{File.dirname __FILE__}/scaffolds/#{template_name}.erb"
    end

  end
end