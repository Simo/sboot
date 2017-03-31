require "thor"
require "sboot"

module Sboot
  class CLI < Thor
    include Thor::Actions

    source_root "#{File.dirname __FILE__}/scaffolds/"

    desc "generate [ENV] :package :entita' :proprieta'",
         "la flag [ENV] accetta come parametri: fullstack(default),backend,business,conversion,persistence"
    method_options :api => false, :env => "fullstack"
    def init(package)
      writer = Sboot::Writer.new :package => package
      if options[:api]
        writer.api
      else
        writer.fullstack unless options[:env]
        writer.fullstack if options[:env] == 'fullstack'
        writer.backend if options[:env] == 'backend'
        writer.business if options[:env] == 'business'
        writer.convertion if options[:env] == 'convertion'
        writer.persistence if options[:env] == 'persistence'
      end
    end


    desc "generate [ENV] :package :entita' :proprieta'",
      "la flag [ENV] accetta come parametri: fullstack(default),backend,business,conversion,persistence"
      method_options :api => false, :env => "fullstack"
      def generate(package, name, *args)
        properties = generate_attributes args
        writer = Sboot::Writer.new :package => package, :name => name.downcase.capitalize, :properties => properties
        if options[:api]
          writer.api
        else
          writer.fullstack unless options[:env]
          writer.fullstack if options[:env] == 'fullstack'
          writer.backend if options[:env] == 'backend'
          writer.business if options[:env] == 'business'
          writer.convertion if options[:env] == 'convertion'
          writer.persistence if options[:env] == 'persistence'
        end
      end

      private
      def generate_attributes args
        properties = []
        args.each do |arg|
          array = arg.split(":")
          if array.length == 1
            name = array[0].downcase
            type = 'String'
          else
            name = array[0].downcase
            if array[1].downcase == 'string' || array[1].downcase == 'text' || array[1].downcase == 'varchar' || array[1].downcase == 'varchar2'
              type = 'String'
            end
            if array[1].downcase == 'number' || array[1].downcase == 'long'
              type = 'Long'
            end
            if array[1].downcase == 'int' || array[1].downcase == 'integer'
              type = 'Integer'
            end
          end
          property = {name: name,type: type}
          properties << property
        end
        properties
      end
  end
end
