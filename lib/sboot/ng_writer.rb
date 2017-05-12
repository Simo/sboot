module Sboot
  class NgWriter

    attr_accessor :entity

    def initialize options={}
      @entity = options[:entity]
    end

    def matches? string, regex
      !!string.match(regex)
    end

  end
end
