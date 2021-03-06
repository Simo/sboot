require 'erb'

module Sboot
  class ConfigWriter
    attr_accessor :project_name, :package

    def initialize(options={})
      raise ArgumentError, ':package non presente' unless options.key? :package
      @project_name = options[:project_name]
      @package = options[:package]
    end

    def write
      File.open('.sbootconf','w') do |f|
        f.write ERB.new(get_config_file).result(binding)
      end
    end

    protected

    def get_config_file
      File.read "#{File.dirname __FILE__}/scaffolds/config/config.erb"
    end

  end
end
