require 'erb'
require 'fileutils'

module Sboot
  class Writer
    attr_accessor :name, :package, :properties

    def initialize(options={})
      raise ArgumentError, ':package non presente' unless options.key? :package
      raise ArgumentError, ':name non presente' unless options.key? :name
      raise ArgumentError, ':properties non presente' unless options.key? :properties

      @name = options[:name]
      @package = options[:package]
      @properties = options[:properties]
    end

    def basic_path
      #"#{File.dirname __FILE__}/generated"
      "#{ Dir.pwd }"
    end

    def package_to_path
      @package.gsub(/\./,"/")
    end

    def persistence
      write_entity 'entity'
      write_repository 'repository'
      puts "create #{name.capitalize}.java in #{package_to_path}/persistence/entities"
      puts "create #{name.capitalize}Repository.java in #{package_to_path}/persistence/repositories"
    end

    def conversion
      persistence
      write_dto 'dto'
      puts "create #{name.capitalize}Dto.java in #{package_to_path}/business/dtos"
    end

    def business
      conversion
      write_service 'service'
      write_service_impl 'serviceimpl'
      puts "create #{name.capitalize}Service.java in #{package_to_path}/business/services"
      puts "create #{name.capitalize}ServiceImpl.java in #{package_to_path}/business/services/impl"
    end

    def backend
      business
      write_controller 'controller'
      puts "create #{name.capitalize}Controller.java in #{package_to_path}/web/controllers"
    end

    def fullstack
      backend
      write_html 'list'
    end

    def api
      persistence
      write_messagedto 'message'
      write_dto 'dto_rest'
      write_service 'service'
      write_service_impl 'serviceimpl'
      write_controller 'controller_rest'
      write_swaggerconfig
    end

    def write path,template,type
      create_missing_folders path
      File.open("#{basic_path}/#{package_to_path}/#{path}/#{@name}#{type ? type : ''}.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_entity(template)
      create_missing_folders "persistence/entities"
      File.open("#{basic_path}/#{package_to_path}/persistence/entities/#{@name}.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_repository(template)
      create_missing_folders "persistence/repositories"
      File.open("#{basic_path}/#{package_to_path}/persistence/repositories/#{@name}Repository.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_dto(template)
      create_missing_folders "business/dtos"
      File.open("#{basic_path}/#{package_to_path}/business/dtos/#{@name}DTO.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_messagedto(template)
      create_missing_folders "business/dtos"
      File.open("#{basic_path}/#{package_to_path}/business/dtos/MessageDTO.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_service template
      create_missing_folders "business/services"
      File.open("#{basic_path}/#{package_to_path}/business/services/#{@name}Service.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_service_impl template
      create_missing_folders "business/services/impl"
      File.open("#{basic_path}/#{package_to_path}/business/services/impl/#{@name}ServiceImpl.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_controller template
      create_missing_folders "web/controllers"
      File.open("#{basic_path}/#{package_to_path}/web/controllers/#{@name}Controller.java", 'w') do |f|
        f.write ERB.new(getTemplate(template),nil,'-').result(binding)
      end
    end

    def write_html template
      create_missing_views
      File.open("#{views_path}/index.html", 'w') do |f|
        f.write ERB.new(getTemplateHtml(template),nil,'-').result(binding)
      end
    end

    def write_swaggerconfig
      create_missing_folders "configurations"
      File.open("#{basic_path}/#{package_to_path}/configurations/SwaggerConfig.java", 'w') do |f|
        f.write ERB.new(getTemplate('swaggerconfig'),nil,'-').result(binding)
      end
    end

    private
    def create_missing_folders relative_path
      FileUtils.mkdir_p "#{basic_path}/#{package_to_path}/#{relative_path}"
    end

    def create_missing_views
      FileUtils.mkdir_p "#{basic_path}/webapp/WEB-INF/views/#{name.downcase}"
    end

    def views_path
      "#{basic_path}/webapp/WEB-INF/views/#{name.downcase}"
    end

    def getTemplate template_name
      File.read "#{File.dirname __FILE__}/scaffolds/#{template_name}.erb"
    end

    def getTemplateHtml template_name
      File.read "#{File.dirname __FILE__}/scaffolds/html/#{template_name}.erb"
    end

  end
end
