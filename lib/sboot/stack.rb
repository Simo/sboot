module Sboot
  class Stack

    attr_accessor :config, :persistence, :conversion, :business, :backend, :api, :fullstack, :html, :fulltest, :apitest, :servicetest

    def initialize options={}
      @config = options[:config]
      @persistence = [:entity, :repository]
      @conversion = [:entity, :repository, :dto]
      @business = [:entity, :repository, :dto, :exception, :service, :service_impl]
      @backend = [:entity, :repository, :dto, :exception, :service, :service_impl, :controller]
      @api = [:entity, :repository, :dto_rest, :exception, :service, :service_impl, :message, :controller_rest]
      @fullstack = [:entity, :repository, :dto, :exception, :service, :service_impl, :controller]
      @html = [:layout, :index, :show, :new, :edit, :form]
      @fulltest = [:controller_test, :service_test]
      @apitest = [:controller_rest_test, :service_test]
      @servicetest = [:service_test]
    end

    def [](key)
      send("#{key}")
    end

    def define_stacks env
      {code: create_code_stack(env),
       html: create_html_stack(env),
       test: create_test_stack(env)}
    end

    private

    def create_code_stack env
      {files: create_filetype_array(env.to_sym), path: config['main_path'], active: true }
    end

    def create_html_stack env
      {files: create_filetype_array(:html), path: config['html_path'], active: html_needed?(env) }
    end

    def create_test_stack env
      {files: create_filetype_array(determine_test_level(env)), path: config['test_path'], active: test_needed?(env) }
    end

    def create_filetype_array env
      array = []
      if respond_to?("#{env}")
        send("#{env}").each do |element|
          filetype = FileType.new key: element, reference: @config["#{element}.path"], extension: @config["#{element}.extension"]
          array << filetype
        end
      end
      array
    end

    def html_needed? env
      env == 'fullstack'
    end

    def test_needed? env
      env == 'fullstack' || env == 'api' || env == 'backend' || env == 'business'
    end

    def determine_test_level env
      result = Symbol
      result = :fulltest if env == 'fullstack' || env == 'backend'
      result = :apitest if env == 'api'
      result = :servicetest if env == 'business'
      result
    end

  end
end
