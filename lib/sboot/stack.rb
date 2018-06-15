module Sboot
  class Stack

    attr_accessor :config, :persistence, :conversion, :business, :backend, :api, :fullstack, :html, :ng, :fulltest, :apitest, :servicetest

    def initialize options={}
      @config = options[:config]
      @persistence = [:entity, :repository]
      @conversion = [:entity, :repository, :dto]
      @business = [:entity, :repository, :dto, :exception, :service, :service_impl]
      @backend = [:entity, :repository, :dto, :exception, :service, :service_impl, :controller]
      @api = [:entity, :repository, :dto_rest, :exception, :service, :service_impl, :messagedto, :controller_rest]
      @fullstack = [:entity, :repository, :dto, :exception, :service, :service_impl, :controller]

      @html = [:layout, :index, :show, :new, :edit, :form]
      @ng = [:ng_component_elenco, :ng_component_elenco_html, :ng_component_dettaglio, :ng_component_dettaglio_html,:ng_component_form, :ng_component_form_html, :ng_component_form_reactive, :ng_component_form_reactive_html, :ng_service, :ng_interface]

      @fulltest = [:controller_test, :service_test]
      @apitest = [:resource_rest_test, :service_test]
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
      environment = env.to_sym unless env == 'ng'
      environment = :api if env == 'ng'
      {files: create_filetype_array(environment), path: config['main_path'], active: true }
    end

    def create_html_stack env
      stack = {files: create_filetype_array(:html), path: config['html_path'], active: html_needed?(env) } unless env == 'ng'
      stack = {files: create_filetype_array(:ng), path: config['ng_path'], active: html_needed?(env) } if env == 'ng'
      stack
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
      env == 'fullstack' || env == 'ng'
    end

    def test_needed? env
      env == 'fullstack' || env == 'api' || env == 'backend' || env == 'business' || env == 'ng'
    end

    def determine_test_level env
      result = Symbol
      result = :fulltest if env == 'fullstack' || env == 'backend'
      result = :apitest if env == 'api'
      result = :apitest if env == 'ng'
      result = :servicetest if env == 'business'
      result
    end

  end
end
