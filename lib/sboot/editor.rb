module Sboot
  class Editor

    attr_accessor :domain_entity, :config, :stack, :code_writer, :html_writer, :test_writer

    def initialize entity, conf_file
      @domain_entity = entity
      @config = Sboot::Config.new conf_file
      @stack = Sboot::Stack.new config: config
      @code_writer = Sboot::CodeWriter.new package: @config['package'], entity: domain_entity, sboot_repo_path: @config['sboot_repo_path']
      @html_writer = Sboot::HtmlWriter.new entity: domain_entity, sboot_repo_path: @config['sboot_repo_path']
      @test_writer = Sboot::TestWriter.new package: @config['package'], entity: domain_entity, sboot_repo_path: @config['sboot_repo_path']
    end

    def publish
      defined_stack = @stack.define_stacks(@domain_entity.environment)
      @code_writer.write(defined_stack[:code])
      @html_writer.write(defined_stack[:html]) if defined_stack[:html][:active]
      @test_writer.write(defined_stack[:test]) if defined_stack[:test][:active]
    end

  end
end
