module Sboot
  class Editor

    attr_accessor :domain_entity, :config, :stack, :code_writer, :html_writer, :test_writer

    def initialize entity, conf_file
      @domain_entity = entity
      @config = Sboot::Config.new conf_file
      @stack = Sboot::Stack.new config: config
      @code_writer = Sboot::CodeWriter.new package: @config[:package], entity: domain_entity
      @html_writer = Sboot::HtmlWriter.new entity: domain_entity
      @test_writer = Sboot::TestWriter.new package: @config[:package], entity: domain_entity
    end

    def publish
      @code_writer.write(@stack.define_stacks(@domain_entity.environment)[:code])
      @html_writer.write(@stack.define_stacks(@domain_entity.environment)[:html]) if @stack[:html][:active]
      @test_writer.write(@stack.define_stacks(@domain_entity.environment)[:test]) if @stack[:test][:active]
    end

  end
end
