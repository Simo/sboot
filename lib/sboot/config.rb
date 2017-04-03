require "strscan"

module Sboot
  class Config

    NAME = /[\w\.]+/
    WHITESPACE =/\s+/

    def initialize(config_file)
      @config_data = File.read(config_file)
      @config = {}
      parse_file
    end

    def [](name)
      @config[name]
    end

    def key value
      @config.key(value)
    end

    private

    def parse_file
      @line = 0
      @scanner = StringScanner.new(@config_data)
      until @scanner.eos?
        @line += 1
        parse_item
      end
    end

    def parse_item
      name = @scanner.scan(NAME)
      fail syntax_error unless name

      @scanner.skip(WHITESPACE)
      fail syntax_error unless @scanner.scan(/=/)

      @scanner.skip(WHITESPACE)

      quote = @scanner.scan(/"|'/)
      fail syntax_error unless quote

      value = @scanner.scan_until(/(?=#{quote})/)
      fail syntax_error unless value

      @scanner.scan(/#{quote}/)

      @config[name] = value

      @scanner.skip(WHITESPACE)
    end

    class SyntaxError < StandardError; end

    def syntax_error
      SyntaxError.new("Errore di sintassi alla riga #{@line} (pos.#{@scanner.pos})")
    end

  end

end

